// // SPDX-License-Identifier: UNLICENSED
// import "./interfaces/ICurveFi_SwapY.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "./interfaces/AggregatorInterface.sol";
// pragma solidity ^0.8.19;


// contract CurveOracleTwoVolTokens {
//     ICurveFi_SwapY public immutable pool = ICurveFi_SwapY(0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4);
//     address public immutable weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     AggregatorInterface public immutable wethOracle = AggregatorInterface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
//     address public immutable cvx = 0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
//     AggregatorInterface public immutable cvxOracle = AggregatorInterface(0xd962fC30A72A84cE50161031391756Bf2876Af5D);
//     IERC20Metadata public immutable poolToken = IERC20Metadata(0x3A283D9c08E8b55966afb64C515f5143cf907611);

//     constructor(){
//         //pool = ICurveFi_SwapY(_pool);
//     }

//     function getPoolTvl() public view returns (uint256){
//         uint256 bal0 = pool.balances(uint256(0));
//         uint256 bal1 = pool.balances(uint256(1));
//         IERC20Metadata coin0 = IERC20Metadata(pool.coins(0));
//         IERC20Metadata coin1 = IERC20Metadata(pool.coins(1));
//         int256 wethPrice = wethOracle.latestAnswer();
//         int256 cvxPrice = cvxOracle.latestAnswer();
//         uint256 wethTvl = 0;
//         uint256 cvxTvl = 0;
//         if(coin0.decimals() < 8 || coin1.decimals() < 8){
//             revert("Unsupported token");
//         }
//         if(address(coin0) == weth) {
//             wethTvl = (uint256(wethPrice) * bal0) / (uint256(10) ** uint256(coin0.decimals()));
//             cvxTvl = (uint256(cvxPrice) * bal1) / (uint256(10) ** uint256(coin1.decimals()));
//         } else if(address(coin1) == weth ){
//             wethTvl = (uint256(wethPrice) * bal1) / (uint256(10) ** uint256(coin1.decimals() - uint256(8)));
//             cvxTvl = (uint256(cvxPrice) * bal0) / (uint256(10) ** uint256(coin0.decimals() - uint256(8)));
//         } else {
//             revert("!WETH");
//         }
//         return wethTvl + cvxTvl;
//     }

//     function lpToUSD(uint256 _lpAmount) public view returns (uint256){
//         uint256 totalSupply = poolToken.totalSupply();
//         uint256 PRECISION = uint256(10) ** uint256(18);
//         uint256 percent = _lpAmount * PRECISION / totalSupply;
//         //return percent;
//         return percent * getPoolTvl() / PRECISION;
//     }
// }
