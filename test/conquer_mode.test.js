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



const ConquerMode = artifacts.require('ConquerMode')

// Disable ConqueMode tests for now
return;
contract('ConquerMode', accounts => {
    let conquerMode
    const  [ loomMarketPlace1, loomMarketPlace2, loomMarketPlace3, alice, bob, carlos, james, luke, greg ] = accounts;

    beforeEach(async () => {
        conquerMode = await ConquerMode.new()
    });

    it('Should ConquerMode be deployed', async () => {
        conquerMode.address.should.not.be.null

        const name = await conquerMode.name.call()
        name.should.be.equal('ConquerMode')
    })


    it('Should ConquerMode registering should transistion', async () => {
        const tx = await conquerMode.RegisterGame(alice,1,1,[],[],[])
//        assertEventVar(tx, 'UserRegisterd', '_from', alice)
        await conquerMode.GameStart(alice, bob)


        const cnt = await conquerMode.activeUsers()
        cnt.toNumber().should.be.equal(1)

        const aliceGame = await conquerMode.userGames.call(alice)
        console.log("result userGames ", aliceGame)
        aliceGame.status.toNumber().should.be.equal(1) //should be a UserGame structure

        const name2 = await conquerMode.userAccts.call(0)
        console.log("result userAcct ", name2)
        name2.should.be.equal(alice)
    })


    function registerGameWithSign(){

    }

    //Req #0 Track matches,
    //Req #4 Track matches, win 7 matches you get your gold back
    //Req #5 12 is max plays
    //Req #5 after 3 losses you are out
    it('Should ConquerMode payout on 7 wins, and kick you out on 3 loses', async () => {
        const signers = accounts.slice(0, 3)
        signers.sort()


        gameId = 1;

        ticketId = 123;

        //TODO need to verify this is the correct hash parameters
        const hash = soliditySha3("ticket", ticketId, gameId);

        const sigV = []
        const sigR = []
        const sigS = []

        for (let i = 0; i < signers.length; i++) {
            const sig = (await web3.eth.sign(hash, signers[i])).slice(2)
            const r = '0x' + sig.substring(0, 64)
            const s = '0x' + sig.substring(64, 128)
            const v = parseInt(sig.substring(128, 130), 16) + 27
            sigV.push(v)
            sigR.push(r)
            sigS.push(s)
        }
        await conquerMode.RegisterGame(alice, ticketId, gameId, sigV, sigR, sigS)

        //TODO we shouldnt be able to reuse a ticket across multiple users
        await conquerMode.RegisterGame(bob, ticketId, gameId, sigV, sigR, sigS)
        await conquerMode.RegisterGame(carlos, ticketId, gameId, sigV, sigR, sigS)

        await conquerMode.GameStart(alice, bob)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 2)

        await conquerMode.GameStart(alice, carlos)


        let aliceGame = await conquerMode.userGames.call(alice)

        aliceGame.wins.toNumber().should.be.equal(1)
        aliceGame.loses.toNumber().should.be.equal(1)
        aliceGame.status.toNumber().should.be.equal(1) // Playing

        let bobGame = await conquerMode.userGames.call(bob)
        bobGame.wins.toNumber().should.be.equal(1)
        bobGame.loses.toNumber().should.be.equal(1)
        bobGame.status.toNumber().should.be.equal(1)

        await conquerMode.GameFinished(alice, bob, 1)
        await conquerMode.GameFinished(alice, bob, 1)

        //see that Bob is removed from conquer mod
        bobGame = await conquerMode.userGames.call(bob)
        bobGame.status.toNumber().should.be.equal(2)

        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)
        await conquerMode.GameFinished(alice, carlos, 1)

        //see that Bob is removed from conquer mode
        const tx = await conquerMode.GameFinished(alice, james, 1)

        //see that alice gets her coins back after 7 wins
        assertEventVar(tx, 'AwardTokens', 'to', alice)
        assertEventVar(tx, 'AwardTokens', 'tokens', 25)

        aliceGame = await conquerMode.userGames.call(alice)
        aliceGame.wins.toNumber().should.be.equal(7)


        await conquerMode.GameFinished(alice, james, 1)
        await conquerMode.GameFinished(alice, james, 1)

        await conquerMode.GameFinished(alice, greg, 1)
        await conquerMode.GameFinished(alice, greg, 1)
        const tx2 = await conquerMode.GameFinished(alice, greg, 1)


        bobGame = await conquerMode.userGames.call(bob)
        bobGame.wins.toNumber().should.be.equal(1)
        bobGame.loses.toNumber().should.be.equal(3)

        carlosGame = await conquerMode.userGames.call(carlos)
        carlosGame.loses.toNumber().should.be.equal(3)

        //Alice got 12 wins lets make sure she is finished
        aliceGame = await conquerMode.userGames.call(alice)
        aliceGame.wins.toNumber().should.be.equal(12)
        aliceGame.status.toNumber().should.be.equal(2) // Finished

        //see that alice gets a card pack payout
        assertEventVar(tx2, 'AwardPack', 'to', alice)
        assertEventVar(tx2, 'AwardPack', 'packCount', 1)
        assertEventVar(tx2, 'AwardPack', 'packType', 0)

        //Alice should be finished
        aliceGame = await conquerMode.userGames.call(alice)
        aliceGame.status.toNumber().should.be.equal(2)
    })

    //TODO Req #2 pick random card 30 times
    it('Should ConquerMode should be able to randomize the decs', async () => {
    })

    //Req #1 Allow Payment to play this mode?
    //a) use payable method
    //b) allow loom store to sign a package verifying payment
    it('Should ConquerMode verify payment works', async () => {
        /*
        const signers = accounts.slice(0, 3)
        signers.sort()

        ticketId = 123;
        gameId = 1;

        //TODO need to verify this is the correct hash parameters
        const hash = soliditySha3("ticket", ticketId, gameId);

          const sigV = []
          const sigR = []
          const sigS = []

          for (let i = 0; i < signers.length; i++) {
            const sig = (await web3.eth.sign(hash, signers[i])).slice(2)
            const r = '0x' + sig.substring(0, 64)
            const s = '0x' + sig.substring(64, 128)
            const v = parseInt(sig.substring(128, 130), 16) + 27
            sigV.push(v)
            sigR.push(r)
            sigS.push(s)
          }

        //TODO we shouldnt be able to reuse a ticket across multiple users
        await conquerMode.RegisterGame(alice, ticketId, gameId, sigV, sigR, sigS)
        await conquerMode.RegisterGame(bob, ticketId, gameId, sigV, sigR, sigS)
        //Need to catch an assert here
        */
    })

})
