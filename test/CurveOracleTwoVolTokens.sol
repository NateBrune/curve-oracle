// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CurveOracleTwoVolTokens.sol";
import "forge-std/console.sol";

contract CurveOracleTwoVolTokensTest is Test {
    CurveOracleTwoVolTokens public oracle;

    function setUp() public {
        //address pool = 0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4;
        oracle = new CurveOracleTwoVolTokens();
    }

    function testTvl() public {
        uint256 tvl = oracle.getPoolTvl();
        console.log("TVL: ", tvl);
        //assertEq(tvl, 1);
    }

    function testPrice() public {
        uint256 five = uint256(158) * (uint256(10) ** uint256(18));
        uint256 price = oracle.lpToUSD(five);
        console.log("Price: ", price);
        //assertEq(tvl, 1);
    }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
