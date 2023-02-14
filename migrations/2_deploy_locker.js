const Contract = artifacts.require("RaveLPLock");

module.exports = async function(deployer) {
  await deployer.deploy(Contract, '0xe117a5f40a5d28d3b2f103301c629617bfba5f61', '0x845b22ce834b100fc2ed4339375505c9715331fc');
}
