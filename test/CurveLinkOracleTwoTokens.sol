// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CurveLinkOracleTwoTokens.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../src/interfaces/ICurveFi_SwapY.sol";
import "forge-std/console.sol";

contract CurveLinkOracleTwoTokensTest is Test {
    CurveOracleTwoVolTokens public oracle;
    address testPool = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;
    mapping (address => bool) lpToken;

    function setUp() public {
        
        address registry = 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;
        lpToken[0xDC24316b9AE028F1497c275EB9192a3Ea0f67022] = true;
        
        oracle = new CurveOracleTwoVolTokens(registry);
    }

    function testUSD() public {
        address usd = oracle.getUSD();
        console.log("usd", usd);
    }

    function testTvl() public {
        uint256 tvl = oracle.getPoolTvl(testPool);
        console.log("TestPool TVL: ", tvl);
        //assertEq(tvl, 1);
    }

    function testPrice() public {
        IERC20Metadata token;
        console.log("lp_token", ICurveFi_SwapY(testPool).lp_token());
        console.log("lpToken[testPool]", lpToken[testPool]);
        if(lpToken[testPool]){
            token = IERC20Metadata(ICurveFi_SwapY(testPool).lp_token());
        } else {
            //token = IERC20Metadata(ICurveFi_SwapY(testPool).token());
        }
        
        
        

        uint256 couple = token.totalSupply(); //uint256(204049) * (uint256(10) ** uint256(18));

        uint256 price = oracle.lpToUSD(couple, testPool);
        console.log("TVL from lpToUSD: ", price);
        //assertEq(tvl, 1);
    }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
