# AREVEA-NFT Marketplace Documentation
## Table of contents
### Brief summary decentralized marketplace 
### Arevea Token and NFT Contract .sol files details
### Smart Contract Functionality in brief
### Disclaimer 


# Arevea-NFT-Market Place 
The Arevea marketplace mainly focuses upon the utilization of the Etherium network namely ERC721 for single NFT and ERC1155 for multiple NFT. This is also compatibleble with EVM aka ethereum virtual machine and innumerable other smart chain networks such as 1. Rinkeby Network 2. Ropsten amonst others. The main purpose of this project is to provide a Blockchain based online market place for the sale and purchase of NFT's both Single and Multiple using AREVEA tokens(ERC20,Criptocurrency). Arevea tokens may also be utilized for other transactions Thus we may conclude that there is a large scope of growth present permitting us to move forward with this initiation.  

### Brief summary decentralized marketplace 
NFT or Non-Fungible Tokens are cryptographic assets that are created on blockchain technology, and have unique identification codes and meta-data, which makes them distinguishable, distinct, and completely unique. 
NFTs can be traded with other NFTs or sold/bought via the NFT marketplace, which is a decentralized platform.
This marketplace is like an eCommerce platform, say Amazon or eBay where different products are listed by sellers, and buyers can buy them.

### Arevea Token and NFT Contract .sol files details
Structure- 
All contracts and tests are in the NFT-Contracts folder. There are multiple implementations and you can select in between 

NFT.sol: This is the base ERC-721 token implementation (with support for ERC-165).

MultipleNFT.sol :This is the base ERC1155 token implementation for multiple copies and multiple at same time with reduced gas fees. 

finalMarket_single.sol is the marketplace for Single NFT for buy sell and auction in marketplace 

final_market_Multi_nft.sol for Multiple nft buy sell and auction in multinft marketplace

lazymint.sol allows the user to create NFT without gas fee, transaction to pass the burden from creator to purchaser (gas fees)

### Smart Contract Functionality in brief
From the Above Smart contract one is for Single NFT and another is for Multiple NFT ,using  single NFT we can create Single in Blockchain and that can be buy  sell and trade in NFT market place, for creating single nft in one id is excess amount of gas use so that using one id we can have multiple nfts at one plase , multiple has 2 features one is creating multiple copies and another is creating different items under one id as multiple is called as multiple batch of different nft  at one place. 

Both Single and Multiple has Separate Marketplace to buy sell and trade nft in marketplace. 

Lazy minting is different where the NFT is once minted all creatrion and transaction cost of Blockchain is burn by the buyer itself. 

| 1) Srial no | contract        | function                               | parameter                                               |
| ----------- | --------------- | -------------------------------------- | ------------------------------------------------------- |
| 1           | Single\_nft 721 | approve                                | 1st - Contract adress , 2nd tokenid                     |
|             |                 | Burn                                   | tokenid                                                 |
|             |                 | createNFT                              | 1st -TokenURI , 2nd Fee                                 |
|             |                 | safeTransferFrom                       | 1st From -address 2nd -To Address 3rd -tokenid          |
|             |                 | safeTransferFrom                       | 1st From -address 2nd -To Address 3rd -tokenid 4th data |
|             |                 | setApproveforAll                       | 1st - operator adddress ,2nd Approve bool               |
|             |                 | setBaseURI                             | 1st Base uri                                            |
|             |                 | TransferFrom                           | 1st From -address 2nd -To Address 3rd -tokenid          |
|             |                 | TransferOwnsership                     | New owner address                                       |
|             |                 |                                        |                                                         |
|             |                 | Balance of address of owner and others | Owner addres                                            |
|             |                 | baseURI                                |                                                         |
|             |                 | GetApproved                            | tokenid                                                 |
|             |                 | GetCreator                             | tokenid                                                 |
|             |                 | ISApproveforAll                        | 1st - operator adddress ,2nd Approve bool               |
|             |                 | name                                   |                                                         |
|             |                 | owner                                  |                                                         |
|             |                 | ownerof                                | tokenid                                                 |
|             |                 | royaltyfee                             | tokenid                                                 |
|             |                 | supportsinterface                      | byres4                                                  |
|             |                 | symbol                                 |                                                         |
|             |                 | tokenbyIndex                           | index                                                   |
|             |                 | tokenCounter                           |                                                         |
|             |                 | tokenbyownerbyindex                    | 1)owner2) index                                         |
|             |                 | tokenURI                               | tokenid                                                 |
|             |                 | totalSupply                            |                                                         |
| 1) Srial no | Multi\_nft\_1155 |                       |                                                      |
| ----------- | ---------------- | --------------------- | ---------------------------------------------------- |
|             |                  | burn                  | 1)tokenid 2) supply in unit                          |
|             |                  | burnBatch             | 1)tokenid 2) amount                                  |
|             |                  | createMultiple        | 1)uri2)Supplier3)Fee                                 |
|             |                  | mintBatch             | 1)to2)tokenid3)amounts4)data                         |
|             |                  | safeBatchTransferFrom | 1)from address2)to address3) tokenid 4)amount 5)data |
|             |                  | safeBatchTransferFrom | 1)from address2)to address3) tokenid 4)amount 5)data |
|             |                  | setApproveforAll      | 1st - operator adddress ,2nd Approve bool            |
|             |                  | setBaseURI            | baseURI                                              |
|             |                  | TransferOwnsership    | New owner address                                    |
|             |                  | balanceOf             | 1)account 2) tokenid                                 |
|             |                  | balanceOfBatch        | 1)accunts 2)ids                                      |
|             |                  | getCreator            | tokenid                                              |
|             |                  | ISApproveforAll       | 1)accunts 2)operators                                |
|             |                  | name                  |                                                      |
|             |                  | owner                 |                                                      |
|             |                  | Royaltyfee            | tokenid                                              |
|             |                  | supportsInterface     | bytes                                                |
|             |                  | symbol                |                                                      |
|             |                  | tokenURI              | tokenid                                              |
|             |                  | tokenURIPrifix call   |                                                      |
|             |                  | totalSupply           |                                                      |




Sources and Address:<br>

AreveaToken, SingleNFT &amp; Multiple NFT with Market and Bid functions 
link to Arevea ERC20 REadme - https://github.com/Tapas15/ERC20/blob/main/README.md

json Market file- link https://github.com/Tapas15/Arevea-NFT-Market/blob/main/MULTI-NFT/contracts/artifacts/MarketPlace.json

market place link - https://github.com/Tapas15/Arevea-NFT-Market/blob/main/MULTI-NFT/contracts/MarketPlace.sol

market place contract link- https://rinkeby.etherscan.io/address/0x92dcd49991cd55ab039abd077e0f97573378d89d

market contract address- 0x92dCD49991CD55ab039aBd077e0F97573378D89D


### Disclaimer 
