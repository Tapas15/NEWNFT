// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BatchSelling1155 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public makerFee;
    address public owner;

    struct FixedSale {
        address nftSeller;
        address nftBuyer;
        address erc20;
        address royaltyReciever;
        uint256[] amount;
        uint256 copies;
        uint256 salePrice;
        uint256 royalty;
    }

    struct SaleInfo {
        address _nftContractAddress;
        uint256 _tokenID;
    }

    mapping(uint256 => uint256[]) batchIdDetails;
    mapping(address => mapping(uint256 => FixedSale)) nftContractFixedSale;
    mapping(address => mapping(uint256 => uint256)) public nftSaleStatus;
    mapping(address => mapping(uint256 => uint256)) indexFixedSaleNFT;
    mapping(uint256 => uint256) indexTokenIds;
    mapping(address => uint256[]) tokenIdsInfo;

    SaleInfo[] fixedSaleNFT;

    bytes4 public constant IID_IERC1155 = type(IERC1155).interfaceId;

    event NftFixedSale(
        address nftContractAddress,
        address nftSeller,
        address erc20,
        uint256 tokenId,
        uint256[] amount,
        uint256 salePrice,
        uint256 timeOfSale
    );

    event CancelNftFixedSale(
        address nftContractAddress,
        address nftSeller,
        uint256 tokenId
    );

    event NftFixedSalePriceUpdated(
        address nftContractAddress,
        uint256 tokenId,
        uint256 updateSalePrice
    );

    event NftBuyFromFixedSale(
        address nftContractAddress,
        address nftBuyer,
        uint256[] amount,
        uint256 tokenId,
        uint256 nftBuyPrice
    );

    modifier checkNFTAmount(uint256[] memory _nftAmount, uint256 _copies) {
        require(checkAmount(_nftAmount, _copies), "nftAmount not correct");
        _;
    }

    modifier isNftInFixedSale(address _nftContractAddress, uint256 _tokenId) {
        require(
            nftSaleStatus[_nftContractAddress][_tokenId] == 1,
            "Nft not in fixed sale"
        );
        _;
    }

    modifier isSaleStartByOwner(
        address _nftContractAddress,
        uint256[] memory _batchId
    ) {
        require(
            _ownerOf(_nftContractAddress, _batchId),
            "You are not nft owner"
        );
        _;
    }

    modifier isSaleResetByOwner(address _nftContractAddress, uint256 _tokenId) {
        require(
            msg.sender ==
                nftContractFixedSale[_nftContractAddress][_tokenId].nftSeller,
            "You are not nft owner"
        );
        _;
    }

    modifier isContractApprove(address _nftContractAddress) {
        require(
            IERC1155(_nftContractAddress).isApprovedForAll(
                msg.sender,
                address(this)
            ),
            "Nft not approved to contract"
        );
        _;
    }

    modifier isCopiesSame(uint256 _copies, uint256[] memory _amount) {
        (checkCopiesCount(_copies, _amount), "no of copies not match");
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not a owner");
        _;
    }

    modifier buyPriceMeetSalePrice(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _buyPrice
    ) {
        require(
            _buyPrice >=
                (nftContractFixedSale[_nftContractAddress][_tokenId].salePrice),
            "buy Price not enough"
        );
        _;
    }

    modifier priceGreaterThanZero(uint256 _price) {
        require(_price > 0, "Price cannot be 0");
        _;
    }

    constructor(address _owner, uint256 _makerFee) {
        owner = _owner;
        makerFee = _makerFee;
    }

    // owner Function

    function setMakerFee(uint256 _makerFee) external onlyOwner {
        makerFee = _makerFee;
    }

    function setOwner(address _owner) external onlyOwner {
        owner = _owner;
    }

    // NFT FIXED SALE

    function nftFixedSale(
        address _nftContractAddress,
        address _erc20,
        address _royaltyReciever,
        uint256[] memory _batchIds,
        uint256[] memory _amount,
        uint256 _copies,
        uint256 _salePrice,
        uint256 _royalty,
        bytes memory _data
    )
        external
        isSaleStartByOwner(_nftContractAddress, _batchIds)
        isContractApprove(_nftContractAddress)
        priceGreaterThanZero(_salePrice)
        isCopiesSame(_copies, _amount)
    {
        address nftContractAddress = _nftContractAddress;
        address erc20 = _erc20;
        address royaltyReciever = _royaltyReciever;
        uint256[] memory batchIds = _batchIds;
        uint256[] memory amount = _amount;
        uint256 copies = _copies;
        uint256 salePrice = _salePrice;
        uint256 royalty = _royalty;
        bytes memory data = _data;

        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();

        batchIdDetails[_tokenId] = batchIds;
        indexTokenIds[_tokenId] = tokenIdsInfo[msg.sender].length;
        tokenIdsInfo[msg.sender].push(_tokenId);

        _fixedSale(
            nftContractAddress,
            erc20,
            royaltyReciever,
            batchIds,
            amount,
            copies,
            salePrice,
            royalty,
            _tokenId,
            data
        );
    }

    function cancelFixedsale(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256[] memory _amount,
        bytes memory _data
    )
        external
        isNftInFixedSale(_nftContractAddress, _tokenId)
        isSaleResetByOwner(_nftContractAddress, _tokenId)
    {
        IERC1155(_nftContractAddress).safeBatchTransferFrom(
            msg.sender,
            address(this),
            batchIdDetails[_tokenId],
            _amount,
            _data
        );

        nftSaleStatus[_nftContractAddress][_tokenId] = 0;

        delete fixedSaleNFT[(indexFixedSaleNFT[_nftContractAddress][_tokenId])];
        delete tokenIdsInfo[msg.sender][(indexTokenIds[_tokenId])];

        emit CancelNftFixedSale(_nftContractAddress, msg.sender, _tokenId);
    }

    function updateFixedSalePrice(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _updateSalePrice
    )
        external
        isNftInFixedSale(_nftContractAddress, _tokenId)
        isSaleResetByOwner(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_updateSalePrice)
    {
        nftContractFixedSale[_nftContractAddress][_tokenId]
            .salePrice = _updateSalePrice;

        emit NftFixedSalePriceUpdated(
            _nftContractAddress,
            _tokenId,
            _updateSalePrice
        );
    }

    function buyFromFixedSale(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _amount,
        uint256 _copies,
        uint256[] memory _nftAmount,
        bytes memory _data
    )
        external
        payable
        isNftInFixedSale(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_amount)
        buyPriceMeetSalePrice(_nftContractAddress, _tokenId, _amount)
        checkNFTAmount(_nftAmount, _copies)
    {
        address nftContractAddress = _nftContractAddress;
        uint256 tokenID = _tokenId;
        bytes memory data = _data;
        uint256 amount = _amount;
        uint256 copies = _copies;
        uint256[] memory nftAmount = _nftAmount;

        require(
            nftContractFixedSale[nftContractAddress][tokenID].copies >= copies,
            "copies not exist"
        );

        IERC1155(nftContractAddress).safeBatchTransferFrom(
            address(this),
            msg.sender,
            batchIdDetails[tokenID],
            nftAmount,
            data
        );

        _checkFixedSale(nftContractAddress, tokenID, copies);

        _isTokenOrCoin(
            nftContractFixedSale[nftContractAddress][tokenID].royaltyReciever,
            nftContractFixedSale[nftContractAddress][tokenID].nftSeller,
            nftContractFixedSale[nftContractAddress][tokenID].erc20,
            nftContractFixedSale[nftContractAddress][tokenID].salePrice,
            nftContractFixedSale[nftContractAddress][tokenID].royalty
        );

        emit NftBuyFromFixedSale(
            nftContractAddress,
            msg.sender,
            nftAmount,
            tokenID,
            amount
        );
    }

    function getFixedSaleNFT() external view returns (SaleInfo[] memory) {
        return fixedSaleNFT;
    }

    function getFixedSale(address _nftContractAddress, uint256 _tokenId)
        external
        view
        returns (FixedSale memory)
    {
        return nftContractFixedSale[_nftContractAddress][_tokenId];
    }

    function getTokenId() external view returns (uint256[] memory) {
        return tokenIdsInfo[msg.sender];
    }

    function getCurrentTokenId() external view returns (uint256)
    {
       return _tokenIds.current();
    }

    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external pure returns (bytes4) {
        return 0xf23a6e61;
    }

    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external pure returns (bytes4) {
        return 0xbc197c81;
    }

    function _isTokenOrCoin(
        address _royaltyReciever,
        address _nftSeller,
        address _erc20,
        uint256 _buyAmount,
        uint256 _royalty
    ) internal {
        uint256 taxAmount = (_buyAmount * makerFee) / uint256(100);
        uint256 royalty = (_buyAmount * _royalty) / uint256(100);

        uint256 userAmount = _buyAmount - (taxAmount + royalty);

        if (_erc20 != address(0)) {
            _tokenAmountTransfer(_nftSeller, _erc20, userAmount);
            _tokenAmountTransfer(owner, _erc20, taxAmount);
            _tokenAmountTransfer(_royaltyReciever, _erc20, royalty);
        } else {
            _nativeAmountTransfer(_nftSeller, userAmount);
            _nativeAmountTransfer(owner, taxAmount);
            _nativeAmountTransfer(_royaltyReciever, royalty);
        }
    }

    function _tokenAmountTransfer(
        address _nftSeller,
        address _erc20,
        uint256 _buyAmount
    ) internal {
        require(
            IERC20(_erc20).transferFrom(msg.sender, _nftSeller, _buyAmount),
            "allowance not enough"
        );
    }

    function _nativeAmountTransfer(address _nftSeller, uint256 _buyAmount)
        internal
    {
        (bool success, ) = _nftSeller.call{value: _buyAmount}("");
        require(success, "refund failed");
    }

    function _checkFixedSale(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _copies
    ) internal {
        nftContractFixedSale[_nftContractAddress][_tokenId].copies -= _copies;

        if (nftContractFixedSale[_nftContractAddress][_tokenId].copies == 0) {
            nftSaleStatus[_nftContractAddress][_tokenId] = 0;
            delete fixedSaleNFT[
                (indexFixedSaleNFT[_nftContractAddress][_tokenId])
            ];

            nftContractFixedSale[_nftContractAddress][_tokenId].nftBuyer = msg
                .sender;

            address userAddress = nftContractFixedSale[_nftContractAddress][
                _tokenId
            ].nftSeller;
            delete tokenIdsInfo[userAddress][(indexTokenIds[_tokenId])];
        }
    }

    function checkAmount(uint256[] memory _nftAmount, uint256 _copies)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < _nftAmount.length; i++) {
            if (_nftAmount[i] != _copies) {
                return false;
            }
        }
        return true;
    }

    function checkCopiesCount(uint256 _copies, uint256[] memory _amount)
        internal
        returns (bool)
    {
        for (uint256 i = 0; i < _amount.length; i++) {
            if (_copies != _amount[i]) {
                return false;
            }
        }

        return true;
    }

    function _ownerOf(address _nftContractAddress, uint256[] memory _batchId)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _batchId.length; i++) {
            require(
                IERC1155(_nftContractAddress).balanceOf(
                    msg.sender,
                    _batchId[i]
                ) != 0,
                "You are not nft owner"
            );
        }

        return true;
    }

    function isERC1155(address _nftContractAddress)
        external
        view
        returns (bool)
    {
        return IERC1155(_nftContractAddress).supportsInterface(IID_IERC1155);
    }

    function _fixedSale(
        address _nftContractAddress,
        address _erc20,
        address _royaltyReciever,
        uint256[] memory _batchIds,
        uint256[] memory _amount,
        uint256 _copies,
        uint256 _salePrice,
        uint256 _royalty,
        uint256 _tokenId,
        bytes memory _data
    ) internal {
        nftContractFixedSale[_nftContractAddress][_tokenId] = FixedSale(
            msg.sender,
            address(0),
            _erc20,
            _royaltyReciever,
            _amount,
            _copies,
            _salePrice,
            _royalty
        );

        nftSaleStatus[_nftContractAddress][_tokenId] = 1;

        indexFixedSaleNFT[_nftContractAddress][_tokenId] = fixedSaleNFT.length;
        fixedSaleNFT.push(SaleInfo(_nftContractAddress, _tokenId));

        IERC1155(_nftContractAddress).safeBatchTransferFrom(
            msg.sender,
            address(this),
            _batchIds,
            _amount,
            _data
        );

        emit NftFixedSale(
            _nftContractAddress,
            msg.sender,
            _erc20,
            _tokenId,
            _amount,
            _salePrice,
            block.timestamp
        );
    }

    receive() external payable {}
}
