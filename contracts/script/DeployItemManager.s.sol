// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ItemManager.sol";

contract DeployItemManager is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Replace with your actual metadata base URI (e.g., IPFS or HTTPS endpoint)
        string memory baseURI = "https://game.example/api/item/";
        ItemManager itemManager = new ItemManager(baseURI);

        console.log("ItemManager deployed at:", address(itemManager));

        vm.stopBroadcast();
    }
}
