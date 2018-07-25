var Sale = artifacts.require('WhitelistSaleMock.sol');
var TestWhitelist = artifacts.require('TestWhitelist.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("WhitelistSale", accounts => {
  let whitelist1;
  let whitelist2;
  let sale;

  beforeEach(async function() {
    whitelist1 = await TestWhitelist.new(accounts[1]);
    whitelist2 = await TestWhitelist.new(accounts[2]);
    sale = await Sale.new(0, bn("10000000000000000000"), 0, [whitelist1.address]);
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should let buy if buyer is confirmed by Whitelist", async () => {
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 5});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 5);
    assert.equal(purchase.args.sold, 50);
    assert.equal(purchase.args.token, 0);
  });

  it("should not let buy if buyer is not confirmed by Whitelist", async () => {
    await expectThrow(
        sale.sendTransaction({from: accounts[2], value: 5})
    );
  });

  it("should let owner change whitelist", async () => {
    await sale.setWhitelists([whitelist2.address]);
    await sale.sendTransaction({from: accounts[2], value: 5});
    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 5})
    );
  });

  it("should not let others change whitelist", async () => {
    await expectThrow(
      sale.setWhitelists([whitelist2.address], {from: accounts[1]})
    );
  });
});
