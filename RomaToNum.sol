// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract RomanToNum {
    // 最大长度
    uint8 maxlen = 15;
    // 合法映射
    mapping (string s => uint256 n) nums;
    constructor () {
        nums["I"] = 1;
        nums["V"] = 5;
        nums["X"] = 10;
        nums["L"] = 50;
        nums["C"] = 100;
        nums["D"] = 500;
        nums["M"] = 1000;
    }
    function romanToInt(string memory roman)  public view returns (int256) {
        bytes memory _roman = bytes(roman);
        uint256 len = _roman.length;
        require(len<=15 && len>0);
        // 存储所有的输入项字符
        int256[] memory numberList = new int256[](len);
        // 最终的数字
        int256 rtn = 0;
        for(uint256 i = 0;i<len;i++) {
            // 把每个byte1根据映射,转为数字,保存到数组
            string memory k = string(abi.encodePacked(_roman[i]));
            int256 n = int256(nums[k]);
            require(n>0); // 此处是否合理
            // 判断一下前面一个是否比当前的小,如果是,则转为负数,并加上两次
            if(i>0 && n > numberList[i-1]) {
                int256 rn = -numberList[i-1];
                numberList[i-1] = rn;
                rtn = rtn + rn + rn;
            }
            numberList[i] = n; // 保存到数组,可能会用到
            rtn += numberList[i]; // 计算最后的数字
        }
        return rtn;
    }
}