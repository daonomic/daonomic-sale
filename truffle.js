function createNetwork(name) {
  var os = require('os');
  var json = require(os.homedir() + "/.ethereum/" + name + ".json");
  var gasPrice = json.gasPrice != null ? json.gasPrice : 2000000000;

  return {
    provider: () => createProvider(json.key, json.url),
    from: json.address,
    gas: 800000,
    gasPrice: gasPrice,
    network_id: json.network_id
  };
}

function createProvider(key, url) {
  var ProviderEngine = require("web3-provider-engine");
  var WalletSubprovider = require('web3-provider-engine/subproviders/wallet.js');
  var Web3Subprovider = require("web3-provider-engine/subproviders/web3.js");
  var Web3 = require("web3");
  var FilterSubprovider = require('web3-provider-engine/subproviders/filters.js')
  var Wallet = require("ethereumjs-wallet");

  function createEngine(url, wallet) {
    var engine = new ProviderEngine();
    engine.addProvider(new WalletSubprovider(wallet, {}));
    engine.addProvider(new FilterSubprovider());
    engine.addProvider(new Web3Subprovider(new Web3.providers.HttpProvider(url)));
    engine.on('error', function(err) {
        console.error(err.stack)
    });
    return engine;
  }

  var wallet = Wallet.fromPrivateKey(new Buffer(key, "hex"));
  var engine = createEngine(url, wallet);
  engine.start();
  return engine;
}

module.exports = {
  networks: {
    ropsten: createNetwork("ropsten"),
    mainnet: createNetwork("mainnet")
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
