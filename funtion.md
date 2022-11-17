 1)6            | Lazy mint    |                           |                                                                
----------------|--------------|---------------------------|----------------------------------------------------------------
                |              | Approve                   | 1)address 2toeknid                                             
                |              | redeem                    | 1)Reedeemer 2)v units 3)r bytes 4)s bytes 5)amount 6) voucher  
                |              | renounceRole              | 1) role 2) account address                                     
                |              | safeTransferFrom          | 1)from address 2) to address 3)tokenid                         
                |              | setApproveforAll          | 1st - operator adddress ,2nd Approve bool                      
                |              | safeTransferFrom          | 1)from address 2) to address 3)tokenid 4)data                  
                |              | balanceOf                 | owner address                                                  
                |              | chainid                   |                                                                
                |              | executeSetlSignatureMatch | 1)vuint2)bytes3)bytes4)tupple voucher                          
                |              | get approved              | token id                                                       
                |              | get chain id              |                                                                
                |              | ISApproveforAll           | 1)owner 2)operator                                             
                |              | revokeRole                | 1) role 2) account address                                     
                |              | name                      |                                                                
                |              | Owner of                  | token id                                                       
                |              | supportsinferface         | 1)bytes                                                        
                |              | symbol                    |                                                                
                |              | tokenURI                  | token id                                                       
 1)7            | BatchSelling |                           |                                                                
                |              | BuyFromFixedSale          | 1)nftAddress2tokenid3)amount4)data                             
                |              | cancelFixedSale           | 1)nftAddress2tokenid3)amount4)data                             
                |              | nftFixedSale              | 1)nftAddress2)erd203)batchids4)amounts5)saleprice6)data        
                |              | updateFixedSalePrice      | 1)nftContractAddres2)tokenid3)updateSalePrice                  
                |              | getFixedSale              | 1)nftContractAddres2)tokenid                                   
                |              | getFixedSaleNFT           |                                                                
                |              | IID_IERC1155              |                                                                
                |              | isERC1155                 | 1)nft address                                                  
                |              | nftSaleSatatus            | 1)address 2uint                                                
                |              | onERC1155BatchReceived    | 1)Operator address 2) from address 3)ids 4_values 5)data bytes 
 1)8            | BatchNfT     |                           |                                                                
                |              | mintBatch                 | 1)to2)ids3)amount4)data                                        
                |              | mintNFT                   | 1)to2)ids3)amount4)data                                        
                |              | safeBatchTransferFrom     | 1)from address2)to address3) tokenid 4)amount 5)data           
                |              | safeTransferFrom          | 1)from address2)to address3) tokenid 4)amount 5)data           
                |              | setApproveforAll          | 1)Operator address 2) Approved                                 
                |              | balanceOf                 | 1)account 2)ids                                                
                |              | balanceOf Batch           | 1)account 2)ids                                                
                |              | isApproveforAll           | 1)account 2)operators                                          
                |              | supportsinferface         | 1)bytes                                                        
                |              | uri                       | 1)uint                                                         
 vvvvvvvvvvvvvv 

