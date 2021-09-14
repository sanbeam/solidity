pragma solidity ^0.8.0;

contract Ganpathy {
    string public hiGanpathy = "Hello Ganpathy";

    uint256 public myUint ;
    
    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }

    bool public myBool ;
    
    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }

    uint8 public myUint8 ;
    
    function increment() public {
        myUint8++;
    }
    function decrement() public {
        myUint8--;
    }

    address public myAddress ;
    
    function setMyAddress(address _myAddress) public {
        myAddress = _myAddress;
    }

    function getBalanceOfAddress() public view returns(uint){
        return myAddress.balance;
    }



}