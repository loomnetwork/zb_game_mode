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




//TODO Req #1 Allow Payment to play this mode?
//a) use payable method
//b) allow loom store to sign a package verifying payment
//TODO Req #2 pick random card 30 times


const ConquerMode = artifacts.require('ConquerMode')

contract('ConquerMode', accounts => {
    let conquerMode
    const  [ alice, bob, carlos, james, luke, greg ] = accounts;

    beforeEach(async () => {
        conquerMode = await ConquerMode.new()
    });

    it('Should ConquerMode be deployed', async () => {
        conquerMode.address.should.not.be.null

        const name = await conquerMode.name.call()
        name.should.be.equal('ConquerMode')
    })


    it('Should ConquerMode registering should transistion', async () => {
        const tx = await conquerMode.RegisterGame(alice)
//        assertEventVar(tx, 'UserRegisterd', '_from', alice)


        const cnt = await conquerMode.activeUsers()
        cnt.toNumber().should.be.equal(1)

        const name = await conquerMode.userGames.call(alice)
        console.log("result userGames ", name)
        //name.should.be.equal(alice) //should be a UserGame structure

        const name2 = await conquerMode.userAccts.call(0)
        console.log("result userGames ", name2)
        name2.should.be.equal(alice)
    })

    //Req #0 Track matches, 
    //Req #4 Track matches, win 7 matches you get your gold back
    //Req #5 12 is max plays
    //Req #5 after 3 losses you are out
    it('Should ConquerMode payout on 7 wins, and kick you out on 3 loses', async () => {
        await conquerMode.RegisterGame(alice)
        await conquerMode.RegisterGame(bob)
        await conquerMode.RegisterGame(carlos)

        await conquerMode.GameStart(alice, bob)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 2)

        await conquerMode.GameStart(alice, carlos)

        let aliceWins = await conquerMode.Wins(alice)
        aliceWins.toNumber().should.be.equal(1)
        let aliceLoses = await conquerMode.Loses(alice)
        aliceLoses.toNumber().should.be.equal(1)
        let aliceState = await conquerMode.Status(alice)
        aliceState.toNumber().should.be.equal(1) // Playing

        let bobWins = await conquerMode.Wins(bob)
        bobWins.toNumber().should.be.equal(1)
        let bobLoses = await conquerMode.Loses(bob)
        bobLoses.toNumber().should.be.equal(1)
        let bobState = await conquerMode.Status(bob)
        bobLoses.toNumber().should.be.equal(1)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 1)

        //see that Bob is removed from conquer mod
        bobState = await conquerMode.Status(bob)
        bobState.toNumber().should.be.equal(2)

        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)

        //see that Bob is removed from conquer mode
        const tx = await conquerMode.GameFinished(alice, james, 1)

        //see that alice gets her coins back after 7 wins 
        assertEventVar(tx, 'AwardTokens', 'to', alice)
        assertEventVar(tx, 'AwardTokens', 'tokens', 25)

        aliceWins = await conquerMode.Wins(alice)
        aliceWins.toNumber().should.be.equal(7)


        await conquerMode.GameFinished(alice, james, 1)
        await conquerMode.GameFinished(alice, james, 1)

        await conquerMode.GameFinished(alice, greg, 1)
        await conquerMode.GameFinished(alice, greg, 1)
        const tx2 = await conquerMode.GameFinished(alice, greg, 1)

        
        bobWins = await conquerMode.Wins(bob)
        bobWins.toNumber().should.be.equal(1)
        bobLoses = await conquerMode.Loses(bob)
        bobLoses.toNumber().should.be.equal(3)
        let carlosLoses = await conquerMode.Loses(carlos)
        carlosLoses.toNumber().should.be.equal(3)

        //Alice got 12 wins lets make sure she is finished
        aliceWins = await conquerMode.Wins(alice)
        aliceWins.toNumber().should.be.equal(12)
        aliceState = await conquerMode.Status(alice)
        aliceState.toNumber().should.be.equal(2) // Finished

        //see that alice gets a card pack payout 
        assertEventVar(tx2, 'AwardPack', 'to', alice)
        assertEventVar(tx2, 'AwardPack', 'packCount', 1)
        assertEventVar(tx2, 'AwardPack', 'packType', 0)

        //Alice should be finished
        aliceState = await conquerMode.Status(alice)
        aliceState.toNumber().should.be.equal(2)
    })

})
