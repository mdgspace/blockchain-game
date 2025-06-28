pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ShopRefresh.sol";

contract DeployShopRefresh is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy with 4 hour interval (7200 seconds)
        ShopRefresh shopRefresh = new ShopRefresh(14400);
        
        console.log("ShopRefresh deployed to:", address(shopRefresh));
        
        vm.stopBroadcast();
    }
}