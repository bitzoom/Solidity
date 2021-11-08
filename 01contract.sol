// SPDX-License-Identifier: unlicensed

pragma solidity >=0.8.0;


contract Score {

uint score;
address owner;

constructor () {
    owner = msg.sender;
}

modifier onlyOwner {
    if(msg.sender == owner) {
        _;
    }
}

function setscore(uint _newscore) public onlyOwner{
    score = _newscore;
} 

function getscore() public view returns(uint) {
        return score;
}

}


