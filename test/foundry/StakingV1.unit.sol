// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./FoundryBase.t.sol";

contract UnitTestStakingV1 is FoundryBaseTest {
    function setUp() public override {
        super.setUp();
        _prepare();
    }

    function test_unit_stake() external PrankWrapper(user) {
        token.approve(address(instance_v1), type(uint256).max);

        uint256 expectShare = instance_v1.convertToShare(500_000e18);
        // action
        instance_v1.stake(500_000e18);
        // assert
        assertEq(expectShare, instance_v1.shareOf(user));
    }

    function test_unit_withdraw() external PrankWrapper(user) {
        token.approve(address(instance_v1), type(uint256).max);
        instance_v1.stake(500_000e18);

        uint256 userAssetBefore = token.balanceOf(user);
        uint256 userShare = instance_v1.shareOf(user);
        uint256 expectAsset = instance_v1.convertToAsset(userShare);
        // action
        instance_v1.withdraw(userShare);
        // assert
        assertEq(token.balanceOf(user), userAssetBefore + expectAsset);
    }
}
