pragma solidity ^0.8.4;

// This is the Smart Contract
contract SendMoneyExample {

    //this is the money inside the contract
    uint public received;
    
    address owner;

    uint public lockedUntil;

    mapping(address => uint) public balanceReceived;
    
    constructor() {
        owner = msg.sender;
    }
    
    //this function withdraws money from the contract
    //sends the money to the account.
    function withdrawAllMoney() public  {
        // if(lockedUntil < block.timestamp) {
            address payable to = payable(msg.sender);
            //this is the problem
            //we transfer to the default account
            to.transfer(this.getBalance());
        // }
    }


    //this function withdraws money from the contract - to a specific account
    //sends the money to THAT account.
    function withdrawMoneyTo(address payable _to) public  {
        // if(lockedUntil < block.timestamp) {
        require(msg.sender == owner, "You are not the owner");
        _to.transfer(this.getBalance());
        // }
    }

    //this function receives money from the account
    //bring the money into the contract
    function receiveMoney() public payable {
        received += msg.value;
        lockedUntil = block.timestamp + 1 minutes;
    }
    
    //returns the pending money in the account
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

