// migrations/2_deploy.js
const SimpleToken = artifacts.require('SimpleToken');

module.exports = async function (deployer) {
  await deployer.deploy(SimpleToken, 'SimpleToken', 'SIM', '10000000000000000000000');
};
