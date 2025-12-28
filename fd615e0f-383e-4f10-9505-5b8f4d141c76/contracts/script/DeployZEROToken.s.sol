// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/ZEROToken.sol";

contract DeployZEROTokenScript is Script {
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
        console.log("ZEROToken deployed at:", address(token));
        console.log("Token Name:", token.name());
        console.log("Token Symbol:", token.symbol());
        console.log("Initial Supply:", token.totalSupply());
        console.log("Owner Balance:", token.balanceOf(msg.sender));
    }
}
