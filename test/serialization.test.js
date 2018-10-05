const { hexToBytes } = require('web3-utils')

var SerializationTestData = artifacts.require("./SerializationTestData.sol");
const ZBEnum = artifacts.require('ZBEnum')

contract('SerializationTestData', accounts => {
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
        const bytes = hexToBytes(res)
        const slice = bytes.slice(64 - 15, 64)

        assert.deepEqual(slice, [ 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0, 2, 1 ])
    })
})
