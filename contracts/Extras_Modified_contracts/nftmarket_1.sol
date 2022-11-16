// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721.sol";

import "./AVERAEC20.sol";


contract NFTMarketPlace  {
    
    ERC20 token;
    ERC721  NFT;
  
    //keep the record for tokenID is listed on sale or not
    mapping(uint256 => bool) public tokenIdForSale;

    mapping(uint256 => uint256) public tokenprice;

    mapping(uint256 => address) private nftonwer;
    
    
    constructor (address tokenAddress, address NFTAddress)  {
        token = ERC20(tokenAddress);
        NFT = ERC721(NFTAddress);
       
    
    }
     address public contractaddress= address(this);

    event registerDepositer(  string _owner ,  uint _NFTId , uint _blocktimestamp , uint _price   ) ;//defined an event to provide details of owner of NFT
    
    struct depositer{// structure will take the values related to owner of NFT
string owner;
address depositerAddress;
uint nftid;
uint nftRewardPoint;
bool nftRegistered;
uint timeStampnftRegister;
uint priceOfNft;
}

mapping (uint=>depositer) depositerMap;

function listinMarketPlace(string memory _owner, uint _nftid, uint _price)public{      //function is create to deposite the NFT
  require(msg.sender == NFT.ownerOf(_nftid),"Only owners can change this status");
    require(depositerMap[_nftid].nftRegistered!= true);
    depositerMap[_nftid].owner=_owner;
    
    depositerMap[_nftid].nftid=_nftid;
    depositerMap[_nftid].timeStampnftRegister=block.timestamp;
    depositerMap[_nftid].priceOfNft=_price;
    depositerMap[_nftid].nftRegistered= true;
    depositerMap[_nftid].nftRewardPoint = 0 ; 
 
    emit registerDepositer ( _owner , _nftid , block.timestamp , _price ) ; //emitted the event as mentioned abut
}

function getDetails(uint _X) public view returns(string memory, uint, uint, uint, bool){
   return (depositerMap[_X].owner,
    depositerMap[_X].nftid,
    depositerMap[_X].timeStampnftRegister,//store the time of deployment of NFT
    depositerMap[_X].priceOfNft,
    depositerMap[_X].nftRegistered);

}


    function nftSale(uint256 _tokenId,uint256 _tokenprice, bool forSale) external {
        require(msg.sender == NFT.ownerOf(_tokenId),"Only owners can change this status");
        tokenIdForSale[_tokenId] = forSale;
        tokenprice[_tokenId] = _tokenprice;
        nftonwer[_tokenId] = msg.sender;
        
    }
    
   
    function nftBuy(uint256 _tokenId) public {
        require(tokenIdForSale[_tokenId],"Token must be on sale first");

        address nftowner=nftonwer[_tokenId];
        uint nftPrice = tokenprice[_tokenId];
        require(token.allowance(msg.sender, address(this)) >= nftPrice, "Insufficient allowance.");
        require(token.balanceOf(msg.sender) >= nftPrice, "Insufficient balance.");
        
        token.transferFrom(msg.sender, NFT.ownerOf(_tokenId), nftPrice);
        NFT.transferFrom(nftowner, msg.sender, _tokenId);

    }
}