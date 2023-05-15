// SPDX-License-Identifier: UNLICENSED
import "./interfaces/ICurveFi_SwapY.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
//import "./interfaces/AggregatorInterface.sol";
import "chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";
import "chainlink/contracts/src/v0.8/Denominations.sol";
import "forge-std/console.sol";
pragma solidity ^0.8.19;


contract CurveOracleTwoVolTokens {
    ICurveFi_SwapY public pool; //ICurveFi_SwapY(0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4);
    address public immutable weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public immutable eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    mapping (address => bool) useLpToken;
    IERC20Metadata public poolToken;
    FeedRegistryInterface public registry;
    constructor(address _registry){
        registry = FeedRegistryInterface(_registry);
        useLpToken[0xDC24316b9AE028F1497c275EB9192a3Ea0f67022] = true;
        //pool = ICurveFi_SwapY(_pool);
        //poolToken = IERC20Metadata(pool.token());

        //pool = ICurveFi_SwapY(_pool);
    }

    function getPrice(address base, address quote) public view returns (int) {
        // prettier-ignore
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = registry.latestRoundData(base, quote);
        return price;
    }

    function getUSD() external view returns (address){
        return Denominations.USD;
    }

    function getPoolTvl(address _pool) public view returns (uint256){
        ICurveFi_SwapY pool = ICurveFi_SwapY(_pool);
        uint256 bal0 = pool.balances(uint256(0));
        uint256 bal1 = pool.balances(uint256(1));
        IERC20Metadata coin0 = IERC20Metadata(pool.coins(0));
        IERC20Metadata coin1 = IERC20Metadata(pool.coins(1));
        int256 coin0Price = 0;
        int256 coin1Price = 0;
        if(address(coin0) == weth || address(coin0) == eth ){
            coin0Price = getPrice(Denominations.ETH, Denominations.USD);
            coin1Price = getPrice(address(coin1), Denominations.USD);
        } else if (address(coin1) == weth || address(coin1) == eth){
            coin0Price = getPrice(address(coin0), Denominations.USD);
            coin1Price = getPrice(Denominations.ETH, Denominations.USD);
        } else {
            revert("!WETH");
        }

        uint256 wethTvl = 0;
        uint256 otherTvl = 0;
        if(address(coin0) == weth){
            wethTvl = (uint256(coin0Price) * bal0) / (uint256(10) ** uint256(coin0.decimals()));
            otherTvl = (uint256(coin1Price) * bal1) / (uint256(10) ** uint256(coin1.decimals()));
        } else if (address(coin1) == weth){
            wethTvl = (uint256(coin1Price) * bal1) / (uint256(10) ** uint256(coin1.decimals()));
            otherTvl = (uint256(coin0Price) * bal0) / (uint256(10) ** uint256(coin0.decimals()));
        } else if(address(coin0) == eth) {
            wethTvl = (uint256(coin0Price) * bal0) / (uint256(10) ** uint256(18));
            otherTvl = (uint256(coin1Price) * bal1) / (uint256(10) ** uint256(coin1.decimals()));
        } else if(address(coin1) == eth){
            wethTvl = (uint256(coin1Price) * bal1) / (uint256(10) ** uint256(18));
            otherTvl = (uint256(coin0Price) * bal0) / (uint256(10) ** uint256(coin0.decimals()));
        } else {
            revert("!WETH");
        }
        return wethTvl + otherTvl;
    }

    function lpToUSD(uint256 _lpAmount, address _pool) public view returns (uint256){
        ICurveFi_SwapY pool = ICurveFi_SwapY(_pool);
        IERC20Metadata token;
        if(useLpToken[_pool]){
            token = IERC20Metadata(pool.lp_token());
        } else {
            token = IERC20Metadata(pool.token());
        }
        
        uint256 totalSupply = token.totalSupply();
        uint256 PRECISION = uint256(10) ** uint256(18);
        uint256 percent = _lpAmount * PRECISION / totalSupply;
        //return percent;
        return percent * getPoolTvl(_pool) / PRECISION;
    }
}
