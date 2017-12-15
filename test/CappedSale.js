var CappedSale = artifacts.require('CappedSaleMock.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("CappedSale", accounts => {
  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should let buy if cap not reached", async () => {
    var sale = await CappedSale.new(100, 0, bn("10000000000000000000"), 0);
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 5});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 5);
    assert.equal(purchase.args.amount, 50);
    assert.equal(purchase.args.token, 0);
  });

  it("should throw if cap reached", async () => {
    var sale = await CappedSale.new(100, 0, bn("10000000000000000000"), 0);

    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 11})
    );
    await sale.sendTransaction({from: accounts[1], value: 5});
    await sale.sendTransaction({from: accounts[1], value: 5});
    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 1})
    );
  });

  it("should not take bonus into account", async () => {
    var sale = await CappedSale.new(100, 0, bn("10000000000000000000"), 100);
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 10});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 10);
    assert.equal(purchase.args.amount, 200);
    assert.equal(purchase.args.beforeBonus, 100);
    assert.equal(purchase.args.token, 0);
    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 1})
    );
  });

});
