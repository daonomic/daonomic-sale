var LoggingSale = artifacts.require('LoggingSaleMock.sol');
const awaitEvent = require("./helpers/awaitEvent.js");
const expectThrow = require("./helpers/expectThrow.js");

contract("LoggingSale", accounts => {
  let sale;

  beforeEach(async function() {
    sale = await LoggingSale.new();
    await sale.setRate(0, 1);
    await sale.setRate(accounts[9], 10);
  });

  it("should log purchases", async () => {
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 100});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer == accounts[1]);
  });
});