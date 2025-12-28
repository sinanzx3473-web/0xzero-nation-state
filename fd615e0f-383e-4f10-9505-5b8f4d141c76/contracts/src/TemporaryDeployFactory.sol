// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./Constitution.sol";

/// @title Temporary Deploy Factory for Constitution Contract
/// @notice EIP-6780 compliant factory for parameter-free deployment
/// @dev Uses selfdestruct pattern for multi-chain bytecode compatibility
contract TemporaryDeployFactory {
    /// @notice Emitted when all contracts are deployed
    /// @dev This event enables frontend to query deployed contracts by tx hash
    event ContractsDeployed(
        address indexed deployer,
        string[] contractNames,
        address[] contractAddresses
    );

    /// @notice Deploys Constitution contract and self-destructs
    /// @dev No parameters required - enables same bytecode on all chains
    constructor() {
        // Deploy Constitution contract with msg.sender as owner
        Constitution constitution = new Constitution(msg.sender);

        // Build dynamic arrays for event
        string[] memory contractNames = new string[](1);
        contractNames[0] = "Constitution";

        address[] memory contractAddresses = new address[](1);
        contractAddresses[0] = address(constitution);

        // Emit event with all contract info
        emit ContractsDeployed(msg.sender, contractNames, contractAddresses);

        // Self-destruct and return funds to deployer
        selfdestruct(payable(msg.sender));
    }
}
