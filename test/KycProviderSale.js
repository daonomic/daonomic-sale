var Sale = artifacts.require('KycProviderSaleMock.sol');
var TestKyc = artifacts.require('TestKycProvider.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("KycProviderSale", accounts => {
  let kyc1;
  let kyc2;
  let sale;

  beforeEach(async function() {
    kyc1 = await TestKyc.new(accounts[1], 1, "");
    kyc2 = await TestKyc.new(accounts[2], 1, "");
    sale = await Sale.new(0, bn("10000000000000000000"), 0, [kyc1.address]);
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should let buy if buyer is confirmed by KycProvider", async () => {
    var Purchase = sale.Purchase({});

    await sale.sendTransaction({from: accounts[1], value: 5});
    var purchase = await awaitEvent(Purchase);
    assert.equal(purchase.args.buyer, accounts[1]);
    assert.equal(purchase.args.value, 5);
    assert.equal(purchase.args.sold, 50);
    assert.equal(purchase.args.token, 0);
  });

  it("should not let buy if buyer is not confirmed by KycProvider", async () => {
    await expectThrow(
        sale.sendTransaction({from: accounts[2], value: 5})
    );
  });

  it("should let owner change kyc provider", async () => {
    await sale.setKycProviders([kyc2.address]);
    await sale.sendTransaction({from: accounts[2], value: 5});
    await expectThrow(
        sale.sendTransaction({from: accounts[1], value: 5})
    );
  });

  it("should not let others change kyc provider", async () => {
    await expectThrow(
      sale.setKycProviders([kyc2.address], {from: accounts[1]})
    );
  });
});
