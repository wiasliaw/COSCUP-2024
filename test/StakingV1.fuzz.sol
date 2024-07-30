// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Base.t.sol";

contract FuzzTestStakingV1 is BaseTest {
    function setUp() public override {
        super.setUp();
        _prepare();
    }

    function testFuzz_stake(uint256 asset) external PrankWrapper(user) {
        vm.assume(asset < INIT_BALANCE);
        vm.assume(asset > 0);

        // setup before target action
        token.approve(address(instance_v1), type(uint256).max);

        uint256 expectShare = instance_v1.convertToShare(asset);
        // action
        instance_v1.stake(asset);
        // assert
        assertEq(INIT_BALANCE - asset, token.balanceOf(user));
        assertEq(expectShare, instance_v1.shareOf(user));
    }

    function testFuzz_withdraw(uint256 depositAsset, uint256 withdrawShare) external PrankWrapper(user) {
        vm.assume(depositAsset <= INIT_BALANCE);
        vm.assume(depositAsset > 0);

        // setup before target action
        token.approve(address(instance_v1), type(uint256).max);
        instance_v1.stake(depositAsset);

        // target action
        uint256 userShareBefore = instance_v1.shareOf(user);
        vm.assume(withdrawShare > 0);
        vm.assume(withdrawShare <= userShareBefore);

        uint256 userAssetBefore = token.balanceOf(user);
        uint256 expectAsset = instance_v1.convertToAsset(withdrawShare);
        // action
        instance_v1.withdraw(withdrawShare);
        // assert
        assertEq(token.balanceOf(user), userAssetBefore + expectAsset);
        assertEq(instance_v1.shareOf(user), userShareBefore - withdrawShare);
    }
}
