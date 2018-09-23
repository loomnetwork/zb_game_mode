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


// ConquerMode
// Upon entering the Arena, the player will be allowed to select one of three randomly selected classes.
// They can then choose from a series of randomly selected cards to build a new, unique deck.
// Unlike other play modes these cards are not limited by the player's current collection, 
// and there is no limit on the number of each card that can be included in a deck (including legendaries). 
// Players then use their decks to do battle until they have suffered 3 losses, or claimed 12 victories,
// at which point they will be granted a number of rewards depending on their success.
// Winning at least 7 games before being eliminated guarantees that the player will earn their entry fee back in gold. 
// Players do not have to play all of their Arena games in one go, and can return to continue their run whenever they wish.


//TODO Req #0 Track matches, 
//TODO Req #4 Track matches, win 7 matches you get your gold back
//TODO Req #5 12 is max plays
//TODO Req #5 after 3 losses you are out



//TODO Req #1 Allow Payment to play this mode?
//a) use payable method
//b) allow loom store to sign a package verifying payment
//TODO Req #2 pick random card 30 times


const ConquerMode = artifacts.require('ConquerMode')

contract('ConquerMode', accounts => {
    let conquerMode
    const  [ alice, bob, carlos, james, luke ] = accounts;

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


    it('Should ConquerMode payout on 7 wins, and kick you out on 3 loses', async () => {
        await conquerMode.RegisterGame(alice)
        await conquerMode.RegisterGame(bob)
        await conquerMode.RegisterGame(carlos)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 2)

        let aliceWins = await conquerMode.Wins(alice)
        aliceWins.toNumber().should.be.equal(1)
        let aliceLoses = await conquerMode.Loses(alice)
        aliceLoses.toNumber().should.be.equal(1)
        let aliceState = await conquerMode.Status(alice)
        //TODO set initial state
        // aliceState.toNumber().should.be.equal(1) // Playing

        let bobWins = await conquerMode.Wins(bob)
        bobWins.toNumber().should.be.equal(1)
        let bobLoses = await conquerMode.Loses(bob)
        bobLoses.toNumber().should.be.equal(1)
        let bobState = await conquerMode.Status(bob)
        bobLoses.toNumber().should.be.equal(1)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 1)
        //TODO see that Bob transisited out
        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)
        //TODO see that carlos transisited out
        await conquerMode.GameFinished(alice, james, 1)

        aliceWins = await conquerMode.Wins(alice)
        aliceWins.toNumber().should.be.equal(7)
        bobWins = await conquerMode.Wins(bob)
        bobWins.toNumber().should.be.equal(1)
        bobLoses = await conquerMode.Loses(bob)
        bobLoses.toNumber().should.be.equal(3)
        let carlosLoses = await conquerMode.Loses(carlos)
        carlosLoses.toNumber().should.be.equal(3)
        //TODO see that alice gets a payout 

    })

})
