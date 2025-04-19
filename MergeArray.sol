// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MergeSortArray {
    // 给数组排序
    function bubbleSort(int256[] memory array)
        public
        pure
        returns (int256[] memory)
    {
        int256[] memory arr = array;
        uint256 n = arr.length;
        for (uint256 i = 0; i < n - 1; i++) {
            bool swapped = false;
            for (uint256 j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    // 交换 arr[j] 和 arr[j+1]
                    (arr[j], arr[j + 1]) = (arr[j + 1], arr[j]);
                    swapped = true;
                }
            }
            if (!swapped) break; // 如果本轮无交换，提前结束
        }
        return arr;
    }

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
        return bubbleSort(newArr);
    }
}
