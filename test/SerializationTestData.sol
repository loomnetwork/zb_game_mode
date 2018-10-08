pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";
import "../contracts/3rdParty/Seriality/BytesToTypes.sol";
import "../contracts/3rdParty/Seriality/SizeOf.sol";
import "../contracts/3rdParty/Seriality/TypesToBytes.sol";

contract SerializationTestData {
    using ZBGameModeSerialization for ZBGameModeSerialization.GameStateSerializedChanges;
    using ZBGameModeSerialization for ZBGameModeSerialization.GameState;

    function serializeInts() public pure returns (bytes) {
        bytes memory buffer = new bytes(64);
        uint offset = 64;
        TypesToBytes.intToBytes(offset, int8(1), buffer);
        offset -= SizeOf.sizeOfInt(8);
        TypesToBytes.intToBytes(offset, int16(2), buffer);
        offset -= SizeOf.sizeOfInt(16);
        TypesToBytes.intToBytes(offset, int32(3), buffer);
        offset -= SizeOf.sizeOfInt(32);
        TypesToBytes.intToBytes(offset, int64(4), buffer);
        offset -= SizeOf.sizeOfInt(64);
        return buffer;
    }

    function serializeGameStateChangeActions() public pure returns (bytes) {
        ZBGameModeSerialization.GameStateSerializedChanges memory changes;
        changes.init(64);
        changes.changePlayerDefense(0, 5);
        changes.changePlayerDefense(1, 6);
        changes.changePlayerGoo(0, 7);
        changes.changePlayerGoo(1, 8);
        return changes.getBytes();
    }
}