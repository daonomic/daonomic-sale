var Sale = artifacts.require('WhitelistSaleMock.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("WhitelistSale", accounts => {
  let sale;

  beforeEach(async function() {
    sale = await Sale.new(0, bn("10000000000000000000"), 0);
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should let owner change roles", async () => {
     await sale.transferRole("operator", accounts[1]);
     await expectThrow(
        sale.transferRole("operator", accounts[2], {from: accounts[1]})
     );
  });

  it("should let operator change whitelist", async () => {
     await sale.transferRole("operator", accounts[1]);
     var address = randomAddress();
     await sale.setWhitelist(address, true, {from: accounts[1]});
     assert.equal(await sale.canBuy(address), true);
     assert.equal(await sale.canBuy(randomAddress()), false);
  });

  it("should let owner add some addresses to whitelist", async () => {
     var address1 = randomAddress();
     var address2 = randomAddress();
     var address3 = randomAddress();
     await sale.addToWhitelist([address1, address2, address3]);
     assert.equal(await sale.isInWhitelist(address1), true);
     assert.equal(await sale.isInWhitelist(address2), true);
     assert.equal(await sale.isInWhitelist(address3), true);
     assert.equal(await sale.isInWhitelist(randomAddress()), false);
  });

  it("should not let others add some addresses to whitelist", async () => {
     var address1 = randomAddress();
     var address2 = randomAddress();
     var address3 = randomAddress();
     await expectThrow(
        sale.addToWhitelist([address1, address2, address3], {from: accounts[1]})
     );
  });

  it("should not let others change whitelist", async () => {
     await sale.transferRole("operator", accounts[1]);
     await sale.setWhitelist(randomAddress(), true, {from: accounts[0]});
     await expectThrow(
        sale.setWhitelist(randomAddress(), true, {from: accounts[2]})
     );
  });

  it("should let buy if buyer address whitelisted", async () => {
    await sale.transferRole("operator", accounts[1]);
    await sale.setWhitelist(accounts[2], true, {from: accounts[1]});
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[2], value: 5});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[2]);
    assert.equal(purchase.args.value, 5);
    assert.equal(purchase.args.sold, 50);
    assert.equal(purchase.args.token, 0);

    await expectThrow(
        sale.sendTransaction({from: accounts[3], value: 5})
    );
  });

  it("should not let buy if not whitelisted", async () => {
    await sale.transferRole("operator", accounts[1]);
    await sale.setWhitelist(accounts[1], true, {from: accounts[1]});
    await sale.setWhitelist(accounts[1], false, {from: accounts[1]});
    var Purchase = sale.Purchase({});

    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 5})
    );
  });

});
