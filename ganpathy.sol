pragma solidity ^0.8.0;

contract Ganpathy {
    string public hiGanpathy = "Hello Ganpathy";
    uint256 public someInt;
    
    bool  public boolTest;
    uint8 public some8Int;
    
    address public myAddress;
    
    function myFirstFunc(uint _someInt) public {
        someInt = _someInt;
    }
    

    function incrementInt() public {
        some8Int++;
    }

    function decrementInt() public {
        some8Int--;
    }
    
    function setAddress(address _myAddress) public {
        myAddress = _myAddress;
    }

    function getBalance() public view returns(uint) {
        return myAddress.balance;
    }
}