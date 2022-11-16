// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract NFT is ERC721Enumerable, Ownable, ERC2981 {
    using Strings for uint256;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bool public paused = false;

    mapping(uint256 => string) tokenMetadataCID;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    // public
    function mint(
        address _to,
        address receiver,
        string memory _uri,
        uint96 feeNumerator
    ) external returns (uint256) {
        require(!paused);

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(_to, newTokenId);
        tokenMetadataCID[newTokenId] = _uri;

        _setTokenRoyalty(newTokenId, receiver, feeNumerator);

        return newTokenId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return tokenMetadataCID[tokenId];
    }

    function pause(bool _state) external onlyOwner {
        paused = _state;
    }
}
