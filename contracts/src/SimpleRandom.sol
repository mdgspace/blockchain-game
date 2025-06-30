// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "lib/chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "lib/chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract SimpleRandom is VRFConsumerBaseV2Plus {
    VRFV2PlusClient.ExtraArgsV1 public extraArgs;

    // Configurable parameters
    uint256 public s_subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;
    uint32 public numWords = 1;

    struct Range {
        uint32 min;
        uint32 max;
    }

    mapping(uint256 => Range) public ranges;

    event RandomGenerated(uint32 result);

    constructor(
        address coordinator,
        uint256 subscriptionId,
        bytes32 _keyHash
    ) VRFConsumerBaseV2Plus(coordinator) {
        s_subscriptionId = subscriptionId;
        keyHash = _keyHash;
        extraArgs = VRFV2PlusClient.ExtraArgsV1({nativePayment: false});
    }

    function requestRandom(uint32 min, uint32 max) external returns (uint256 requestId) {
        require(min <= max, "Invalid range");

        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(extraArgs)
            })
        );

        ranges[requestId] = Range(min, max);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        Range memory r = ranges[requestId];
        uint32 result = uint32(randomWords[0] % (r.max - r.min + 1)) + r.min;
        emit RandomGenerated(result);
    }
    /// Test-only helper to call fulfillRandomWords manually
    function testFulfillRandom(uint256 requestId, uint256[] calldata words) external {
        fulfillRandomWords(requestId, words);
    }
}