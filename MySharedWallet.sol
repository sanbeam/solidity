pragma solidity 0.8.1;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/access/Ownable.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/math/SafeMath.sol";

contract Allowance is Ownable {
    
    using SafeMath for uint;
    
    mapping (address => uint) public allowance;
    
    event AllowanceChanged(address indexed from, address indexed _who, uint oldamt, uint newamt);

    modifier onlyOwnerOrValid(uint _amount) {
        require(owner()==msg.sender || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }
    
    function addAllowance(address _who, uint _howmuch) public onlyOwnerOrValid(_howmuch){
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _howmuch);
        allowance[_who] = _howmuch;
    }

    function delAllowance(address _who, uint _howmuch) internal{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_howmuch));
        allowance[_who] = allowance[_who].sub(_howmuch);
    }
}

contract SharedWallet is Allowance {
    
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner{
        require(_amount <= address(this).balance, "Not enough balance");
        if(owner() == msg.sender){
            delAllowance(_to, _amount);
        }
        _to.transfer(_amount);
    }
    
    fallback() external payable {
        
    }
    
    receive() external payable {

    }
}