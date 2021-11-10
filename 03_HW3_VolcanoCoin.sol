// SPDX-License-Identifier: unlicensed

pragma solidity >=0.8.0;

contract VolcanoCoin {
    
    uint maxcoins = 10000;
    address owner;
    event MaxCoins_set(uint);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
    if(msg.sender == owner) {
        _;
    }
}
    function getmaxsupply() public view returns(uint) {
        return maxcoins;
    }
    
    function increasesupply() public onlyOwner{
        maxcoins = maxcoins + 1000;
        emit MaxCoins_set(maxcoins);
    }
}
