// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {

    // 候选人和得票数
    mapping (address => uint8 votes) public candidates; 
    // 候选人是否存在
    mapping (address => bool) public isCandidate;
    // 某个人是否已经投过票
    mapping (address => bool) public isVoted;
    // 所有候选人
    address[] public list;

    error CandidateError(string errorTip);


    // 添加候选人
    function addCandidateToList(address user) external {
        require(!isCandidate[user], "The user is already on the candidate list!");
        candidates[user] = 0;
        isCandidate[user] = true;
        list.push(user);
    }

    // 用户投票给某个候选人
    function voteToCandidate(address user) external  {
        if(list.length == 0) {
            revert CandidateError("No candidate exist!");
        }
        // require(isCandidate[msg.sender], "You cannot vote for yourself!");
        require(!isVoted[user], "You have already cast your vote!");
        require(isCandidate[user], "The candidate does not exist");
        candidates[user] += 1;
        isVoted[msg.sender] = true;
    }
    
    // 查询某个候选人的票数
    function getVotes(address user) external view returns (uint256){
         if(list.length == 0) {
            revert CandidateError("No candidate exist!");
        }
        require(isCandidate[user], "The candidate does not exist");
        return candidates[user];
    }

    // 重置所有候选人票数
    function reset() external {
         if(list.length == 0) {
            revert CandidateError("No candidate exist!");
        }
        for(uint8 i=0;i<list.length;i++) {
            delete candidates[list[i]];
        }
    }
}