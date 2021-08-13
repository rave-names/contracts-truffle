# Truffle-Enviroment
### Setup by @MaxflowO2
### Requirements
* nodejs and npm
```
apt install nodejs npm -y
```
* npm dependacies
```
npm install --save truffle @truffle/hdwallet-provider truffle-plugin-verify dotenv @openzeppelin/contracts web3
truffle init
```
* setup .env
```
Inside .env

MNEMONIC = "Words"
INFURA_API_KEY =
ETHERSCAN_API_KEY =
BSCSCAN_API_KEY =
```
Contracts need to remain in ./contracts
```truffle deploy --network (network)``` command for deploying contracts
```truffle run verify (Contract name in Solidity) --network (network)`` command for sending verified code to scans site (Binance or Etherium)

Networks configured:
* Developer (127.0.0.1)
* Ethereum
* Rinkeby
* Binance Smart Chain
* Binance Test Net

Boiler plate setup... do not delete Migrations.sol or 1_initial_migration.js

Current as of 13 Aug 2021

Pending updates
* @maxflowo2 npm's for pancakeswap/uniswap (v2/v3) in truffle
