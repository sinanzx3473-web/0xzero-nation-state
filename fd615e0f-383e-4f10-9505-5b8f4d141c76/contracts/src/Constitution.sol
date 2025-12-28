// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title 0xZERO Protocol Constitution
/// @notice This contract manages the 0xZERO Protocol's quantum threat defense system
/// @dev Implements a governance-controlled emergency response mechanism with oracle integration
/// @custom:security-contact security@0xzero.protocol
contract Constitution is Ownable {
    /// @notice Duration of the governance timelock for deactivating Defcon Zero
    /// @dev Set to 7 days (604800 seconds) to allow community review
    uint256 public constant DEACTIVATION_TIMELOCK = 7 days;

    /// @notice Address of the authorized Quantum Oracle
    /// @dev Only this address can trigger Defcon Zero via oracle
    address public quantumOracle;

    /// @notice Indicates whether a quantum threat is currently active
    /// @dev True when Defcon Zero is activated, false otherwise
    bool public isQuantumThreatActive;

    /// @notice Timestamp when Defcon Zero was activated
    /// @dev Used to enforce the 7-day timelock for deactivation
    uint256 public defconZeroActivatedAt;

    /// @notice Emitted when Defcon Zero is activated by the Quantum Oracle
    /// @param activatedBy Address that triggered the activation
    /// @param timestamp Block timestamp of activation
    event DefconZeroActivated(address indexed activatedBy, uint256 timestamp);

    /// @notice Emitted when Defcon Zero is deactivated after timelock
    /// @param deactivatedBy Address that triggered the deactivation
    /// @param timestamp Block timestamp of deactivation
    event DefconZeroDeactivated(address indexed deactivatedBy, uint256 timestamp);

    /// @notice Emitted when the Quantum Oracle address is updated
    /// @param oldOracle Previous oracle address
    /// @param newOracle New oracle address
    event QuantumOracleUpdated(address indexed oldOracle, address indexed newOracle);

    /// @notice Thrown when a non-oracle address attempts to trigger Defcon Zero
    error UnauthorizedOracle();

    /// @notice Thrown when attempting to deactivate Defcon Zero before timelock expires
    error TimelockActive();

    /// @notice Thrown when attempting to deactivate Defcon Zero when it's not active
    error DefconZeroNotActive();

    /// @notice Thrown when setting the oracle to the zero address
    error InvalidOracleAddress();

    /// @notice Initializes the Constitution contract
    /// @dev Sets the deployer as the initial owner and oracle
    /// @param initialOwner Address that will own the contract
    constructor(address initialOwner) Ownable(initialOwner) {
        if (initialOwner == address(0)) revert InvalidOracleAddress();
        quantumOracle = initialOwner;
        emit QuantumOracleUpdated(address(0), initialOwner);
    }

    /// @notice Triggers Defcon Zero emergency state via Quantum Oracle
    /// @dev Can only be called by the authorized Quantum Oracle address
    /// @dev Sets isQuantumThreatActive to true and records activation timestamp
    function triggerDefconZeroByOracle() external {
        if (msg.sender != quantumOracle) {
            revert UnauthorizedOracle();
        }

        isQuantumThreatActive = true;
        defconZeroActivatedAt = block.timestamp;

        emit DefconZeroActivated(msg.sender, block.timestamp);
    }

    /// @notice Deactivates Defcon Zero after the 7-day governance timelock
    /// @dev Can only be called by the contract owner
    /// @dev Requires Defcon Zero to be active and timelock period to have elapsed
    function deactivateDefconZero() external onlyOwner {
        if (!isQuantumThreatActive) {
            revert DefconZeroNotActive();
        }

        if (block.timestamp < defconZeroActivatedAt + DEACTIVATION_TIMELOCK) {
            revert TimelockActive();
        }

        isQuantumThreatActive = false;
        defconZeroActivatedAt = 0;

        emit DefconZeroDeactivated(msg.sender, block.timestamp);
    }

    /// @notice Updates the authorized Quantum Oracle address
    /// @dev Can only be called by the contract owner
    /// @param newOracle Address of the new Quantum Oracle
    function setQuantumOracle(address newOracle) external onlyOwner {
        if (newOracle == address(0)) {
            revert InvalidOracleAddress();
        }

        address oldOracle = quantumOracle;
        quantumOracle = newOracle;

        emit QuantumOracleUpdated(oldOracle, newOracle);
    }

    /// @notice Returns the current state of the quantum threat
    /// @dev View function to check if Defcon Zero is active
    /// @return bool True if quantum threat is active, false otherwise
    function getQuantumThreatStatus() public view returns (bool) {
        return isQuantumThreatActive;
    }

    /// @notice Returns the timestamp when Defcon Zero was activated
    /// @dev Returns 0 if Defcon Zero has never been activated or was deactivated
    /// @return uint256 Timestamp of activation
    function getDefconZeroActivationTime() public view returns (uint256) {
        return defconZeroActivatedAt;
    }

    /// @notice Calculates the remaining timelock duration
    /// @dev Returns 0 if timelock has expired or Defcon Zero is not active
    /// @return uint256 Remaining seconds until deactivation is allowed
    function getRemainingTimelock() public view returns (uint256) {
        if (!isQuantumThreatActive) {
            return 0;
        }

        uint256 unlockTime = defconZeroActivatedAt + DEACTIVATION_TIMELOCK;
        if (block.timestamp >= unlockTime) {
            return 0;
        }

        return unlockTime - block.timestamp;
    }
}
