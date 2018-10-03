var LoggingSale = artifacts.require('OneRateLoggingSale.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const btcTokenAddress = "0x0000000000000000000000000000000000000001";

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
    await sale.buyTokens(beneficiary, {from: accounts[0], value: 100});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, beneficiary);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.sold, 1000);
    assert.equal(purchase.args.token, 0);
  });

  it("should log purchases in other tokens", async () => {
    var sale = await LoggingSale.new(btcTokenAddress, bn("100000000000000000000"), 0);
    await sale.transferRole("operator", accounts[1]);

    var Purchase = sale.Purchase({});

    await sale.onReceive(accounts[2], btcTokenAddress, 100, "0xaabbcc", {from: accounts[1]});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[2]);
    assert.equal(purchase.args.value, 100);
    assert.equal(purchase.args.sold, 10000);
    assert.equal(purchase.args.token, btcTokenAddress);
    assert.equal(purchase.args.txId, "0xaabbcc");
  });

  it("should not accept other tokens", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    await sale.transferRole("operator", accounts[1]);

    await expectThrow(
      sale.onReceive(accounts[2], btcTokenAddress, 100, "0xaabbcc", {from: accounts[1]})
    );
  });

  it("should withdraw ether", async () => {
    var sale = await LoggingSale.new(0, bn("10000000000000000000"), 0);
    await sale.sendTransaction({from: accounts[1], value: 100});

    var address = randomAddress();
    await sale.withdrawEth(address, 80);
    assert.equal(await web3.eth.getBalance(address), 80);
    assert.equal(await web3.eth.getBalance(sale.address), 20);
  });
});

