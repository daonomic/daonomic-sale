var LoggingSale = artifacts.require('OneRateLoggingSale.sol');
var PayingToken = artifacts.require('PayingToken.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("LoggingSale", accounts => {
  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should log purchases", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 100});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.sold, 1000);
    assert.equal(purchase.args.token, 0);
  });

  it("should sell to provided beneficiary", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    var Purchase = sale.Purchase({});

	var beneficiary = randomAddress();
    await sale.receiveWithData(beneficiary, {from: accounts[0], value: 100});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, beneficiary);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.sold, 1000);
    assert.equal(purchase.args.token, 0);
  });

  it("should log purchases in other tokens", async () => {
    var paying = await PayingToken.new(accounts[2], 1000);
    var sale = await LoggingSale.new(paying.address, bn("100000000000000000000"), 0);

    var Purchase = sale.Purchase({});

    await paying.transferAndCall(sale.address, 100, "", {from: accounts[2]});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[2]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.sold, 10000);
    assert.equal(purchase.args.token, paying.address);
  });

  it("should not accept other tokens", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    await expectThrow(
      sale.onTokenTransfer(accounts[2], 100, "", {from: accounts[8]})
    );
  });

  it("should withdraw ether", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    await sale.sendTransaction({from: accounts[1], value: 100});

    var address = randomAddress();
    await sale.withdraw(0, address, 80);
    assert.equal(await web3.eth.getBalance(address), 80);
    assert.equal(await web3.eth.getBalance(sale.address), 20);
  });

  it("should withdraw tokens", async () => {
    var paying = await PayingToken.new(accounts[3], 1000);
    var sale = await LoggingSale.new(paying.address, bn("100000000000000000000"), 0);

    await paying.transferAndCall(sale.address, 100, "", {from: accounts[3]});
    assert.equal(await paying.balanceOf(sale.address), 100)
    await sale.withdraw(paying.address, accounts[1], 30);
    assert.equal(await paying.balanceOf(accounts[1]), 30);
    assert.equal(await paying.balanceOf(sale.address), 70);
  });
});
