// migrations/MM_upgrade_box_contract.js
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const Contract = artifacts.require('Name');
const ContractV2 = artifacts.require('NameV2');

module.exports = async function (deployer) {
  const existing = await Contract.deployed();
  const instance = await upgradeProxy(existing.address, ContractV2, { deployer });
};
