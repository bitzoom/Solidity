// SPDX-License-Identifier: unlicensed

pragma solidity >=0.8.0;

contract VolcanoCoin {
    
    uint maxcoins = 10000;
    address owner;
    
    mapping (address => uint) private balance_list;
    mapping (address => bool) private user_exist;
    
    struct Payment {
        address fromaddr;
        uint amount;
        address toaddr;
    }
    
    Payment[] public paymentList;
    
    mapping (address => Payment[]) private user_pymt_history;

    event MaxCoins_set(uint);
    event TransferCoins(uint, address);
    
    constructor() {
        owner = msg.sender;
        user_exist[msg.sender]=true;
        balance_list[owner] = maxcoins;
    }
    
    modifier onlyOwner {
    if(msg.sender == owner) {
        _; }
    }
    
    modifier onlyUsers {
    if(user_exist[msg.sender]) {
        _; }
    }
    
    modifier enoughBalance (uint _amount) {
    if(balance_list[msg.sender] >= _amount) {
        _; }
    }
     
    function getMaxSupply() public view returns(uint) {
        return maxcoins;
    }
    
    function increaseSupply() public onlyOwner{
        maxcoins = maxcoins + 1000;
        balance_list[owner] += 1000;
        emit MaxCoins_set(maxcoins);
    }
    
    function getUserBalance (address _user) public view onlyUsers returns (uint balance_) {
        return balance_list[_user];
    }

    function transferCoins (address _user, uint _amount) public onlyUsers() enoughBalance(_amount) {
        balance_list[msg.sender] = balance_list[msg.sender] - _amount;
        balance_list[_user] = balance_list[_user] + _amount;
        
        /** update the records if new user that just got given tokens */  
        if(!user_exist[_user]) {
            user_exist[_user] = true;
        }
       
        /* keep track of the transfer */
        Payment memory newTxn;
        newTxn.fromaddr = msg.sender;
        newTxn.amount = _amount;
        newTxn.toaddr = _user;
        paymentList.push(newTxn);
        
        /* update the list of pymts for the user */
        user_pymt_history[msg.sender].push(newTxn);
        
        /* emit an event */
        emit TransferCoins(_amount, _user);
    }
    
    function getPymtHistory (address _user) public view returns (Payment[] memory) {
        return user_pymt_history[_user];
    }
    
}
