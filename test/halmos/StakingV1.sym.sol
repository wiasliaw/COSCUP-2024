// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

import {StakingV1} from "@src/StakingV1.sol";
import {MockERC20} from "@test/mock/MockERC20.sol";

contract StakingV1Symbol is SymTest, Test {
    MockERC20 internal token;
    StakingV1 internal instance;
    address[] internal actors;

    uint256 public constant INIT_TOKEN = 10000e18;

    function setUp() external {
        token = new MockERC20();
        instance = new StakingV1(address(token));

        // setting
        address user1 = makeAddr("user-1");
        address user2 = makeAddr("user-2");
        actors.push(user1);
        actors.push(user2);

        for (uint8 i = 0; i < actors.length; i++) {
            vm.startPrank(actors[i]);
            token.mint(actors[i], INIT_TOKEN);
            token.approve(address(instance), type(uint256).max);
            vm.stopPrank();
        }
    }

    function check_none_loss(uint256 asset) external {
        uint256 sendToken = svm.createUint256("send token");

        bound(asset, 1, token.balanceOf(actors[0]));
        bound(sendToken, 1, token.balanceOf(actors[1]));

        // other's action
        vm.prank(actors[1]);
        token.transfer(address(instance), sendToken);

        // normal user's action
        vm.prank(actors[0]);
        instance.stake(asset);

        // invariant
        uint256 balanceOfAddr = token.balanceOf(actors[0]);
        uint256 valueOfAddr = instance.valueOf(actors[0]);
        // allow for 5%
        // assertApproxEqRel((balanceOfAddr + valueOfAddr), INIT_TOKEN, 0.05e18);
        // cheatcode not supported by halmos
        _assertApproxEqRel((balanceOfAddr + valueOfAddr), INIT_TOKEN, 0.05e18);
    }

    function _assertApproxEqRel(uint256 a, uint256 b, uint256 maxDelta) internal pure {
        uint256 sub = a >= b ? a - b : b - a;
        uint256 delta = sub * 1e18 / a;
        assert(delta <= maxDelta);
    }
}
