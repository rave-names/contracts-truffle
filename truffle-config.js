/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * trufflesuite.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */
require("dotenv").config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {

  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {

    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.

    development: {
//      provider: function() {
//        return new HDWalletProvider(process.env.MNEMONIC_TEST, `https://localhost:8545`);
//      },
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      gas: 6700000,
    },

    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    // ropsten: {
    // provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/YOUR-PROJECT-ID`),
    // network_id: 3,       // Ropsten's id
    // gas: 5500000,        // Ropsten has a lower block limit than mainnet
    // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    // },

    // Useful for private networks
    // private: {
    // provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
    // network_id: 2111,   // This network is yours, in the cloud.
    // production: true    // Treats this network as if it was a public net. (default: false)
    // }

    // Ethereum
    Ethereum: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 1,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Ethereum, Rinkeby
    Rinkeby: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 4,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Ethereum, Goerli
    Goerli: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 5,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Op on Kovan
    OpTestK:{
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://kovan.optimism.io`);
      },
      network_id: 69,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Op on Goerli
    OpTestG:{
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://optimism-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 1056,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Optimism Main
    Op: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://optimism-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 10,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Binance Test Net
    BNBTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://data-seed-prebsc-1-s1.binance.org:8545/`);
      },
      network_id: 97,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Binance Smart Chain
    BNB: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://bsc-dataseed1.defibit.io/`);
      },
      network_id: 56,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // FTM-test
    FTMTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://rpc.testnet.fantom.network/");
      },
      network_id: 4002,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // FTM-main
    FTM: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://rpcapi.fantom.network/");
      },
      network_id: 250,
      gasPrice: 35000000000, // 35 gwei
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Poly/Matic Test
    MaticTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://polygon-mumbai.infura.io/v3/${process.env.INFURA_API_KEY}`);
        //"https://rpc-mumbai.maticvigil.com/"); - timeout/fail
        //"https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_MUMBAI_KEY}"); - won't connect/fail
        //"https://matic-testnet-archive-rpc.bwarelabs.com"); - timeout/fail
        //"https://matic-mumbai.chainstacklabs.com"); - failed
        //`https://rpc-mumbai.maticvigil.com/v1/${process.env.VIGIL_API_KEY}`); -timeout/fail
      },
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Poly/Matic
    Matic: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
        // "https://polygon-rpc.com/"); - won't test due to mumbai failures
      },
      network_id: 137,
      gasPrice: 375000000000, // 375 gwei
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Avax-Test
    AVAXTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://api.avax-test.network/ext/bc/C/rpc");
      },
      network_id: 43113,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },

    // Avax
    AVAX: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://api.avax.network/ext/bc/C/rpc");
      },
      network_id: 43114,
      confirmations: 5,
      timeoutBlocks: 25,
      skipDryRun: true
    },
  },



  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.8.15",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 10000
        }
      //  evmVersion: "byzantium"
      }
    }
  },

  plugins: [
    'truffle-plugin-verify',
    'truffle-plugin-stdjsonin'
  ],

  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY,
    optimistic_etherscan: process.env.OP_API_KEY,
    //arbiscan: 'MY_API_KEY',
    bscscan: process.env.BSCSCAN_API_KEY,
    snowtrace: process.env.AVAX_API_KEY,
    polygonscan: process.env.POLY_API_KEY,
    ftmscan: process.env.FTM_API_KEY,
    //hecoinfo: 'MY_API_KEY',
    //moonscan: 'MY_API_KEY',
    //bttcscan: 'MY_API_KEY',
    //aurorascan: 'MY_API_KEY',
    //cronoscan: 'MY_API_KEY'
  }

  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  //
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  //
  // After you backed up your artifacts you can utilize db by running migrate as follows:
  // $ truffle migrate --reset --compile-all
  //
  // db: {
    // enabled: false,
    // host: "127.0.0.1",
    // adapter: {
    //   name: "sqlite",
    //   settings: {
    //     directory: ".db"
    //   }
    // }
  // }
};


