// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IERC20, SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IStaking} from "./interfaces/IStaking.sol";

contract StakingV1 is IStaking {
    using SafeERC20 for IERC20;

    ////////////////////////////////////////////////////////////////////////////
    // Variables
    ////////////////////////////////////////////////////////////////////////////

    address internal _underlyingToken;

    uint256 internal _totalShare;

    mapping(address => uint256) internal _shares;

    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////////////////////////////////

    constructor(address token) {
        _underlyingToken = token;
    }

    ////////////////////////////////////////////////////////////////////////////
    // User-facing Functions
    ////////////////////////////////////////////////////////////////////////////

    function stake(uint256 asset) external returns (uint256 share) {
        // check
        if (asset == 0) {
            revert ZeroValue();
        }

        // effect
        share = convertToShare(asset);
        unchecked {
            _totalShare += share;
            _shares[msg.sender] += share;
        }

        // interact
        IERC20(_underlyingToken).safeTransferFrom(msg.sender, address(this), asset);
        // emit event
        emit StakedFrom(msg.sender, asset);
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
        IERC20(_underlyingToken).safeTransfer(msg.sender, asset);
        // emit event
        emit WithdrawFrom(msg.sender, asset);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Exchange Rate
    ////////////////////////////////////////////////////////////////////////////

    function convertToAsset(uint256 share) public view returns (uint256 asset) {
        asset = (share * _totalAsset()) / _totalShare;
    }

    function convertToShare(uint256 asset) public view returns (uint256 share) {
        if (_totalShare == 0) {
            share = asset;
        } else {
            share = (asset * _totalShare) / _totalAsset();
        }
    }

    function _totalAsset() internal view returns (uint256) {
        return IERC20(_underlyingToken).balanceOf(address(this));
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
        return _totalShare;
    }

    function totalAsset() external view returns (uint256) {
        return _totalAsset();
    }
}
