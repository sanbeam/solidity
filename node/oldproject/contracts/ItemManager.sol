//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.21 <0.7.0;

import "./Ownable.sol";
import "./Item.sol";


contract ItemManager is Ownable{

    enum SupplyChainSteps{Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        uint _priceInWei;
    }
    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner{

        Item item = new Item(this, itemIndex, _priceInWei);
        items[itemIndex]._item = item;
        items[itemIndex]._priceInWei = _priceInWei;
        items[itemIndex]._step = SupplyChainSteps.Created;
        items[itemIndex]._identifier = _identifier;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._step), address(items[itemIndex]._item));
        itemIndex++;
    }

    function triggerPayment(uint _index) public payable {
        require(items[_index]._priceInWei <= msg.value, "Not fully paid");
        require(items[_index]._step == SupplyChainSteps.Created, "Item is further in the supply chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step), address(items[_index]._item));
    }

    function triggerDelivery(uint _index) public onlyOwner{
        require(items[_index]._step == SupplyChainSteps.Paid, "Item is further in the supply chain");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step), address(items[_index]._item));
    }
}