pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/3rdParty/Seriality/Seriality.sol";

contract TestSerialization is Seriality{
    function testDeserializeInts() public {
        bytes memory buffer = hex'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000003000201';
        uint offset = buffer.length;
        Assert.equal(int(bytesToInt8(offset, buffer)), int(1), "");
        offset -= sizeOfInt(8);
        Assert.equal(int(bytesToInt16(offset, buffer)), int(2), "");
        offset -= sizeOfInt(16);
        Assert.equal(int(bytesToInt32(offset, buffer)), int(3), "");
        offset -= sizeOfInt(32);
        Assert.equal(int(bytesToInt64(offset, buffer)), int(4), "");
        offset -= sizeOfInt(64);
    }
}