// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SimpleRandom.sol";
import "./mocks/MockVRFCoordinatorPlus.sol";

contract SimpleRandomTest is Test {
    SimpleRandom
 public random;
    uint256 public subId = 1;
    address public mockCoordinator;
    bytes32 public keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;

    function setUp() public {
        mockCoordinator = address(new MockVRFCoordinatorPlus());
        random = new SimpleRandom
    (mockCoordinator, subId, keyHash);
    }

    function testRequestStoresRange() public {
        uint32 min = 10;
        uint32 max = 20;

        uint256 requestId = random.requestRandom(min, max);
        (uint32 storedMin, uint32 storedMax) = random.ranges(requestId);
        assertEq(storedMin, min);
        assertEq(storedMax, max);
    }

    function testFulfillEmitsRandomGenerated() public {
        uint32 min = 5;
        uint32 max = 15;
        uint256 requestId = random.requestRandom(min, max);

        // Prepare fake randomness
        uint256[] memory words = new uint256[](1);
        words[0] = 7;

        vm.expectEmit(true, true, true, true);
        emit RandomGenerated(12); // 7 % 11 + 5 = 12

        random.testFulfillRandom(requestId, words);
    }

    event RandomGenerated(uint32 result);
}
