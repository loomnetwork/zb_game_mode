pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";

contract SerializationTestData is ZBGameModeSerialization {
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

    function serializeGameStateChangeActions() public returns (bytes) {
        bytes memory buffer = new bytes(64);
        uint offset = buffer.length;
        offset = changePlayerDefense(buffer, offset, 0, 5);
        offset = changePlayerDefense(buffer, offset, 1, 6);
        offset = changePlayerGoo(buffer, offset, 0, 7);
        offset = changePlayerGoo(buffer, offset, 1, 8);
        return buffer;
    }
}