// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {PostExample} from "@src/PostExample.sol";

// halmos --contract PostExampleHalmos
contract PostExampleHalmos is SymTest {
    PostExample internal example;

    function setUp() external {
        example = new PostExample();
    }

    function check_backdoor() external view {
        // create symbol as input to check `assert`
        uint256 x = svm.createUint256("VALUE");
        example.backdoor(x);
    }
}
