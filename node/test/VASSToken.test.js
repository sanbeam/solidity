const VASSToken = artifacts.require("./VASSToken.sol");

var chai = require("chai");
const BN = web3.utils.BN;

const chaiBN = require("chai-bn")(BN);
chai.use(chaiBN);

var chaiAsPromised = require("chai-as-promised");
const { send } = require("process");
chai.use(chaiAsPromised);

const expect = chai.expect;

contract("VASSToken Test", async (accounts) => {

    const [deployerAccount, recipient, anotherAccount] = accounts;

  it("all tokens should be in my account", async () => {
      let instance = await VASSToken.deployed();
      let totalSupply =  await instance.totalSupply();
    //   let balance = await instance.balanceOf(accounts[0]);
      expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply);
  })

  it("is possible to send tokens between accounts", async () => {
      let sendTokens = 1;
      let instance = await VASSToken.deployed();
      let totalSupply =  await instance.totalSupply();
      expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply);
      expect(instance.transfer(recipient, sendTokens)).to.eventually.be.fulfilled;
      expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply.sub(new BN(sendTokens)));
      expect(instance.balanceOf(recipient)).to.eventually.be.a.bignumber.equal(new BN(sendTokens));
  })

  it("is not possible to send more tokens than available", async () => {
    let instance = await VASSToken.deployed();
    let balanceOfDeployer = await instance.balanceOf(deployerAccount);
    expect(instance.transfer(recipient, new BN(balanceOfDeployer + 1))).to.eventually.be.fulfilled;
    expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(balanceOfDeployer);
})



});
