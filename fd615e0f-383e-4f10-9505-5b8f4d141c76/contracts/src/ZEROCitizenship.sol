// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title 0xZEROCitizenship
/// @notice NFT contract representing citizenship in the 0xZERO Protocol - a sovereign jurisdiction for the machine economy
/// @dev Implements ERC721 standard with citizen metadata and reputation tracking
contract ZEROCitizenship is ERC721, Ownable {
    /// @notice Struct to store citizen metadata
    struct Citizen {
        uint256 citizenId;
        uint256 mintTimestamp;
        uint256 reputation;
    }

    /// @notice Counter for sequential citizen IDs
    uint256 private citizenIdCounter = 1;

    /// @notice Mapping from address to citizen metadata
    mapping(address => Citizen) public citizens;

    /// @notice Mapping from citizen ID to address
    mapping(uint256 => address) public citizenIdToAddress;

    /// @notice Event emitted when citizenship is granted
    event CitizenshipGranted(
        address indexed citizen,
        uint256 citizenId,
        uint256 timestamp
    );

    /// @notice Event emitted when reputation is updated
    event ReputationUpdated(
        address indexed citizen,
        uint256 citizenId,
        uint256 newReputation
    );

    /// @notice Constructor initializes the ERC721 token
    constructor() ERC721("0xZEROCitizenship", "ZERO") Ownable(msg.sender) {}

    /// @notice Mint a citizenship NFT for the caller
    /// @dev Each address can only mint once, sequential citizen IDs are assigned
    function mintCitizenship() external {
        require(
            citizens[msg.sender].citizenId == 0,
            "Address already has citizenship"
        );

        uint256 newCitizenId = citizenIdCounter;
        citizenIdCounter++;

        // Create citizen metadata
        citizens[msg.sender] = Citizen({
            citizenId: newCitizenId,
            mintTimestamp: block.timestamp,
            reputation: 0
        });

        // Map citizen ID to address
        citizenIdToAddress[newCitizenId] = msg.sender;

        // Mint the NFT
        _safeMint(msg.sender, newCitizenId);

        // Emit citizenship granted event
        emit CitizenshipGranted(msg.sender, newCitizenId, block.timestamp);
    }

    /// @notice Get the citizen ID for an address
    /// @param citizen The address to query
    /// @return The citizen ID (0 if address has no citizenship)
    function getCitizenId(address citizen) external view returns (uint256) {
        return citizens[citizen].citizenId;
    }

    /// @notice Get the reputation score for a citizen
    /// @param citizen The address to query
    /// @return The reputation score
    function getCitizenReputation(address citizen)
        external
        view
        returns (uint256)
    {
        return citizens[citizen].reputation;
    }

    /// @notice Get full citizen metadata
    /// @param citizen The address to query
    /// @return The citizen struct containing all metadata
    function getCitizenMetadata(address citizen)
        external
        view
        returns (Citizen memory)
    {
        return citizens[citizen];
    }

    /// @notice Update reputation score for a citizen (owner only)
    /// @param citizen The address of the citizen
    /// @param newReputation The new reputation score
    function updateReputation(address citizen, uint256 newReputation)
        external
        onlyOwner
    {
        require(
            citizens[citizen].citizenId != 0,
            "Address does not have citizenship"
        );

        uint256 citizenId = citizens[citizen].citizenId;
        citizens[citizen].reputation = newReputation;

        emit ReputationUpdated(citizen, citizenId, newReputation);
    }

    /// @notice Get the total number of citizens minted
    /// @return The total citizen count
    function getTotalCitizens() external view returns (uint256) {
        return citizenIdCounter - 1;
    }
}
