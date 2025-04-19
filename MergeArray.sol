// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./LibSafeMath.sol";
contract MergeSortArray {
    
    // 两个数组合并
    function mergeSortArr(int256[] memory arr1, int256[] memory arr2)
        public
        pure
        returns (int256[] memory)
    {
        uint256 len = arr1.length + arr2.length;
        int256[] memory newArr = new int256[](len);
        uint8 index = 0;
        //合并数组
        for (uint256 i = 0; i < arr1.length; i++) {
            newArr[index] = arr1[i];
            index++;
        }
        for (uint256 i = 0; i < arr2.length; i++) {
            newArr[index] = arr2[i];
            index++;
        }
        return SafeMath.bubbleSort(newArr);
    }
}
