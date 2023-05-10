// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.6 <0.8.8;
pragma abicoder v2;

interface DEXLibrary {

    function DODOgetAmountOut(
        address tokenFrom,
        address pool,
        uint256 inputAmount
    ) external view returns (uint256);

    function KyberV3getAmountOut(
        address tokenFrom,
        address pool,
        uint256 inputAmount
    ) external view returns (uint256);


    function UniV2getAmountOut(
        address tokenFrom,
        address pool,
        address router,
        uint256 inputAmount
    ) external view returns (uint256);


}

contract SmartAnalytics {


    address private constant KyberV3Router = 0xC1e7dFE73E1598E3910EF4C7845B68A9Ab6F4c83;

    address private constant DodoV2Router = 0x2cD18557E14aF72DAA8090BcAA95b231ffC9ea26;


    address private constant DEXLibraryAddress = 0x8144ccaD27bD87cBB3AEc1FCE20964A8d793A3B0;

    function encodeParamsForOneStep(
        address token0, 
        address token1, 
        address[] memory routers, 
        address[] memory pools, 
        uint inputAmount0,
        uint inputAmount1
        ) external pure returns (bytes memory encodedParams) {

       encodedParams = abi.encode(
            token0,
            token1,
            routers,
            pools,
            inputAmount0,
            inputAmount1
        );

    }

    function findBestRouter(address tokenFrom, uint inputAmount, bytes memory encodedParams) internal view returns (uint bestAmountOut, address bestRouter, address bestPool, uint[] memory amountOutList) {

        (,,address[] memory routers, address[] memory pools,,
        ) = abi.decode(encodedParams,(address,address,address[],address[], uint, uint));

        amountOutList = new uint[](routers.length);

        uint amountOut;
        bestAmountOut = 0;


        for (uint i = 0; i < routers.length; i++) {


            if (routers[i] == KyberV3Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).KyberV3getAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else if (routers[i] == DodoV2Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).DODOgetAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else {
                amountOut = DEXLibrary(DEXLibraryAddress).UniV2getAmountOut(tokenFrom, pools[i], routers[i], inputAmount);
            }

            amountOutList[i] = amountOut;

            if (amountOut > bestAmountOut) {
                bestAmountOut = amountOut;
                bestRouter = routers[i];
                bestPool = pools[i];
            }

        }

    }


    function getAmountsOutForOneStep(bytes memory encodedParams
    ) external view returns (
        uint amountOut0, 
        address bestRouter0, 
        address bestPool0, 
        uint[] memory amountOutList0,
        uint amountOut1, 
        address bestRouter1, 
        address bestPool1, 
        uint[] memory amountOutList1){

        (address token0, address token1 ,,, uint inputAmount0, uint inputAmount1) = abi.decode(encodedParams,(address,address,address[],address[],uint,uint));
        
        (amountOut0, bestRouter0, bestPool0, amountOutList0) = findBestRouter(token0, inputAmount0, encodedParams);
        (amountOut1, bestRouter1, bestPool1, amountOutList1) = findBestRouter(token1, inputAmount1, encodedParams);

    }

    function encodeParamsForTwoStep(
        address token0, 
        address token1, 
        address token2,
        address[] memory routers0, 
        address[] memory pools0, 
        address[] memory routers1, 
        address[] memory pools1,
        uint inputAmount0,
        uint inputAmount1
        ) external pure returns (bytes memory encodedParams) {

       encodedParams = abi.encode(
            token0,
            token1,
            token2,
            routers0,
            pools0,
            routers1,
            pools1,
            inputAmount0,
            inputAmount1
        );

    }

    function getAmountsOutForTwoStep(bytes memory encodedParams
    ) external view returns (
        uint amountOut0, 
        address[] memory bestRoutersList0, 
        address[] memory bestPoolsList0, 
        uint amountOut1, 
        address[] memory bestRoutersList1, 
        address[] memory bestPoolsList1){

        (address token0, address token1, address token3 ,,,,, uint inputAmount0, uint inputAmount1) = abi.decode(encodedParams,(address,address,address,address[],address[],address[],address[],uint,uint));

        bestRoutersList0 = new address[](2);
        bestPoolsList0 = new address[](2);
        bestRoutersList1 = new address[](2);
        bestPoolsList1 = new address[](2);

        (amountOut0, bestRoutersList0[0], bestPoolsList0[0], ) = findBestRouterO0(token0,inputAmount0,encodedParams);
        (amountOut0, bestRoutersList0[1], bestPoolsList0[1], ) = findBestRouterO1(token1,amountOut0,encodedParams);

        (amountOut1, bestRoutersList1[0], bestPoolsList1[0], ) = findBestRouterA0(token3,inputAmount1,encodedParams);
        (amountOut1, bestRoutersList1[1], bestPoolsList1[1], ) = findBestRouterA1(token1,amountOut1,encodedParams);

    }

    function findBestRouterO0(address tokenFrom, uint inputAmount, bytes memory encodedParams) internal view returns (uint bestAmountOut, address bestRouter, address bestPool, uint[] memory amountOutList) {

        (,,,address[] memory routers, address[] memory pools,,,,
        ) = abi.decode(encodedParams,(address,address,address,address[],address[], address[], address[], uint, uint));

        amountOutList = new uint[](routers.length);

        uint amountOut;
        bestAmountOut = 0;


        for (uint i = 0; i < routers.length; i++) {

            if (routers[i] == KyberV3Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).KyberV3getAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else if (routers[i] == DodoV2Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).DODOgetAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else {
                amountOut = DEXLibrary(DEXLibraryAddress).UniV2getAmountOut(tokenFrom, pools[i], routers[i], inputAmount);
            }

            amountOutList[i] = amountOut;

            if (amountOut > bestAmountOut) {
                bestAmountOut = amountOut;
                bestRouter = routers[i];
                bestPool = pools[i];
            }

        }

    }

    function findBestRouterO1(address tokenFrom, uint inputAmount, bytes memory encodedParams) internal view returns (uint bestAmountOut, address bestRouter, address bestPool, uint[] memory amountOutList) {

        (,,,,,address[] memory routers, address[] memory pools,,
        ) = abi.decode(encodedParams,(address,address,address,address[],address[], address[], address[], uint, uint));

        amountOutList = new uint[](routers.length);

        uint amountOut;
        bestAmountOut = 0;


        for (uint i = 0; i < routers.length; i++) {

            if (routers[i] == KyberV3Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).KyberV3getAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else if (routers[i] == DodoV2Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).DODOgetAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else {
                amountOut = DEXLibrary(DEXLibraryAddress).UniV2getAmountOut(tokenFrom, pools[i], routers[i], inputAmount);
            }

            amountOutList[i] = amountOut;

            if (amountOut > bestAmountOut) {
                bestAmountOut = amountOut;
                bestRouter = routers[i];
                bestPool = pools[i];
            }

        }

    }

    function findBestRouterA0(address tokenFrom, uint inputAmount, bytes memory encodedParams) internal view returns (uint bestAmountOut, address bestRouter, address bestPool, uint[] memory amountOutList) {

        (,,,,,address[] memory routers, address[] memory pools,,
        ) = abi.decode(encodedParams,(address,address,address,address[],address[], address[], address[], uint, uint));

        amountOutList = new uint[](routers.length);

        uint amountOut;
        bestAmountOut = 0;


        for (uint i = 0; i < routers.length; i++) {

            if (routers[i] == KyberV3Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).KyberV3getAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else if (routers[i] == DodoV2Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).DODOgetAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else {
                amountOut = DEXLibrary(DEXLibraryAddress).UniV2getAmountOut(tokenFrom, pools[i], routers[i], inputAmount);
            }

            amountOutList[i] = amountOut;

            if (amountOut > bestAmountOut) {
                bestAmountOut = amountOut;
                bestRouter = routers[i];
                bestPool = pools[i];
            }

        }

    }

    function findBestRouterA1(address tokenFrom, uint inputAmount, bytes memory encodedParams) internal view returns (uint bestAmountOut, address bestRouter, address bestPool, uint[] memory amountOutList) {

        (,,,address[] memory routers, address[] memory pools,,,,
        ) = abi.decode(encodedParams,(address,address,address,address[],address[], address[], address[], uint, uint));

        amountOutList = new uint[](routers.length);

        uint amountOut;
        bestAmountOut = 0;


        for (uint i = 0; i < routers.length; i++) {

            if (routers[i] == KyberV3Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).KyberV3getAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else if (routers[i] == DodoV2Router) {
                amountOut = DEXLibrary(DEXLibraryAddress).DODOgetAmountOut(tokenFrom, pools[i], inputAmount);
            }

            else {
                amountOut = DEXLibrary(DEXLibraryAddress).UniV2getAmountOut(tokenFrom, pools[i], routers[i], inputAmount);
            }

            amountOutList[i] = amountOut;

            if (amountOut > bestAmountOut) {
                bestAmountOut = amountOut;
                bestRouter = routers[i];
                bestPool = pools[i];
            }

        }

    }

}
