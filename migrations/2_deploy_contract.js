var HelloWorld = artifacts.require("HelloWorld");
module.exports = function(deployer) {
  deployer.deploy(HelloWorld, "Hallo");
  // add contracts to deploy here
};
