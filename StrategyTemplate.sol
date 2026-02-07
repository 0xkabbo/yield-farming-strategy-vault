// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title StrategyTemplate
 * @dev Placeholder for external protocol integration logic.
 */
contract StrategyTemplate is Ownable {
    address public vault;

    constructor(address _vault) Ownable(msg.sender) {
        vault = _vault;
    }

    function invest() external onlyOwner {
        // Add logic to move funds from Vault to Protocol (e.g., Aave)
    }

    function harvest() external onlyOwner {
        // Add logic to collect rewards and send back to Vault
    }
}
