// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**

 * @title BatchSelling1155for Multiple nft
 * @dev Note its BatchSelling1155 contract for Multiple nft batch sell
 * 
 * 
 */


contract BatchSelling1155 {
    using SafeMath for uint256;
    // using counter to count ids 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // struct tupple fixed sale 
    struct FixedSale {
        address nftSeller;
        address nftBuyer;
        address erc20;
        uint256[] amount;
        uint256 salePrice;
    }
    // sale info
    struct SaleInfo {
        address _nftContractAddress;
        uint256 _tokenID;
    }
    //Mapping details 
    mapping(uint256 => uint256[]) batchIdDetails;
    mapping(address => mapping(uint256 => FixedSale)) nftContractFixedSale;
    mapping(address => mapping(uint256 => uint256)) public nftSaleStatus;
    mapping(address => mapping(uint256 => uint256)) indexFixedSaleNFT;
    mapping(uint256 => uint256) indexTokenIds;
    mapping(address => uint256[]) tokenIdsInfo;

    SaleInfo[] fixedSaleNFT;

    bytes4 public constant IID_IERC1155 = type(IERC1155).interfaceId;
    // event to fixed sale
    event NftFixedSale(
        address nftContractAddress,
        address nftSeller,
        address erc20,
        uint256 tokenId,
        uint256[] amount,
        uint256 salePrice,
        uint256 timeOfSale
    );
    //Cancel event 
    event CancelNftFixedSale(
        address nftContractAddress,
        address nftSeller,
        uint256 tokenId
    );
    // Event to fixed sale price update 
    event NftFixedSalePriceUpdated(
        address nftContractAddress,
        uint256 tokenId,
        uint256 updateSalePrice
    );
    // Event to BuyfromFixed sale
    event NftBuyFromFixedSale(
        address nftContractAddress,
        address nftBuyer,
        uint256[] amount,
        uint256 tokenId,
        uint256 nftBuyPrice
    );
//Modifier is nft in fixed sale checking 
    modifier isNftInFixedSale(address _nftContractAddress, uint256 _tokenId) {
        require(
            nftSaleStatus[_nftContractAddress][_tokenId] == 1,
            "Nft not in fixed sale"
        );
        _;
    }
// is Sale is startby owner 
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
    // is Sale reset by owner 
    modifier isSaleResetByOwner(address _nftContractAddress, uint256 _tokenId) {
        require(
            msg.sender ==
                nftContractFixedSale[_nftContractAddress][_tokenId].nftSeller,
            "You are not nft owner"
        );
        _;
    }
// checking is nft  is approved 
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
    // modifier ot buyer price met sell price 
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

    // NFT FIXED SALE
    //function of fixed sale 
    function nftFixedSale(
        address _nftContractAddress,
        address _erc20,
        uint256[] memory _batchIds,
        uint256[] memory _amount,
        uint256 _salePrice,
        bytes memory _data
    )
        external
        isSaleStartByOwner(_nftContractAddress, _batchIds)
        isContractApprove(_nftContractAddress)
        priceGreaterThanZero(_salePrice)
    {
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();

        batchIdDetails[_tokenId] = _batchIds;
        indexTokenIds[_tokenId] = tokenIdsInfo[msg.sender].length;
        tokenIdsInfo[msg.sender].push(_tokenId);

        nftContractFixedSale[_nftContractAddress][_tokenId] = FixedSale(
            msg.sender,
            address(0),
            _erc20,
            _amount,
            _salePrice
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
    //function of cancel fixed sale
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
    //function to updateFixedSale
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
    //Function to buyfrom fixed sale 
    function buyFromFixedSale(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _amount,
        bytes memory _data
    )
        external
        payable
        isNftInFixedSale(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_amount)
        buyPriceMeetSalePrice(_nftContractAddress, _tokenId, _amount)
    {
        uint256[] memory _nftAmount = nftContractFixedSale[_nftContractAddress][
            _tokenId
        ].amount;
        address nftContractAddress = _nftContractAddress;
        uint256 tokenID = _tokenId;

        IERC1155(nftContractAddress).safeBatchTransferFrom(
            address(this),
            msg.sender,
            batchIdDetails[tokenID],
            _nftAmount,
            _data
        );

        _checkFixedSale(nftContractAddress, tokenID);

        _isTokenOrCoin(
            nftContractFixedSale[nftContractAddress][tokenID].nftSeller,
            nftContractFixedSale[nftContractAddress][tokenID].erc20,
            nftContractFixedSale[nftContractAddress][tokenID].salePrice,
            false
        );

        emit NftBuyFromFixedSale(
            nftContractAddress,
            msg.sender,
            _nftAmount,
            tokenID,
            _amount
        );
    }
    //Function to getfixed sale nft 
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
    //function to return value 
    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external pure returns (bytes4) {
        return 0xf23a6e61;
    }
    //function to return batch value 
    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external pure returns (bytes4) {
        return 0xbc197c81;
    }
    //function to retrurn token or coin 
    function _isTokenOrCoin(
        address _nftSeller,
        address _erc20,
        uint256 _buyAmount,
        bool auction
    ) internal {
        if (_erc20 != address(0)) {
            _tokenAmountTransfer(_nftSeller, _erc20, _buyAmount);
        } else {
            _nativeAmountTransfer(_nftSeller, _buyAmount);
        }
    }
    //function to amount transfer 
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
    //function to amount transfer 
    function _nativeAmountTransfer(address _nftSeller, uint256 _buyAmount)
        internal
    {
        (bool success, ) = _nftSeller.call{value: _buyAmount}("");
        require(success, "refund failed");
    }
    //function to check fixed sell 
    function _checkFixedSale(address _nftContractAddress, uint256 _tokenId)
        internal
    {
        nftSaleStatus[_nftContractAddress][_tokenId] = 0;
        delete fixedSaleNFT[(indexFixedSaleNFT[_nftContractAddress][_tokenId])];

        nftContractFixedSale[_nftContractAddress][_tokenId].nftBuyer = msg
            .sender;
        delete tokenIdsInfo[msg.sender][(indexTokenIds[_tokenId])];
    }
    //function to check owner of nft 
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
    // function to nft address
    function isERC1155(address _nftContractAddress)
        external
        view
        returns (bool)
    {
        return IERC1155(_nftContractAddress).supportsInterface(IID_IERC1155);
    }

    receive() external payable {}
}
