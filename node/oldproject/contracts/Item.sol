//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.21 <0.7.0;
import "./ItemManager.sol";

contract Item {

    uint public priceinWei;
    uint public index;
    uint public pricePaid;
    ItemManager parentContract;
    
    event DebugEvent(address who, uint data);

    constructor(ItemManager _parentContract, uint _index,  uint _priceinWei)  public {
        priceinWei =  _priceinWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Already paid for");
        require(priceinWei == msg.value, "Only full payment accepted");
        (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transaction failed. Cancelling");
        pricePaid += msg.value;
    }

    fallback() external payable{

    }

}

