pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";
import "../contracts/3rdParty/Seriality/BytesToTypes.sol";
import "../contracts/3rdParty/Seriality/SizeOf.sol";
import "../contracts/3rdParty/Seriality/TypesToBytes.sol";

contract TestSerialization {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for ZBGameMode.GameState;

    function testDeserializeInts() public {
        bytes memory buffer = hex'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000003000201';
        uint offset = buffer.length;
        Assert.equal(int(BytesToTypes.bytesToInt8(offset, buffer)), int(1), "");
        offset -= SizeOf.sizeOfInt(8);
        Assert.equal(int(BytesToTypes.bytesToInt16(offset, buffer)), int(2), "");
        offset -= SizeOf.sizeOfInt(16);
        Assert.equal(int(BytesToTypes.bytesToInt32(offset, buffer)), int(3), "");
        offset -= SizeOf.sizeOfInt(32);
        Assert.equal(int(BytesToTypes.bytesToInt64(offset, buffer)), int(4), "");
        offset -= SizeOf.sizeOfInt(64);
    }

    function testDeserializeStrings() public {
        bytes memory buffer = hex'436f6f6c20427574746f6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b';
        uint offset = buffer.length;
        uint size = BytesToTypes.getStringSize(offset, buffer);
        string memory str = new string(size);
        BytesToTypes.bytesToString(offset, buffer, bytes(str));
        Assert.equal(str, "Cool Button", "");

        buffer = hex'000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f6c20427574746f6e20300000000000000000000000000000000000000000003720436f6f6c20427574746f6e203820436f6f6c20427574746f6e203920436f746f6e203520436f6f6c20427574746f6e203620436f6f6c20427574746f6e2020427574746f6e203320436f6f6c20427574746f6e203420436f6f6c20427574436f6f6c20427574746f6e203120436f6f6c20427574746f6e203220436f6f6c000000000000000000000000000000000000000000000000000000000000008b';
        offset = buffer.length;
        size = BytesToTypes.getStringSize(offset, buffer);
        str = new string(size);
        BytesToTypes.bytesToString(offset, buffer, bytes(str));
        Assert.equal(str, "Cool Button 1 Cool Button 2 Cool Button 3 Cool Button 4 Cool Button 5 Cool Button 6 Cool Button 7 Cool Button 8 Cool Button 9 Cool Button 0", "");
    }

    function testDeserializeGameState() public {
        bytes memory buffer = hex'01140114000000000000000005';
        ZBGameMode.GameState memory gameState;
        gameState.initWithSerializedData(buffer);

        Assert.equal(gameState.id, int64(5), "");
        Assert.equal(int(gameState.currentPlayerIndex), uint8(0), "");
        Assert.equal(int(gameState.playerStates[0].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[0].goo), int(1), "");
        Assert.equal(int(gameState.playerStates[1].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[1].goo), int(1), "");
    }
}