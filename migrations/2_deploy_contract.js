var Contract = artifacts.require("TestERC20");

module.exports = async function (deployer) {
  await deployer.deploy(Contract, 'Test', 'Test', '10000000000000000000000');
};
