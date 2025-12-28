// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../src/ZEROToken.sol";

contract ZEROTokenTest is Test {
    ZEROToken public token;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x1);
        token = new ZEROToken();
    }

    function testInitialMint() public {
        // Check that owner received 1,000,000 tokens
        assertEq(token.balanceOf(owner), 1000000 * 10**18);
    }

    function testClaimTokens() public {
        // User claims tokens
        vm.prank(user);
        token.claimTokens();

        // Check user received 1000 tokens
        assertEq(token.balanceOf(user), 1000 * 10**18);
    }

    function testClaimTokensEmitsEvent() public {
        vm.prank(user);
        vm.expectEmit(true, false, false, true);
        emit ZEROToken.TokensClaimed(user, 1000 * 10**18);
        token.claimTokens();
    }

    function testCooldownEnforced() public {
        // First claim
        vm.prank(user);
        token.claimTokens();

        // Try to claim again immediately - should revert
        vm.prank(user);
        vm.expectRevert("Cooldown active");
        token.claimTokens();
    }

    function testCooldownExpires() public {
        // First claim
        vm.prank(user);
        token.claimTokens();

        // Fast forward 24 hours
        vm.warp(block.timestamp + 1 days);

        // Second claim should succeed
        vm.prank(user);
        token.claimTokens();

        // Check user has 2000 tokens total
        assertEq(token.balanceOf(user), 2000 * 10**18);
    }
}
