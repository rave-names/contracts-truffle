const SimpleERC20 = artifacts.require('SimpleERC20');

module.exports = async function (deployer) {
  await deployer.deploy(SimpleERC20);
};
