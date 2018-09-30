const AccessToken = '28e47f6bef95469aaa9713845c8726e2';

var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "Blockchain Voting";

module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+AccessToken)
      },
      network_id: 3
    }   
  }
};

