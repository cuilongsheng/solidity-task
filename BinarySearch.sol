// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BinarySearch {
    // 有序数组
    // left, right 找到middleIndex,把目标值和middle比较
    function search(int256[] memory arr, int256 target)
        public
        pure
        returns (int256)
    {
        // 先排序
        int256[] memory array = bubbleSort(arr);
        uint256 left = 0;
        uint256 right = array.length - 1;
        uint256 middle;
        while (left <= right) {
            middle = left + (right - left) / 2;
            if (target == array[middle]) {
                return int256(middle);
            } else if (target > array[middle]) {
                left = middle + 1;
            } else if (target < array[middle]) {
                right = middle;
            }
        }
        return -1;
    }

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
            if (!swapped) break;
        }
        return arr;
    }
}
