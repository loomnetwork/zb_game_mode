const ExampleGame = artifacts.require('./ExampleGame.sol')

//This is only for an example
//likely you should just import this game mode into your app
module.exports = (deployer) => {
  deployer.deploy(ExampleGame)
};
