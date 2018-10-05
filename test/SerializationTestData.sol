pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/3rdParty/Seriality/Seriality.sol";

contract SerializationTestData is Seriality{
    function serializeInts() public returns (bytes) {
        bytes memory buffer = new bytes(64);
        uint offset = 64;
        intToBytes(offset, int8(1), buffer);
        offset -= sizeOfInt(8);
        intToBytes(offset, int16(2), buffer);
        offset -= sizeOfInt(16);
        intToBytes(offset, int32(3), buffer);
        offset -= sizeOfInt(32);
        intToBytes(offset, int64(4), buffer);
        offset -= sizeOfInt(64);
        return buffer;
    }
}