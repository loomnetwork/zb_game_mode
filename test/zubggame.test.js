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
const ZUBGEnum = artifacts.require('ZUBGEnum')

contract('ExampleGame', accounts => {
    let exampleGame
    let zenum
    const  [ alice, bob, carlos ] = accounts;

    beforeEach(async () => {
        exampleGame = await ExampleGame.new()
        zenum =  await ZUBGEnum.new()
    });

    it('Should ExampleGame be deployed', async () => {
        exampleGame.address.should.not.be.null

        const name = await exampleGame.name.call()
        name.should.be.equal('ExampleGame')
    })


    it('Should Have Enums setup', async () => {
        exampleGame.address.should.not.be.null

        const res = await exampleGame.GameStart.call()
        res.toNumber().should.be.equal(3)
    })

    it('Should Test dynamic arrays', async () => {
        exampleGame.address.should.not.be.null

        const res = await exampleGame.getOdds()
        console.log("res-", res)
        res['0'][0].toNumber().should.be.equal(1)
    })

})
