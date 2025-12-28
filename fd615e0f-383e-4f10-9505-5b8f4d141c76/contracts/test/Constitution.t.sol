// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../src/Constitution.sol";

contract ConstitutionTest is Test {
    Constitution public constitution;
    address public owner;
    address public oracle;
    address public user1;
    address public user2;

    // Copy event declarations from Constitution contract for testing
    event DefconZeroActivated(address indexed activatedBy, uint256 timestamp);
    event DefconZeroDeactivated(address indexed deactivatedBy, uint256 timestamp);
    event QuantumOracleUpdated(address indexed oldOracle, address indexed newOracle);

    function setUp() public {
        owner = address(this);
        oracle = address(0x1);
        user1 = address(0x2);
        user2 = address(0x3);

        constitution = new Constitution(owner);
    }

    // ============ Happy Path Tests ============

    function testConstructorInitialization() public view {
        assertEq(constitution.owner(), owner, "Owner should be set correctly");
        assertEq(constitution.quantumOracle(), owner, "Oracle should be initialized to owner");
        assertFalse(constitution.isQuantumThreatActive(), "Quantum threat should be inactive initially");
        assertEq(constitution.defconZeroActivatedAt(), 0, "Activation timestamp should be 0");
    }

    function testTriggerDefconZeroByOracle() public {
        vm.expectEmit(true, false, false, true);
        emit DefconZeroActivated(owner, block.timestamp);

        constitution.triggerDefconZeroByOracle();

        assertTrue(constitution.isQuantumThreatActive(), "Quantum threat should be active");
        assertEq(constitution.defconZeroActivatedAt(), block.timestamp, "Activation timestamp should be set");
    }

    function testDeactivateDefconZeroAfterTimelock() public {
        // Activate Defcon Zero
        constitution.triggerDefconZeroByOracle();
        uint256 activationTime = block.timestamp;

        // Fast forward 7 days
        vm.warp(activationTime + 7 days);

        vm.expectEmit(true, false, false, true);
        emit DefconZeroDeactivated(owner, block.timestamp);

        constitution.deactivateDefconZero();

        assertFalse(constitution.isQuantumThreatActive(), "Quantum threat should be inactive");
        assertEq(constitution.defconZeroActivatedAt(), 0, "Activation timestamp should be reset");
    }

    function testSetQuantumOracle() public {
        address newOracle = address(0x999);

        vm.expectEmit(true, true, false, true);
        emit QuantumOracleUpdated(owner, newOracle);

        constitution.setQuantumOracle(newOracle);

        assertEq(constitution.quantumOracle(), newOracle, "Oracle should be updated");
    }

    function testGetQuantumThreatStatus() public {
        assertFalse(constitution.getQuantumThreatStatus(), "Should return false initially");

        constitution.triggerDefconZeroByOracle();
        assertTrue(constitution.getQuantumThreatStatus(), "Should return true after activation");
    }

    function testGetDefconZeroActivationTime() public {
        assertEq(constitution.getDefconZeroActivationTime(), 0, "Should return 0 initially");

        constitution.triggerDefconZeroByOracle();
        assertEq(constitution.getDefconZeroActivationTime(), block.timestamp, "Should return activation time");
    }

    function testGetRemainingTimelock() public {
        assertEq(constitution.getRemainingTimelock(), 0, "Should return 0 when not active");

        constitution.triggerDefconZeroByOracle();
        uint256 activationTime = block.timestamp;

        assertEq(constitution.getRemainingTimelock(), 7 days, "Should return full timelock duration");

        vm.warp(activationTime + 3 days);
        assertEq(constitution.getRemainingTimelock(), 4 days, "Should return remaining time");

        vm.warp(activationTime + 7 days);
        assertEq(constitution.getRemainingTimelock(), 0, "Should return 0 after timelock expires");
    }

    // ============ Access Control Tests ============

    function testTriggerDefconZeroByOracleUnauthorized() public {
        vm.prank(user1);
        vm.expectRevert(Constitution.UnauthorizedOracle.selector);
        constitution.triggerDefconZeroByOracle();
    }

    function testDeactivateDefconZeroOnlyOwner() public {
        constitution.triggerDefconZeroByOracle();
        vm.warp(block.timestamp + 7 days);

        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        constitution.deactivateDefconZero();
    }

    function testSetQuantumOracleOnlyOwner() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        constitution.setQuantumOracle(user2);
    }

    function testOracleCanTriggerAfterUpdate() public {
        constitution.setQuantumOracle(oracle);

        vm.prank(oracle);
        constitution.triggerDefconZeroByOracle();

        assertTrue(constitution.isQuantumThreatActive(), "Oracle should be able to trigger");
    }

    // ============ Edge Case Tests ============

    function testSetQuantumOracleToZeroAddress() public {
        vm.expectRevert(Constitution.InvalidOracleAddress.selector);
        constitution.setQuantumOracle(address(0));
    }

    function testDeactivateDefconZeroWhenNotActive() public {
        vm.expectRevert(Constitution.DefconZeroNotActive.selector);
        constitution.deactivateDefconZero();
    }

    function testMultipleActivations() public {
        constitution.triggerDefconZeroByOracle();
        uint256 firstActivation = constitution.defconZeroActivatedAt();

        vm.warp(block.timestamp + 1 days);
        constitution.triggerDefconZeroByOracle();
        uint256 secondActivation = constitution.defconZeroActivatedAt();

        assertEq(constitution.defconZeroActivatedAt(), secondActivation, "Should update to latest activation");
        assertTrue(secondActivation > firstActivation, "Second activation should be later");
    }

    function testDeactivateAndReactivate() public {
        // First cycle
        constitution.triggerDefconZeroByOracle();
        vm.warp(block.timestamp + 7 days);
        constitution.deactivateDefconZero();

        assertFalse(constitution.isQuantumThreatActive(), "Should be deactivated");

        // Second cycle
        constitution.triggerDefconZeroByOracle();
        assertTrue(constitution.isQuantumThreatActive(), "Should be reactivated");
    }

    // ============ Revert Tests ============

    function testDeactivateDefconZeroBeforeTimelock() public {
        constitution.triggerDefconZeroByOracle();

        vm.warp(block.timestamp + 6 days);
        vm.expectRevert(Constitution.TimelockActive.selector);
        constitution.deactivateDefconZero();
    }

    function testDeactivateDefconZeroTimelockBoundary() public {
        // Activate Defcon Zero via Oracle
        constitution.triggerDefconZeroByOracle();
        uint256 activationTime = block.timestamp;
        assertTrue(constitution.isQuantumThreatActive(), "Defcon Zero should be active");

        // Try deactivation at 6 days 23 hours 59 minutes (should fail)
        vm.warp(activationTime + 6 days + 23 hours + 59 minutes);
        vm.expectRevert(Constitution.TimelockActive.selector);
        constitution.deactivateDefconZero();

        // Verify still active
        assertTrue(constitution.isQuantumThreatActive(), "Defcon Zero should still be active");

        // Try deactivation at exactly 7 days + 1 second (should succeed)
        vm.warp(activationTime + 7 days + 1 seconds);
        constitution.deactivateDefconZero();

        // Assert isQuantumThreatActive() is false after successful deactivation
        assertFalse(constitution.isQuantumThreatActive(), "Defcon Zero should be deactivated");
        assertEq(constitution.defconZeroActivatedAt(), 0, "Activation timestamp should be reset");
    }

    // ============ Event Emission Tests ============

    function testDefconZeroActivatedEvent() public {
        vm.expectEmit(true, false, false, true);
        emit DefconZeroActivated(owner, block.timestamp);

        constitution.triggerDefconZeroByOracle();
    }

    function testDefconZeroDeactivatedEvent() public {
        constitution.triggerDefconZeroByOracle();
        vm.warp(block.timestamp + 7 days);

        vm.expectEmit(true, false, false, true);
        emit DefconZeroDeactivated(owner, block.timestamp);

        constitution.deactivateDefconZero();
    }

    function testQuantumOracleUpdatedEvent() public {
        address newOracle = address(0x999);

        vm.expectEmit(true, true, false, true);
        emit QuantumOracleUpdated(owner, newOracle);

        constitution.setQuantumOracle(newOracle);
    }

    // ============ State Transition Tests ============

    function testStateTransitionActivateDeactivate() public {
        // Initial state
        assertFalse(constitution.isQuantumThreatActive());
        assertEq(constitution.defconZeroActivatedAt(), 0);

        // Activate
        constitution.triggerDefconZeroByOracle();
        assertTrue(constitution.isQuantumThreatActive());
        assertGt(constitution.defconZeroActivatedAt(), 0);

        // Deactivate
        vm.warp(block.timestamp + 7 days);
        constitution.deactivateDefconZero();
        assertFalse(constitution.isQuantumThreatActive());
        assertEq(constitution.defconZeroActivatedAt(), 0);
    }

    function testStateConsistencyAcrossMultipleOperations() public {
        // Activate
        constitution.triggerDefconZeroByOracle();
        uint256 activation1 = constitution.defconZeroActivatedAt();

        // Deactivate
        vm.warp(block.timestamp + 7 days);
        constitution.deactivateDefconZero();

        // Reactivate
        constitution.triggerDefconZeroByOracle();
        uint256 activation2 = constitution.defconZeroActivatedAt();

        assertTrue(activation2 > activation1, "Second activation should have later timestamp");
    }

    // ============ Fuzz Testing ============

    function testFuzzTriggerDefconZeroByOracleMultipleTimes(uint8 iterations) public {
        iterations = uint8(bound(iterations, 1, 100));

        for (uint8 i = 0; i < iterations; i++) {
            constitution.triggerDefconZeroByOracle();
            assertTrue(constitution.isQuantumThreatActive(), "Should remain active");
            vm.warp(block.timestamp + 1);
        }
    }

    function testFuzzDeactivateDefconZeroAfterVariousTimelocks(uint256 additionalTime) public {
        additionalTime = bound(additionalTime, 0, 365 days);

        constitution.triggerDefconZeroByOracle();
        uint256 activationTime = block.timestamp;

        vm.warp(activationTime + 7 days + additionalTime);
        constitution.deactivateDefconZero();

        assertFalse(constitution.isQuantumThreatActive(), "Should be deactivated");
    }

    function testFuzzSetQuantumOracleToValidAddresses(address newOracle) public {
        vm.assume(newOracle != address(0));

        constitution.setQuantumOracle(newOracle);
        assertEq(constitution.quantumOracle(), newOracle, "Oracle should be updated");
    }

    function testFuzzTimelockBoundary(uint256 timeBeforeExpiry) public {
        timeBeforeExpiry = bound(timeBeforeExpiry, 1, 7 days - 1);

        constitution.triggerDefconZeroByOracle();
        uint256 activationTime = block.timestamp;

        // Try to deactivate before timelock expires
        vm.warp(activationTime + 7 days - timeBeforeExpiry);
        vm.expectRevert(Constitution.TimelockActive.selector);
        constitution.deactivateDefconZero();

        // Should still be active
        assertTrue(constitution.isQuantumThreatActive());
    }

    // ============ Gas Optimization Tests ============

    function testGasTriggerDefconZero() public {
        uint256 gasBefore = gasleft();
        constitution.triggerDefconZeroByOracle();
        uint256 gasUsed = gasBefore - gasleft();

        assertLt(gasUsed, 100000, "Gas usage should be reasonable");
    }

    function testGasDeactivateDefconZero() public {
        constitution.triggerDefconZeroByOracle();
        vm.warp(block.timestamp + 7 days);

        uint256 gasBefore = gasleft();
        constitution.deactivateDefconZero();
        uint256 gasUsed = gasBefore - gasleft();

        assertLt(gasUsed, 100000, "Gas usage should be reasonable");
    }
}
