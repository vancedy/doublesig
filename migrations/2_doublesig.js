const doublesig = artifacts.require("doublesig");

module.exports = function (deployer) {
  deployer.deploy(doublesig);
};
