// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/ZEROToken.sol";

contract DeployScript is Script {
    function run() external {
        // Record logs to capture events
        vm.recordLogs();

        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy ZEROToken contract
        ZEROToken token = new ZEROToken();

        // Stop broadcasting
        vm.stopBroadcast();

        // Log deployment information
        console.log("========== ZEROToken Deployment ==========");
        console.log("Contract: ZEROToken");
        console.log("Address:", address(token));
        console.log("Name:", token.name());
        console.log("Symbol:", token.symbol());
        console.log("Initial Supply:", token.totalSupply());
        console.log("Owner Balance:", token.balanceOf(msg.sender));
        console.log("Network: Ethereum Sepolia");
        console.log("==========================================");
    }
}
