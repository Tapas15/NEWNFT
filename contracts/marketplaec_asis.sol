// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./AVERAEC20.sol";
//import "./MultipleNFT.sol";
import "./NFT.sol";


contract MarketPlace {
    
//    using SafeMath for uint256;
    
    AREVEAToken token;
    NFT nft;
   //MultipleNFT MNFT;
  
    //keep the record for tokenID is listed on sale or not
    mapping(uint256 => bool) public tokenIdForSale;

    mapping(uint256 => uint256) public tokenprice;
    
    mapping(uint256 => address) private nftonwer;
    
    
         address public contractaddress= address(this);

function nftSale(uint256 _tokenId,uint256 _tokenprice, bool forSale) external {
       // require(msg.sender == nft.ownerOf(_tokenId),"Only owners can change this status");
        
        tokenIdForSale[_tokenId] = forSale;
        tokenprice[_tokenId] = _tokenprice;
        nftonwer[_tokenId] = (msg.sender);
        
    }    
   
    function nftBuy(uint256 _tokenId) public {
        require(tokenIdForSale[_tokenId],"Token must be on sale first");

        address nftowner=nftonwer[_tokenId];
        uint nftPrice = tokenprice[_tokenId];
        require(token.allowance(msg.sender, address(this)) >= nftPrice, "Insufficient allowance.");
        require(token.balanceOf(msg.sender) >= nftPrice, "Insufficient balance.");
        
        token.transferFrom(msg.sender, nft.ownerOf(_tokenId), nftPrice);
        nft.transferFrom(nftowner, msg.sender, _tokenId);

    }

}