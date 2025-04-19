// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./LibSafeMath.sol";

contract BinarySearch {
    using SafeMath for uint[];
    // 有序数组
    // left, right 找到middleIndex,把目标值和middle比较
    function search(int256[] memory arr, int256 target)
        public
        pure
        returns (int256)
    {
        // 先排序
        int256[] memory array = SafeMath.bubbleSort(arr);
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
}
