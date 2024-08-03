// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract PostExample {
    function backdoor(uint256 x) external pure {
        uint256 number = 99;
        unchecked {
            uint256 z = x - 1;
            if (z == 6912213124124531) {
                number = 0;
            } else {
                number = 1;
            }
        }
        assert(number != 0);
    }
}
