var VASSTokenContract = artifacts.require("../contracts/VASSToken.sol");

module.exports = function(deployer) {
  deployer.deploy(VASSTokenContract, 1000000);
};
