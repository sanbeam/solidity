pragma solidity ^0.8.4;


contract SendMoneyNew {
    
    struct Payment {
        uint amount;
        uint timestamp;
    }
    
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balanceReceived;
    
    
    address payable owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function destroyContract() public{
        require(owner==payable(msg.sender), "You are not the owner");
        selfdestruct(owner);
    }
    
    function getOwner() view public returns(address) {
        return owner;
    }

    function convertWeiToEther(uint _amountInWei) pure public returns(uint) {
        return _amountInWei/1 ether;
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function receiveMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Payment memory payment = Payment(msg.value, block.timestamp);
        
        uint index = balanceReceived[msg.sender].numPayments;
        
        balanceReceived[msg.sender].payments[index] = payment;
        balanceReceived[msg.sender].numPayments++;
    }

    function wdMoneyToAddress(address payable _to, uint _amount) public {
        require(balanceReceived[msg.sender].totalBalance >= _amount, "Not enough funds");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
    
    function wdAllMoney(address payable _to) public {
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
    
    fallback() external payable {
        require(msg.data.length == 0, "Invalid transaction");
        receiveMoney();
    }
    
    receive() external payable {
        receiveMoney();
    }    
}