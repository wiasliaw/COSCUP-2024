// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface IStaking {
    ////////////////////////////////////////////////////////////////////////////
    // Functions
    ////////////////////////////////////////////////////////////////////////////

    function stake(uint256 asset) external returns (uint256);

    function withdraw(uint256 share) external returns (uint256);

    function convertToAsset(uint256 share) external view returns (uint256);

    function convertToShare(uint256 asset) external view returns (uint256);

    function totalShare() external view returns (uint256);

    function totalAsset() external view returns (uint256);

    function shareOf(address addr) external view returns (uint256);

    function valueOf(address addr) external view returns (uint256);

    ////////////////////////////////////////////////////////////////////////////
    // Events
    ////////////////////////////////////////////////////////////////////////////

    event StakedFrom(address indexed addr, uint256 amount);

    event WithdrawFrom(address indexed addr, uint256 amount);

    ////////////////////////////////////////////////////////////////////////////
    // Errors
    ////////////////////////////////////////////////////////////////////////////

    error ZeroValue();

    error InsufficientValue();
}
