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

    // Infura Endpoints (requires INFURA_API_KEY in .env)

    // Ethereum
    ETH: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 1,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Ethereum Testnet, Goerli
    ETHTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 5,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Optimism Main
    OP: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://optimism-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 10,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Op Test on Goerli
    OPTest:{
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://optimism-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 1056,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Arb Main
    ARB: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://arbitrum-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 42161,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Arb Test on Goerli
    ARBTest:{
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://arbitrum-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 421613,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Poly/Matic
    Matic: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 137,
      gasPrice: 375000000000, // 375 gwei
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Poly/Matic Test (mumbai)
    MaticTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://polygon-mumbai.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Celo
    Celo: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://celo-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 42220,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Celo Test (alfajores)
    CeloTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://celo-alfajores.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 44787,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Palm
    Palm: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://palm-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 11297108109,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Palm Test ()
    PalmTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://palm-testnet.infura.io/v3/${process.env.INFURA_API_KEY}`);
      },
      network_id: 11297108099,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Network hosted RPC's

    // Avax
    AVAX: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://api.avax.network/ext/bc/C/rpc");
      },
      network_id: 43114,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Avax-Test
    AVAXTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://api.avax-test.network/ext/bc/C/rpc");
      },
      network_id: 43113,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Cronos
    CRO: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://evm.cronos.org/");
      },
      network_id: 25,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Cronos Testnet
    CROTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://evm-t3.cronos.org");
      },
      network_id: 338,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // ANKR RPC's (defaults kind of blow)

    // BSC
    BSC: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://rpc.ankr.com/bsc`);
      },
      network_id: 56,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // BSC Testnet (Chapel)
    BSCTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://rpc.ankr.com/bsc_testnet_chapel`);
      },
      network_id: 97,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // BTT
    BTT: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, `https://rpc.ankr.com/bttc`);
      },
      network_id: 199,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // BTT Testnet (no testnet found but got chain ID)
    BTTTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, ``);
      },
      network_id: 1028,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // FTM
    FTM: {
      provider: function() {
        return new HDWalletProvider('1b5ba463e56c41d100c0e7695013c33a4ade5dcb18e41f3fefe6d2c16c5af64c', "https://rpc.ankr.com/fantom");
      },
      network_id: 250,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // FTM testnet
    FTMTest: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://rpc.ankr.com/fantom_testnet");
      },
      network_id: 4002,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Moonbeam https://rpc.ankr.com/moonbeam
    Moonbeam: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://rpc.ankr.com/moonbeam");
      },
      network_id: 1284,
      confirmations: 2,
      timeoutBlocks: 200,
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
    'truffle-plugin-stdjsonin',
  ],

  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY,
    optimistic_etherscan: process.env.OP_API_KEY,
    arbiscan: process.env.ARB_API_KEY,
    bscscan: process.env.BSCSCAN_API_KEY,
    snowtrace: process.env.AVAX_API_KEY,
    polygonscan: process.env.POLY_API_KEY,
    ftmscan: 'SVXH9NKYC61V2CHGDAGMANWWQU53V2MWUG',
    //hecoinfo: 'MY_API_KEY',
    moonscan: process.env.MOON_API_KEY,
    bttcscan: process.env.BTT_API_KEY,
    //aurorascan: 'MY_API_KEY',
    cronoscan: process.env.CRONOS_API_KEY,
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

