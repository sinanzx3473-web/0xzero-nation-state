// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title 0xZERO Token
/// @notice ERC20 token with claim functionality and 24-hour cooldown
contract ZEROToken is ERC20 {
    /// @notice Emitted when tokens are claimed
    event TokensClaimed(address indexed claimer, uint256 amount);

    /// @notice Owner of the contract
    address public owner;

    /// @notice Mapping to track last claim time for each address
    mapping(address => uint256) public lastClaimTime;

    /// @notice Amount of tokens to claim per call (1000 * 10^18)
    uint256 public constant CLAIM_AMOUNT = 1000 * 10**18;

    /// @notice Cooldown period between claims (24 hours)
    uint256 public constant COOLDOWN_PERIOD = 1 days;

    /// @notice Constructor: Initialize token and mint initial supply to deployer
    constructor() ERC20("0xZERO Token", "ZERO") {
        owner = msg.sender;
        // Mint 1,000,000 tokens to the deployer
        _mint(msg.sender, 1000000 * 10**18);
    }

    /// @notice Claim tokens with 24-hour cooldown
    /// @dev Sends 1000 ZERO tokens to the caller if cooldown has passed
    function claimTokens() external {
        // Check cooldown requirement
        require(
            block.timestamp >= lastClaimTime[msg.sender] + COOLDOWN_PERIOD,
            "Cooldown active"
        );

        // Update last claim time
        lastClaimTime[msg.sender] = block.timestamp;

        // Transfer tokens from owner to caller
        _transfer(owner, msg.sender, CLAIM_AMOUNT);

        // Emit event
        emit TokensClaimed(msg.sender, CLAIM_AMOUNT);
    }
}
