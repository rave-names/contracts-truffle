const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Contract = artifacts.require('Name');

let inputs = [];

module.exports = async function (deployer) {
  const instance = await deployProxy(Contract, inputs, { deployer });
};
