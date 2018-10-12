const { hexToBytes } = require('web3-utils')

var SerializationTestData = artifacts.require("./SerializationTestData.sol");
const ZBEnum = artifacts.require('ZBEnum')

contract('SerializationTestData', accounts => {
    function logOutput(res) {
        //console.log(res)
    }

    let serializationTestData
    let zenum
    const  [ alice, bob, carlos ] = accounts;

    beforeEach(async () => {
        serializationTestData = await SerializationTestData.new()
        zenum =  await ZBEnum.new()
    });

    it('Contract should serialize ints', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeInts.call()
        logOutput(res)
        const bytes = hexToBytes(res)
        const slice = bytes.slice(64 - 15, 64)

        assert.deepEqual(slice, [ 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0, 2, 1 ])
    })

    it('Contract should serialize strings', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeShortString.call()
        logOutput(res)
        assert.ok(res.endsWith("436f6f6c20427574746f6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b"))
    })

    it('Contract should serialize long strings', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeLongString.call()
        logOutput(res)
        assert.ok(res.endsWith("6f6c20427574746f6e20300000000000000000000000000000000000000000003720436f6f6c20427574746f6e203820436f6f6c20427574746f6e203920436f746f6e203520436f6f6c20427574746f6e203620436f6f6c20427574746f6e2020427574746f6e203320436f6f6c20427574746f6e203420436f6f6c20427574436f6f6c20427574746f6e203120436f6f6c20427574746f6e203220436f6f6c000000000000000000000000000000000000000000000000000000000000008b"))
    })

    it('Contract should serialize state change actions', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeGameStateChangeActions.call()
        logOutput(res)
        assert.ok(res.endsWith("060100000002020000000002080100000003050000000003060100000001050000000001"))
    })

    it('Contract should serialize player deck cards change action', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeGameStateChangePlayerDeckCards.call()
        logOutput(res)
        assert.ok(res.endsWith("44765726d73000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000035a68616d70696f6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000802010000000400000000000000044765726d73000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000035a68616d70696f6e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008020000000004"))
    })

    it('Contract should serialize custom UI', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeCustomUi.call()
        logOutput(res)
        assert.ok(res.endsWith("736f6d6546756e6374696f6e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c436c69636b204d65000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000096000000c80000001e0000001900000002536f6d65205665727920436f6f6c207465787421000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000096000000c8000000e60000001900000001"))
    })
})
