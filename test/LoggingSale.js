var LoggingSale = artifacts.require('LoggingSale.sol');
var PayingToken = artifacts.require('PayingToken.sol');

const tests = require("daonomic-tests");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("LoggingSale", accounts => {
  let sale;

  function bn(value) {
    return new web3.BigNumber(value);
  }

  beforeEach(async function() {
    sale = await LoggingSale.new();
    await sale.setRate(0, bn("10000000000000000000"));
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
    let paying = await PayingToken.new(accounts[2], 1000);
    await sale.setRate(paying.address, bn("100000000000000000000"));

    var Purchase = sale.Purchase({});

    await paying.transferAndCall(sale.address, 100, "", {from: accounts[2]});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[2]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.amount, 10000);
    assert.equal(purchase.args.token, paying.address);
  });

  it("should not accept other tokens", async () => {
    await expectThrow(
      sale.onTokenTransfer(accounts[2], 100, "", {from: accounts[8]})
    );
  });

  it("should withdraw ether", async () => {
    await sale.sendTransaction({from: accounts[1], value: 100});

    var address = randomAddress();
    await sale.withdraw(0, address, 80);
    assert.equal(await web3.eth.getBalance(address), 80);
    assert.equal(await web3.eth.getBalance(sale.address), 20);
  });

  it("should withdraw tokens", async () => {
    let paying = await PayingToken.new(accounts[3], 1000);
    await sale.setRate(paying.address, bn("100000000000000000000"));

    await paying.transferAndCall(sale.address, 100, "", {from: accounts[3]});
    assert.equal(await paying.balanceOf(sale.address), 100)
    await sale.withdraw(paying.address, accounts[1], 30);
    assert.equal(await paying.balanceOf(accounts[1]), 30);
    assert.equal(await paying.balanceOf(sale.address), 70);
  });
});
