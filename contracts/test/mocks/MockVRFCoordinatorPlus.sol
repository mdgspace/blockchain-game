// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFV2PlusClient} from "lib/chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract MockVRFCoordinatorPlus {
    event RequestReceived(uint256 subId, uint32 callbackGasLimit, uint16 confirmations);

    function requestRandomWords(
        VRFV2PlusClient.RandomWordsRequest calldata req
    ) external pure returns (uint256) {
        return 123; // fixed mock ID for testing
    }
}
