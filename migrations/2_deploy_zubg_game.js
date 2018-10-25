const ExampleGame = artifacts.require('./ExampleGame.sol')
const ChangeCardsTestGame = artifacts.require('./ChangeCardsTestGame.sol')

//This is only for an example
//likely you should just import this game mode into your app
module.exports = (deployer) => {
  deployer.deploy(ExampleGame)
  deployer.deploy(ChangeCardsTestGame)
};
