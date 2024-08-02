// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockToken", "MT") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
