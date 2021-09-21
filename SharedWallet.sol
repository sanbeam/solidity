pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {

    uint public totalBalance;
    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(owner()==msg.sender || allowance[msg.sender] >= _amount, "Transaction Not Allowed.");
        _;
    }

    function reduceAllowance(address _who, uint _amount) public {
        allowance[_who] -= _amount;
    }

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        if(owner()!=msg.sender){
            reduceAllowance(msg.sender, _amount);
        }else{
            require(address(this).balance >= _amount, "Not enough funds");
        }
        _to.transfer(_amount);
    }

    receive() external payable {
    }

}