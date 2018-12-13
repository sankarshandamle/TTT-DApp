var Payback = artifacts.require("./payback.sol");

module.exports = function(deployer) {
  deployer.deploy(Payback);
};
