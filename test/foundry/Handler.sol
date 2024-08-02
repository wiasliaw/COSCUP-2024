// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {StakingV1} from "@src/StakingV1.sol";
import {MockERC20} from "@test/mock/MockERC20.sol";

contract Handler is Test {
    MockERC20 internal token;

    StakingV1 internal instance_v1;

    address[] internal actors;

    uint256 public constant INIT_TOKEN = 10000e18;

    constructor(MockERC20 token_, StakingV1 instance_) {
        token = token_;
        instance_v1 = instance_;

        // setting
        address user1 = makeAddr("user-1");
        address user2 = makeAddr("user-2");
        actors.push(user1);
        actors.push(user2);

        for (uint8 i = 0; i < actors.length; i++) {
            vm.startPrank(actors[i]);
            token.mint(actors[i], INIT_TOKEN);
            token.approve(address(instance_v1), type(uint256).max);
            vm.stopPrank();
        }
    }

    modifier useActor(uint256 seed) {
        address currActor = actors[seed % actors.length];
        vm.startPrank(currActor);
        _;
        vm.stopPrank();
    }

    function _getActor(uint256 seed) internal view returns (address) {
        return actors[seed % actors.length];
    }

    function stake(uint256 asset, uint256 seed) public useActor(seed) {
        asset = bound(asset, 1, token.balanceOf(_getActor(seed)));
        instance_v1.stake(asset);
    }

    function withdraw(uint256 share, uint256 seed) public useActor(seed) {
        share = bound(share, 0, instance_v1.shareOf(_getActor(seed)));
        instance_v1.withdraw(share);
    }

    function donate(uint256 asset, uint256 seed) public useActor(seed) {
        if (msg.sender == actors[1]) {
            return; // not allow actors[1] to donate
        }
        asset = bound(asset, 1, token.balanceOf(_getActor(seed)));
        token.transfer(address(instance_v1), asset);
    }

    function forActor(uint256 index, function(address) external view func) public view {
        func(actors[index]);
    }
}
