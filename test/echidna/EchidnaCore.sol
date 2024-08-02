// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {StakingETH} from "../../src/StakingETH.sol";

contract StakingInvariant is StakingETH {
    address echidnaTester = tx.origin;

    function echidna_rate_1() external view returns (bool) {
        return convertToAsset(1 ether) != 0;
    }

    function echidna_rate_2() external view returns (bool) {
        return convertToShare(1 ether) != 0;
    }

    function _totalAsset() internal view override returns (uint256) {
        // init the market
        return super._totalAsset() + 1;
    }

    function _totalShareF() internal view override returns (uint256) {
        // init the market
        return super._totalShareF() + 1;
    }
}
