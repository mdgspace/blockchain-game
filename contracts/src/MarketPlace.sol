// pragma solidity >=0.5.0 <0.9.0;

// import "./ItemManager.sol";
// contract MarketPlace is ItemManager {
//     struct UniqueItem {//Not exactly unique but can be used to represent items that are not farmable like weapons, armor, etc. 
//     //which have random stats so thier value is very user dependent
//         uint256 itemId;
//         ItemManager item;
//         address owner;
//         uint256 price; // Price in wei
//         bool isListed;
//     }
//     //can add things like berries or items which can be farmed and  apply defi concepts and supply and demand concepts on it\
    
//     //A struct for the farmable items in which we can display the last selling price and many other things required in the market.
//     mapping(uint256 => UniqueItem) public uniqueItems; // Mapping of itemId to UniqueItem
//     struct CommonItem {
//         uint256 itemId;
//         string GroupName; // Group name for common items, e.g., "Berries" 
//         ItemManager item;
//         address owner;
//         uint256 price; // Price in wei
//         bool isListed;
//         uint256 quantity; // Number of items available for sale
//         uint256 sold; // Number of items sold
//         uint256 lastSoldPrice; // Last sold price for the item
//         uint256 lastSoldTimestamp; // Timestamp of the last sale
//     }
// }