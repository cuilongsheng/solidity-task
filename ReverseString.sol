// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ReverseString {
    string str = "abcde";

    function reverse() public view returns (string memory) {
        bytes memory bs = bytes(str);
        bytes memory bts = new bytes(bs.length);
        for(uint i=0;i<bs.length;i++) {
            bts[i] = bs[bs.length-i-1];
        }
        return string(bts);
    }
}