# CEX-DEX 
### Smart Analytics


Implementation of the CEX-DEX smart analytics contract for collecting onchain data within DEX pools.

### Supported DEXes

- Polygon
- Optimism
- Arbitrum
- BSC
- Fantom
- Avalanche

### Supported DEXes

- Uniswap V3/V2 (Polygon/Optimism/Arbitrum)
- Kyberswap V3 (Polygon/Optimism/Arbitrum/Avalanche)
- Quickswap V3/V2 (Polygon)
- Thena (BSC)
- DODO (Polygon/BSC/Avalanche)
- Velodrome (Optimism)
- Equalizer (Fantom)
- Other Uniswap V2 forks

### New Features

- Bytes Inputs
- Single/Double Step Swap Simulation Function
- Both Trade Sides per Same Request
- List of Quotes for Single Step Swap Simulation


### Tech

To execute a test swap follow the next steps:

1) ABI can be found [here](https://github.com/Fhneeeh/CEX-DEX-Analytics/blob/main/Onchain/ABI.txt)
2) Deployment Addresses can be found [here](https://github.com/Fhneeeh/CEX-DEX-Analytics/blob/main/Onchain/DeploymentAddresses)
3) Generate bytes params via `encodeParamsForOneStep` or `encodeParamsForTwoStep`
4) Use `getAmountsOutForOneStep` or `getAmountsOutForTwoStep` function to run a simulation

### encodeParamsForOneStep (0xffb3c6e7)

```js
function encodeParamsForOneStep(
        address token0,
        address token1,
        address[] memory routers,
        address[] memory pools,
        uint256 inputAmount0,
        uint256 inputAmount1
    ) external pure returns (bytes memory encodedParams);
```
`token0` corresponds to the token swap should start with

`token1` corresponds to the token swap should end with

`routers` corresponds to the list of router addresses

`pools` corresponds to the list of pools in the same order as router addresses

`inputAmount0` corresponds to `token0` amount when simulating `token0` to `token1` swap

`inputAmount1` corresponds to `token1` amount when simulating `token1` to `token0` swap

### encodeParamsForTwoStep (0xc43da5cd)

```js
function encodeParamsForTwoStep(
        address token0,
        address token1,
        address token2,
        address[] memory routers0,
        address[] memory pools0,
        address[] memory routers1,
        address[] memory pools1,
        uint256 inputAmount0,
        uint256 inputAmount1
    ) external pure returns (bytes memory encodedParams);
```
`token0` corresponds to the token swap should start with

`token1` corresponds to the intermediary token swap should go through 

`token2` corresponds to the token swap should end with

`routers0` corresponds to the list of router addresses for `token0` to `token1` swaps

`pools0` corresponds to the list of pools for `token0` to `token1` swaps in the same order as router addresses

`routers1` corresponds to the list of router addresses for `token1` to `token2` swaps

`pools1` corresponds to the list of pools for `token1` to `token2` swaps in the same order as router addresses

`inputAmount0` corresponds to `token0` amount when simulating `token0` to `token1` swap

`inputAmount1` corresponds to `token2` amount when simulating `token2` to `token0` swap

### getAmountsOutForOneStep (0xe5c46f3a)

```js
function getAmountsOutForOneStep(bytes memory encodedParams)
        external
        view
        returns (
            uint256 amountOut0,
            address bestRouter0,
            address bestPool0,
            uint256[] memory amountOutList0,
            uint256 amountOut1,
            address bestRouter1,
            address bestPool1,
            uint256[] memory amountOutList1
        );
```
`amountOut0` is for the best router/pool swap result for `token0` to `token1`

`bestRouter0` is for the best swap router for `token0` to `token1`

`bestPool0` is for the best swap pool for `token0` to `token1`

`amountOutList0` is for the list of amountOut quotes for the pools `token0` to `token1` in the same order as submitted `pools` 

`amountOut1` is for the best router/pool swap result for `token1` to `token0`

`bestRouter1` is for the best swap router for `token1` to `token0`

`bestPool1` is for the best swap pool for `token1` to `token0`

`amountOutList1` is for the list of amountOut quotes for the pools `token1` to `token0` in the same order as submitted `pools` 

### getAmountsOutForTwoStep (0x6d77babe)

```js
function getAmountsOutForTwoStep(bytes memory encodedParams)
        external
        view
        returns (
            uint256 amountOut0,
            address[] memory bestRoutersList0,
            address[] memory bestPoolsList0,
            uint256 amountOut1,
            address[] memory bestRoutersList1,
            address[] memory bestPoolsList1
        );
```
`amountOut0` is for the best router/pool swap result for `token0` to `token2`

`bestRoutersList0` is for the best swap routers for `token0` to `token1` and `token1` to `token2`

`bestPoolsList0` is for the best swap pools for `token0` to `token1` and `token1` to `token2`

`amountOut1` is for the best router/pool swap result for `token2` to `token1`

`bestRoutersList1` is for the best swap routers for `token2` to `token1` and `token1` to `token0`

`bestPoolsList1` is for the best swap pools for `token2` to `token1` and `token1` to `token0`




