let Web3 = require("web3");

let w3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"));

let p1 = w3.eth.getBalance("0x467B9F96947712071A1866dc4065dBf891114418");
p1.then(function(result) {
    console.log(result);
    console.log(w3.utils.fromWei(result, "ether"));
});


let p2 = w3.eth.sendTransaction({
    "from" : "0x467B9F96947712071A1866dc4065dBf891114418",
    "to" : "0xdA7f7F2b6f568E56C0C5f4dBa80f973aC1e824f5",
    "value" : 1000000000000000000
});
p2.then(function(result) {
    //console.log(result);
});

