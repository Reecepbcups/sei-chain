// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// forge install foundry-rs/forge-std --no-commit
import "forge-std/Script.sol";

import "../ERC20Token.sol";

contract ERC20TokenScript is Script {
    function setUp() public {}

    // forge script script/ERC20.s.sol:ERC20TokenScript
    function run() public {
        // put in a .env file
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        address acc = vm.addr(privateKey);

        console.log("account", acc);

        vm.startBroadcast(privateKey);
        // deploy token
        ERC20Token token = new ERC20Token("Test Foundry", "TT");
        // mint
        token.mint(acc, 1000000000000000000000000);
        vm.stopBroadcast();
    }
}
