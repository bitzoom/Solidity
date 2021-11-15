// SPDX-License-Identifier: unlicensed

pragma solidity >=0.8.0;

contract VolcanoCoin {
    
    uint maxcoins = 10000;
    address owner;
    event MaxCoins_set(uint);
    event TransferCoins(uint, address);
    mapping (address => uint) public balance_list;
    struct Payment {
        address addr;
        uint amount;
    }
    Payment public payment_list;

    constructor() {
        owner = msg.sender;
        balance_list[owner] = maxcoins;
    }
    
    modifier onlyOwner {
    if(msg.sender == owner) {
        _; }
    }
    
    function getMaxSupply() public view returns(uint) {
        return maxcoins;
    }
    
    function increaseSupply() public onlyOwner{
        maxcoins = maxcoins + 1000;
        emit MaxCoins_set(maxcoins);
    }
    
    function getUserBalance (address _user) public view returns (uint) {
        return balance_list[_user];
    }

    function transferCoins (address _user, uint _amount) public {
        balance_list[_user] = balance_list[_user] + _amount;
        balance_list[msg.sender] = balance_list[msg.sender] - _amount;
        payment_list.addr = msg.sender;
        payment_list.amount = _amount;
        emit TransferCoins(_amount, _user);
    }
    
}
