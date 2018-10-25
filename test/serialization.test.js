const { hexToBytes } = require('web3-utils')

var SerializationTestData = artifacts.require("./SerializationTestData.sol");
const ZBEnum = artifacts.require('ZBEnum')

contract('SerializationTestData', accounts => {
    async function getLastEventArgs(event) {
        return new Promise(function(resolve, reject) {
            event.get((error, logs) => {
                if (!error) {
                    resolve(logs[logs.length - 1].args);
                } else {
                    reject(Error());
                }
            });
        });
    }

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

        assert.ok(res.endsWith("00000000000000040000000301"))
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

        const tx = await serializationTestData.serializeGameStateChangeActions()
        let event = await getLastEventArgs(serializationTestData.GameStateChanges());
        assert.ok(event.serializedChanges.endsWith("0x000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060100000002020000000002080100000003050000000003060100000001050000000001"))
    })

    it('Contract should serialize changePlayerCardsInHand', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeGameStateChangePlayerCardsInHand.call()
        logOutput(res)
        assert.ok(res.endsWith("007466972652d6d6177000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000003000000020100000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900000000080000000007466972652d6d6177000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000003000000020000000005"))
    })

    it('Contract should serialize custom UI', async () => {
        serializationTestData.address.should.not.be.null

        const res = await serializationTestData.serializeCustomUi.call()
        logOutput(res)
        assert.ok(res.endsWith("960000012c0000012c000002a300000002536f6d65205665727920436f6f6c207465787421000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000096000000c8000000e60000001900000001"))
    })
})
