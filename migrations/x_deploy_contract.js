const Contract = artifacts.require("Name");

module.exports = async function(deployer) {
  await deployer.deploy(Contract);
}
