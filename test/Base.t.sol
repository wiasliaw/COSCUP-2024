// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {StakingV1} from "../src/StakingV1.sol";
import {MockERC20} from "./mock/MockERC20.sol";

abstract contract BaseTest is Test {
    MockERC20 internal token;

    StakingV1 internal instance_v1;

    address internal user;

    address internal exploit;

    uint256 internal constant INIT_BALANCE = 1_000_000e18;

    function setUp() public virtual {
        token = new MockERC20();
        instance_v1 = new StakingV1(address(token));
    }

    function _prepare() internal {
        user = makeAddr("USER");
        deal(address(token), user, INIT_BALANCE);
        exploit = makeAddr("Exploit");
        deal(address(token), exploit, INIT_BALANCE);
    }

    modifier PrankWrapper(address sender) {
        vm.startPrank(sender);
        _;
        vm.stopPrank();
    }
}
