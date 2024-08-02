// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract SMTSolverCounter {
    uint256 internal counter;

    constructor() {
        counter = 1;
    }

    function backdoor(uint256 x) external {
        if (x == 2 ** 133) {
            counter = 0;
        }
        __internal_assert();
    }

    function add() external {
        counter += 1;
        __internal_assert();
    }

    function __internal_assert() internal view {
        assert(counter != 0);
    }
}

contract SMTSolverMath {
    function div(uint256 a, uint256 b) external pure returns (uint256) {
        return a / b;
    }
}
