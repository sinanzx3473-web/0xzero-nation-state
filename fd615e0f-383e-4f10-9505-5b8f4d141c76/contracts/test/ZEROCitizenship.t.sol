// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../src/ZEROCitizenship.sol";

contract ZEROCitizenshipTest is Test {
    ZEROCitizenship public citizenship;
    address public user1 = address(0x1);
    address public user2 = address(0x2);
    address public user3 = address(0x3);

    function setUp() public {
        citizenship = new ZEROCitizenship();
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
        vm.deal(user3, 1 ether);
    }

    function testMintCitizenship() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        uint256 citizenId = citizenship.getCitizenId(user1);
        assertEq(citizenId, 1, "First citizen should have ID 1");
        assertEq(citizenship.balanceOf(user1), 1, "User should own 1 NFT");
    }

    function testSequentialCitizenIds() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        vm.prank(user2);
        citizenship.mintCitizenship();

        vm.prank(user3);
        citizenship.mintCitizenship();

        assertEq(citizenship.getCitizenId(user1), 1, "User1 should be citizen 1");
        assertEq(citizenship.getCitizenId(user2), 2, "User2 should be citizen 2");
        assertEq(citizenship.getCitizenId(user3), 3, "User3 should be citizen 3");
    }

    function testInitialReputationIsZero() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        uint256 reputation = citizenship.getCitizenReputation(user1);
        assertEq(reputation, 0, "Initial reputation should be 0");
    }

    function testUpdateReputation() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        citizenship.updateReputation(user1, 100);

        uint256 reputation = citizenship.getCitizenReputation(user1);
        assertEq(reputation, 100, "Reputation should be updated to 100");
    }

    function testOnlyOwnerCanUpdateReputation() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        vm.prank(user2);
        vm.expectRevert();
        citizenship.updateReputation(user1, 50);
    }

    function testCannotMintTwice() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        vm.prank(user1);
        vm.expectRevert("Address already has citizenship");
        citizenship.mintCitizenship();
    }

    function testCitizenshipGrantedEvent() public {
        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit ZEROCitizenship.CitizenshipGranted(user1, 1, block.timestamp);
        citizenship.mintCitizenship();
    }

    function testGetTotalCitizens() public {
        vm.prank(user1);
        citizenship.mintCitizenship();

        vm.prank(user2);
        citizenship.mintCitizenship();

        assertEq(citizenship.getTotalCitizens(), 2, "Should have 2 citizens");
    }
}
