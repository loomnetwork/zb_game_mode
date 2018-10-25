const { soliditySha3 } = require('web3-utils')
const { assertEventVar,
    expectThrow,
} = require('./helpers')
const { BigNumber } = web3
const bnChai = require('bn-chai')

require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should()

const ExampleGame = artifacts.require('ExampleGame')
const ZBEnum = artifacts.require('ZBEnum')

contract('ExampleGame', accounts => {
    let exampleGame
    let zenum
    const [ alice, bob, carlos ] = accounts;

    beforeEach(async () => {
        exampleGame = await ExampleGame.new()
        zenum =  await ZBEnum.new()
    });

    it('Should ExampleGame be deployed', async () => {
        exampleGame.address.should.not.be.null
    })
})
