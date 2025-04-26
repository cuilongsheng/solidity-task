// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract BeggingContract is ReentrancyGuard {
    mapping(address => uint256) private balances; // 每个捐赠者的地址和捐赠金额
    address[] public donors; // 所有捐赠者地址

    address private owner;
    // 捐赠时间限制
    uint256 public donationStartTime;
    uint256 public donationEndTime;
    bool public isDonationPeriodSet = false;

    event RecordDonations(address account, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "you are not owner");
        _;
    }

    // 设置捐赠时间段
    function setDonationPeriod(uint256 startTime, uint256 endTime)
        external
        onlyOwner
    {
        require(startTime < endTime, "Start time must be before end time");
        require(endTime > block.timestamp, "End time must be in the future");

        donationStartTime = startTime;
        donationEndTime = endTime;
        isDonationPeriodSet = true;
    }

    // 允许用户向合约发送以太币,并记录捐赠信息
    function donate() external payable {
        require(isDonationPeriodSet, "Donation period not set");
        require(
            block.timestamp >= donationStartTime &&
                block.timestamp <= donationEndTime,
            "Donations only allowed during specified period"
        );
        require(msg.value > 0, "donate value is not valid");
        balances[msg.sender] += msg.value;
        donors.push(msg.sender);

        emit RecordDonations(msg.sender, msg.value);
    }

    // 合约所有者提取所有资金
    function withDraw(uint256 amount) external nonReentrant onlyOwner {
        require(address(this).balance >= amount, "balance is not enough");
        payable(owner).transfer(amount);
    }

    // 允许查询某个地址的捐赠金额
    function getDonation(address account) external view returns (uint256) {
        return balances[account];
    }

    // 查看总金额
    function getTotalDonations() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // 转移owner的功能
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address"); // 零地址不是有效的用户地址，如果意外将所有权转给零地址，资金将永久锁定
        owner = newOwner;
    }

    // 查看前三名捐赠者, 如果有捐款相同的, 目前按照后捐的算下一名了, 如果考虑都是同一名次,top1/top2/top3改成数组即可
    function getTopThreeDonors()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        // 第一名
        address top1;
        uint256 top1Amount = 0;
        // 第二名
        address top2;
        uint256 top2Amount = 0;
        // 第三名
        address top3;
        uint256 top3Amount = 0;

        // 考虑消耗gas,这里用了个笨方法
        for (uint256 i = 0; i < donors.length; i++) {
            uint256 currentAmount = balances[donors[i]];
            if (currentAmount > top1Amount) {
                top3 = top2;
                top3Amount = top2Amount;
                top2 = top1;
                top2Amount = top1Amount;
                top1 = donors[i];
                top1Amount = currentAmount;
            } else if (currentAmount > top2Amount) {
                top3 = top2;
                top3Amount = top2Amount;
                top2 = donors[i];
                top2Amount = currentAmount;
            } else if (currentAmount > top3Amount) {
                top3 = donors[i];
                top3Amount = currentAmount;
            }
        }
        // 这里用struct[]会不会更好
        address[] memory tmps = new address[](3);
        uint256[] memory tmpAmounts = new uint256[](3);
        tmps[0] = top1;
        tmpAmounts[0] = top1Amount;
        tmps[1] = top2;
        tmpAmounts[1] = top2Amount;
        tmps[2] = top3;
        tmpAmounts[2] = top3Amount;
        return (tmps, tmpAmounts);
    }
}
