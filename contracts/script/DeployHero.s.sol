// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/Hero.sol";

contract DeployHero is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Hero hero = new Hero();
        console.log("Hero contract deployed at:", address(hero));

        vm.stopBroadcast();
    }
}
