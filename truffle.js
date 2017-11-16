var ProviderEngine = require("web3-provider-engine");
var WalletSubprovider = require('web3-provider-engine/subproviders/wallet.js');
var Web3Subprovider = require("web3-provider-engine/subproviders/web3.js");
var Web3 = require("web3");
var FilterSubprovider = require('web3-provider-engine/subproviders/filters.js')

function createEngine(url) {
    var engine = new ProviderEngine();
    engine.addProvider(new WalletSubprovider(wallet, {}));
    engine.addProvider(new FilterSubprovider());
    engine.addProvider(new Web3Subprovider(new Web3.providers.HttpProvider(url)));
    engine.on('error', function(err) {
        console.error(err.stack)
    });
    return engine;
}

var ropsten = createEngine("http://node-ropsten:8545");
var main = createEngine("http://node-main:8545");

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            gas: 4500000,
            network_id: "*"
        },
        ropsten: {
            network_id: 3,
        //            provider: engine,
        //            from: address,
            gas: 4500000,
            gasPrice: 100000000000
        }

    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
