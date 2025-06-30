// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/SimpleRandom.sol";

contract DeploySimpleRandom is Script {
    function run() external {
        // 1. Load env vars
        address coordinator = vm.envAddress("VRF_COORDINATOR");
        bytes32 keyHash = vm.envBytes32("VRF_KEY_HASH");
        uint256 subscriptionId = vm.envUint("VRF_SUBSCRIPTION_ID");

        // 2. Start broadcasting tx
        vm.startBroadcast();

        // 3. Deploy contract
        new SimpleRandom(coordinator, subscriptionId, keyHash);

        vm.stopBroadcast();
    }
}
