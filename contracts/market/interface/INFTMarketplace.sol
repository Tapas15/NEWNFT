// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
        @notice abstract contract INFTMarketplace Event tracker.
       
*/
interface INFTMarketplace {
    /**
        @notice abstract contract INFTMarketplace Event tracker.
        auctionStart auctionEnd of the auction 
        minPrice of nft 
        nftHighestBid of nft 
        royalty fee 
        nftHighestBidder  address of highest bidder 
        nftSeller addess of the seller the holder of nft
        address of erc20 token 
        nft royalty receiver's addres  
    @tupple returns the tupple of auction 
    */
    struct Auction {
        uint256 auctionStart;
        uint256 auctionEnd;
        uint256 minPrice;
        uint256 nftHighestBid;
        uint256 royalty;
        address nftHighestBidder;
        address nftSeller;
        address erc20;
        address royaltyReciever;
    }
    /**
        @notice struct FixedSale  .
        @param  FixedSale- 
                nftSeller is the creator or the owner who is going to sell nft 
                nftBuyer- is the purchase of nft 
                erc20 - erc20 token addresss 
                royaltyReciever- is the royalty in case owner or the nft holder going to receive some amount 
                salePrice- minimum sale price of the nft 
                royalty - the royalty amount of the nft 
        @FixedSale - returns the tupple for FixedSale
     */
    struct FixedSale {
        address nftSeller;
        address nftBuyer;
        address erc20;
        address royaltyReciever;
        uint256 salePrice;
        uint256 royalty;
    }
     /**
        @notice struct SaleInfo  .
        @param  SaleInfo- input saleinfo nft address and token id 
        @Saleinfo - returns the tupple for sales info
     */
    struct SaleInfo {
        address _nftContractAddress;
        uint256 _tokenID;
    }
   // events are nothing 
    event NftFixedSale(
        address nftContractAddress,
        address nftSeller,
        address erc20,
        uint256 tokenId,
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
        uint256 tokenId,
        uint256 nftBuyPrice
    );

    event NftAuctionSale(
        address nftContractAddress,
        address nftSeller,
        address erc20,
        uint256 tokenId,
        uint256 auctionStart,
        uint256 auctionEnd,
        uint256 minPrice
    );

    event NftBidPrice(
        address nftContractAddress,
        uint256 tokenId,
        uint256 bidPrice,
        address nftBidder
    );

    event NftAuctionBidPriceUpdate(
        address nftContractAddress,
        uint256 tokenId,
        uint256 finalBidPrice,
        address nftBidder
    );

    event CancelNftAuctionSale(
        address nftContractAddress,
        uint256 tokenId,
        address nftSeller
    );

    event NftBuyNowPriceUpdate(
        address nftContractAddress,
        uint256 tokenId,
        uint256 updateBuyNowPrice,
        address nftOwner
    );

    event NftAuctionSettle(
        address nftContractAddress,
        uint256 tokenId,
        address nftHighestBidder,
        uint256 nftHighestBid,
        address nftSeller
    );

    event withdrawNftBid(
        address nftContractAddress,
        uint256 tokenId,
        address bidClaimer
    );
    event AreveaTokenSell(address seller, address owner, uint256 _amount);
    event AreveaTokenBuy(address _buyer, address owner, uint256 _amount);
    event UpdateOwner(address oldAddress, address newAddress);
}
