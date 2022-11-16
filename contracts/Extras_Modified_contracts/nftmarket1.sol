// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721.sol";
import "./AVERAEC20.sol";

contract MarketPlace{
    
        ERC721 NFT;
    constructor (address NFTAddress)  {
        
        NFT = ERC721(NFTAddress);  
    }

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

function buy(address _buyer, uint _nftid, uint _price) public{

    buyer =_buyer;
    Price = _price;
    
           require(depositerMap[_nft].address!=buyer.address, "Owner of nft cannot be the Buyer");
//         require(buyer.value>=nftprice, "Insufficent Amount");
//         require(depositerMap.ownerOf[_nft].address == owner, "NFT not yours");
//         require(depositerMap[_nftid].nftid == 0, "NFT already listed");
//         require(Price > 0, "Amount must be higher than 0");
//         // depositerMap[nftid].seller.transfer(msg.sender,_nftid);
//         // depositerMap[_nftid].sold = true;
//         // delete depositerMap[_nftid];
//         // transferFrom(buyer, address(this), _nftid);
//         // emit transferFrom(nftid, msg.sender, address(this), Price, false);
    }



}