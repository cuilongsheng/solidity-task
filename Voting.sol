// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {

    // 候选人和得票数
    mapping (address => uint8 votes) public candidates;
    mapping

    // 添加候选人
    function addCandidateToList(address user) external returns(bool) {
        require(candidates(user), "The user is already on the candidate list!");
        // candidates[user] = 0;
    }

    // 用户投票给某个候选人
}