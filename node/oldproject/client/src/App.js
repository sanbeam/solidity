import React, { Component } from "react";
import ItemManagerContract from "./contracts/ItemManager.json";
import ItemContract from "./contracts/Item.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false, cost: 0, itemName: "example" };

  componentDidMount = async () => {
    try {
      this.web3 = await getWeb3();
      this.accounts = await this.web3.eth.getAccounts();
      this.networkId = await this.web3.eth.net.getId();

      console.log(this.accounts);

      this.itemManager = new this.web3.eth.Contract(
        ItemManagerContract.abi,
        ItemManagerContract.networks[this.networkId] && ItemManagerContract.networks[this.networkId].address,
      );

      this.item = new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] && ItemContract.networks[this.networkId].address,
      );


      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.listenToPayments();
      this.setState({ loaded: true });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  listenToPayments = () => {
    let self = this;
    this.itemManager.events.SupplyChainStep().on("data", async function(evt){
      console.log("Async Event Alert");
      console.log(evt);
      let itemObj = self.itemManager.methods.items(evt.returnValues._itemIndex).call();
      console.log(itemObj);
    });
  }
handleSubmit = async () => {
    const { cost, itemName } = this.state;
    console.log(itemName, cost, this.itemManager);
    let result = await this.itemManager.methods.createItem(itemName, cost).send({
      from:this.accounts[0]
    });
    console.log(result);
    alert("Send " + cost + " Wei to " + result.events.SupplyChainStep.returnValues._itemAddress);
  };

  handleInputChange = (event) => {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;
    this.setState({
      [name]: value
    });
  }

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">

        <h1>Event trigger / Add Item</h1>
        <h2>Items</h2>
        <h2>Add Item</h2>
        Cost in Wei : <input type="text" name="cost" value={this.state.cost} onChange={this.handleInputChange} />
        Item Name : <input type="text" name="itemName" value={this.state.name} onChange={this.handleInputChange} />
        <button type="button" onClick={this.handleSubmit}>Add New Item</button>
      </div>
    );
  }
}

export default App;
