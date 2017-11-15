var LoggingSale = artifacts.require('LoggingSaleMock.sol');
const awaitEvent = require("./helpers/awaitEvent.js");
const expectThrow = require("./helpers/expectThrow.js");

contract("LoggingSale", accounts => {
  let sale;

  function bn(value) {
    return new web3.BigNumber(value);
  }

  beforeEach(async function() {
    sale = await LoggingSale.new();
    await sale.setRate(0, bn("10000000000000000000"));
    await sale.setRate(accounts[9], bn("100000000000000000000"));
  });

  it("should log purchases", async () => {
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 100});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.amount, 1000);
    assert.equal(purchase.args.token, 0);
  });

  it("should log purchases in other tokens", async () => {
    var Purchase = sale.Purchase({});

    await sale.onTokenTransfer(accounts[2], 100, "", {from: accounts[9]});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[2]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.amount, 10000);
    assert.equal(purchase.args.token, accounts[9]);
  });

  it("should not accept other tokens", async () => {
    await expectThrow(
      sale.onTokenTransfer(accounts[2], 100, "", {from: accounts[8]})
    );
  });
});