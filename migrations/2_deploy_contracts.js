const ModulumInvestorswhitelist = artifacts.require("./ModulumInvestorswhitelist.sol")
const ModulumTokenICO = artifacts.require("./ModulumTokenICO.sol")
const ModulumTokenHolder = artifacts.require("./ModulumTokenHolder.sol")

module.exports = function(deployer, network, accounts) {
  const startTime = 1511370000 // 1511370000 is Wednesday 22 November 2017 17:00:00 UTC
  const endTime = 1513184400 // 1513184400 is  Wednesday 13 December 2017 17:00:00 UTC
  const rate = new web3.BigNumber(450)  // First rate is 1 ETH = 450 MDL (including 50% bonus)
  const goal = new web3.BigNumber(web3.toWei(7000, 'ether'))  // Soft cap = 7,000 ETH
  const cap =  new web3.BigNumber(web3.toWei(68000, 'ether'))  // Hard cap = 68,000 ETH
  const wallet = accounts[0] //Will be replaced with HTO's wallet on migration

  deployer.deploy(ModulumTokenHolder, wallet, endTime).then(function() {
    return deployer.deploy(ModulumInvestorswhitelist);
  }).then(function() {
    return deployer.deploy(ModulumTokenICO, startTime, endTime, rate, goal, cap, wallet, ModulumTokenHolder.address, ModulumInvestorswhitelist.address);
  });
};