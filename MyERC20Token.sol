// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 
contract MyERC20Token {
    // 合约owner可以增发token;
    address public owner;
    uint256 public total = 0; // 此处public为了方便查看 100000000000000000000
    mapping (address => uint256) private balances; // 记录所有token的账户
    // token持有者可以把自己的token授权给某个人使用 
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    mapping(address account => mapping(address spender => uint256)) public _allowances;

    string public tokenName;
    string public tokenSymbol;

    event Transfer(address from, address to, uint amount); // 每笔交易给谁了
    event Approve(address from, address user, uint amount); // 授权记录

    error ERC20InvalidSender(address sender); // 抄的
    error ERC20InvalidReceiver(address receiver);

    constructor(string memory name, string memory symbol) {
        tokenName = name;
        tokenSymbol = symbol;
        owner = msg.sender; // 此处的sender是合约部署者
    }

    modifier onlyOwner {
        require(owner == msg.sender,"not the owner");
        _;
    }
    // 当前合约owner可以把权限给其他人
    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    // owner可以增发代币
    function mint(uint256 value) external onlyOwner returns (bool) {
        initTotal(value);
        return true;
    }
    
    // 更新合约中总金额
    function initTotal(uint256 value) private {
        total = value;
    }

    // owner可以控制合约token
    function updateTotal(address to, uint256 amount) private onlyOwner {
        total -= amount;
        balances[to] += amount;
    }

    /*
    查询余额
    */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // 转账者msg.sender, 把多少钱value, 转给谁to
    function transfer(address to, uint amount) public returns(bool) {
        address from = msg.sender;
        _transfer(from, to, amount);

        return true;
    }
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);

    }

    // 更新某个账户的金额
    function _update(address from, address to, uint256 value) private {
        // 1, 如果from是owner
        // 2, 如果to是owner
        if(from == owner) {
            total -= value;
        } else {
            require(balances[from]> 0 && value>0 && value < balances[from], "Check if the account balance has a token and cannot be less than the transfer amount");
            balances[from] -= value;
        }

        if(to == owner) {
            total += value;
        } else {
            balances[to] += value;
        }

        emit Transfer(from,to,value);
    }


    // 授权
    function approve(address spender, uint256 value) public returns (bool) {
        address _owner = msg.sender;
        _approve(_owner, spender, value);
        return true;
    }

    function _approve(address _owner, address spender, uint256 value) private  {
        _allowances[_owner][spender] = value;
    }



    /* 
    * 代扣转账 
    * _owner token 拥有者
    * msg.sender(spender) 当前转账者(被授权人)
    * to 转给谁
    * value 转账金额
    */

    function transferFrom(address _owner, address to, uint256 value) public returns (bool){
        require(value>0);
        // _owner 账户所有者
        // 当前操作人
        address spender = msg.sender;
        
        require(_allowances[_owner][spender] > value); // 授权不能为零

        // 更新_owner的余额
        _allowances[_owner][spender] -= value;
        _approve(_owner, spender, _allowances[_owner][spender] - value);
        // 更新可以操作的余额
        if(value <= balances[_owner]) {
            _update(_owner, to, value);
            return true;
        }
        return false;
    }
}