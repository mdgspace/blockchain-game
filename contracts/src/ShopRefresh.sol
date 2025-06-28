// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract ShopRefresh is AutomationCompatibleInterface {
    uint256 public lastTimestamp;
    uint256 public interval;
    uint256 public shopRefreshCounter;

    constructor(uint256 _interval) {
        interval = _interval; // e.g., 3600 for 1 hour
        lastTimestamp = block.timestamp;
        shopRefreshCounter = 0;
    }

    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = (block.timestamp - lastTimestamp) > interval;
        performData = bytes(""); // return empty performData
    }

    // Chainlink Automation calls this when upkeep is needed
    function performUpkeep(bytes calldata) external override {
        if ((block.timestamp - lastTimestamp) > interval) {
            lastTimestamp = block.timestamp;
            shopRefreshCounter += 1; // This is what Unity will check
        }
    }
}
