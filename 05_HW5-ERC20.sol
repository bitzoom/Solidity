
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is ERC20, Ownable {

    struct Payment{
    uint amount;
    address recipient;
    }

    mapping(address => Payment[]) public PaymentList;
    
    constructor(uint256 initialSupply) ERC20("VolcanoCoin", "VCOIN") {
        _mint(msg.sender, initialSupply);
    }

    function mintToOwner(uint256 amount) public onlyOwner returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        PaymentList[msg.sender].push(Payment(amount,recipient));
        return true;
    }   

    function getPaymentHistory(address _user) public view returns (Payment[] memory) {
        return PaymentList[_user];
    }
}


