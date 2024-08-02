// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Address} from "../lib/openzeppelin-contracts/contracts/utils/Address.sol";
import {IStakingETH} from "./interfaces/IStaking.sol";

contract StakingETH is IStakingETH {
    using Address for address;

    ////////////////////////////////////////////////////////////////////////////
    // Variables
    ////////////////////////////////////////////////////////////////////////////

    uint256 internal _totalShare;

    mapping(address => uint256) internal _shares;

    ////////////////////////////////////////////////////////////////////////////
    // User-facing Functions
    ////////////////////////////////////////////////////////////////////////////

    function stake() external payable returns (uint256 share) {
        // check
        if (msg.value == 0) {
            revert ZeroValue();
        }

        // effect
        share = convertToShare(msg.value);
        unchecked {
            _totalShare += share;
            _shares[msg.sender] += share;
        }

        // emit event
        emit StakedFrom(msg.sender, msg.value);
    }

    function withdraw(uint256 share) external returns (uint256 asset) {
        // check
        if (_shares[msg.sender] < share) {
            revert InsufficientValue();
        }

        // effect
        asset = convertToAsset(share);
        unchecked {
            _totalShare -= share;
            _shares[msg.sender] -= share;
        }

        // interact
        Address.sendValue(payable(msg.sender), asset);
        // emit event
        emit WithdrawFrom(msg.sender, asset);
    }

    receive() external payable {
        // allow donate
    }

    ////////////////////////////////////////////////////////////////////////////
    // Exchange Rate
    ////////////////////////////////////////////////////////////////////////////

    function convertToAsset(uint256 share) public view returns (uint256 asset) {
        asset = (share * _totalAsset()) / _totalShareF();
    }

    function convertToShare(uint256 asset) public view returns (uint256 share) {
        if (_totalShare == 0) {
            share = asset;
        } else {
            share = (asset * _totalShareF()) / _totalAsset();
        }
    }

    function _totalAsset() internal view virtual returns (uint256) {
        return address(this).balance;
    }

    function _totalShareF() internal view virtual returns (uint256) {
        return _totalShare;
    }

    ////////////////////////////////////////////////////////////////////////////
    // View Functions
    ////////////////////////////////////////////////////////////////////////////

    function shareOf(address addr) external view returns (uint256) {
        return _shares[addr];
    }

    function valueOf(address addr) external view returns (uint256) {
        return convertToAsset(_shares[addr]);
    }

    function totalShare() external view returns (uint256) {
        return _totalShareF();
    }

    function totalAsset() external view returns (uint256) {
        return _totalAsset();
    }
}
