// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {StakingV1} from "@src/StakingV1.sol";
import {MockERC20} from "@test/mock/MockERC20.sol";
import {Handler} from "@test/foundry/Handler.sol";

abstract contract FoundryBaseTest is Test {
    MockERC20 internal token;

    StakingV1 internal instance_v1;

    Handler internal handler;

    address internal user;

    address internal exploit;

    uint256 internal constant INIT_BALANCE = 10000e18;

    function setUp() public virtual {
        token = new MockERC20();
        instance_v1 = new StakingV1(address(token));
        handler = new Handler(token, instance_v1);

        // init the market
        token.mint(address(this), 1);
        token.approve(address(instance_v1), 1);
        instance_v1.stake(1);

        // setup target contract
        targetContract(address(handler));
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
