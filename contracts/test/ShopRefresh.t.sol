// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "../src/ShopRefresh.sol";

// contract ShopRefreshTest is Test {
//     ShopRefresh shop;
//     uint256 interval = 3600; // 1 hour

//     function setUp() public {
//         shop = new ShopRefresh(interval);
//     }

//     function testInitialValues() public {
//         assertEq(shop.interval(), interval);
//         assertEq(shop.shopRefreshCounter(), 0);
//         assertEq(shop.lastTimestamp(), block.timestamp);
//     }

//     function testCheckUpkeepReturnsFalseBeforeInterval() public {
//         (bool upkeepNeeded, ) = shop.checkUpkeep("");
//         assertFalse(upkeepNeeded);
//     }

//     function testCheckUpkeepReturnsTrueAfterInterval() public {
//         // Advance time by interval + 1 second
//         vm.warp(block.timestamp + interval + 1);
//         (bool upkeepNeeded, ) = shop.checkUpkeep("");
//         assertTrue(upkeepNeeded);
//     }

//     function testPerformUpkeepIncrementsCounter() public {
//         vm.warp(block.timestamp + interval + 1);
//         shop.performUpkeep("");
//         assertEq(shop.shopRefreshCounter(), 1);
//         assertEq(shop.lastTimestamp(), block.timestamp);
//     }

//     function testPerformUpkeepDoesNothingIfNotNeeded() public {
//         uint256 before = shop.shopRefreshCounter();
//         shop.performUpkeep(""); // Should do nothing because interval not passed
//         assertEq(shop.shopRefreshCounter(), before);
//     }
// }
