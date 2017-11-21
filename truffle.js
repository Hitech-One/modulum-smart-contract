var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "/* Private passphrase here */";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 6712390
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io//* Private token here */")
      },
      network_id: 3,
      gas: 4600000
    },
    mainnet: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io//* Private token here */")
      },
      network_id: 1,
      gas: 6712390
    } 
  }
};