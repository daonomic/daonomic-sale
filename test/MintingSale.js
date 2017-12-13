var MintingSaleMock = artifacts.require('MintingSaleMock.sol');
var MintableToken = artifacts.require('MintableTokenMock.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("MintingSale", accounts => {
  let token;

  beforeEach(async function() {
    token = await MintableToken.new();
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should mint if user sends ether", async () => {
    var sale = await MintingSaleMock.new(token.address, 0, bn("10"), 0);
    await token.transferOwnership(sale.address);

    await sale.sendTransaction({from: accounts[1], value: 5});
    assert.equal(await token.totalSupply(), 50);
    assert.equal(await token.balanceOf(accounts[1]), 50);

    await sale.sendTransaction({from: accounts[2], value: 50});
    assert.equal(await token.totalSupply(), 550);
    assert.equal(await token.balanceOf(accounts[2]), 500);
  });

});
