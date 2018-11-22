var MintingSaleMock = artifacts.require('MintingSaleMock.sol');
var MintableToken = artifacts.require('MintableTokenMock.sol');
var KyberNetworkWrapper = artifacts.require('KyberNetworkWrapper.sol');
var TestKyberNetwork = artifacts.require('TestKyberNetwork.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("KyberNetworkWrapper", accounts => {
  let token;
  let kyberToken;

  beforeEach(async function() {
    token = await MintableToken.new();
    kyberToken = await MintableToken.new();
    kyberToken.mint(accounts[1], 1000);
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should transfer ether on behalf of the user", async () => {
    var sale = await MintingSaleMock.new(token.address, 0, bn("10000000000000000000"), 0);
    await token.transferRole("minter", sale.address);

    var kyber = await TestKyberNetwork.new();
    await kyber.sendTransaction({from: accounts[5], value: 100000});

    var wrapper = await KyberNetworkWrapper.new();
    await kyberToken.approve(wrapper.address, 400, {from: accounts[1]});

    await wrapper.tradeAndBuy(kyber.address, sale.address, kyberToken.address, 400, 0, 0, "0x0000000000000000000000000000000000000000", {from: accounts[1]});

    assert.equal(await token.totalSupply(), 10000);
    assert.equal(await token.balanceOf(accounts[1]), 10000);
    assert.equal(await kyberToken.balanceOf(accounts[1]), 700);
    assert.equal(await kyberToken.balanceOf(wrapper.address), 300);
    assert.equal(await kyberToken.allowance(wrapper.address, kyber.address), 300);
  });

  it("should return eth price", async () => {
    var sale = await MintingSaleMock.new(token.address, 0, bn("10000000000000000000"), 0);
    await token.transferRole("minter", sale.address);

    var kyber = await TestKyberNetwork.new();
    await kyber.sendTransaction({from: accounts[5], value: 100000});

    var wrapper = await KyberNetworkWrapper.new();
    await kyberToken.approve(wrapper.address, 300, {from: accounts[1]});

    var price = await wrapper.getETHPrice(sale.address);
    assert.equal(price, 100000000000000000);
  });

});
