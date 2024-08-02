// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./FoundryBase.t.sol";

contract InvariantStakingV1 is FoundryBaseTest {
    function invariant_normal_user_should_not_loss() external view {
        handler.forActor(1, this.assertAccounting);
    }

    function assertAccounting(address account) external view {
        uint256 balanceOfAddr = token.balanceOf(account);
        uint256 valueOfAddr = instance_v1.valueOf(account);
        // allow for 5%
        assertApproxEqRel((balanceOfAddr + valueOfAddr), INIT_BALANCE, 0.05e18);
    }
}
