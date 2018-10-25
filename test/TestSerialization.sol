pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZB/ZBSerializer.sol";
import "../contracts/Core/ZB/SerialityBinaryStream.sol";

contract TestSerialization {
    using ZBSerializer for ZBSerializer.SerializedGameStateChanges;
    using ZBSerializer for ZBGameMode.GameState;
    using SerialityBinaryStream for SerialityBinaryStream.BinaryStream;

    function testBinaryStreamResize() public {
        bytes memory buffer = new bytes(2);
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(buffer, buffer.length);

        Assert.equal(stream.buffer.length, uint(2), "");
        Assert.equal(stream.offset, uint(2), "");
        stream.writeInt16(1);
        Assert.equal(stream.buffer.length, uint(32), "");
        Assert.equal(stream.offset, uint(30), "");
        stream.writeInt16(2);
        Assert.equal(stream.buffer.length, uint(64), "");
        Assert.equal(stream.offset, uint(60), "");
        stream.writeInt64(3);
        Assert.equal(stream.buffer.length, uint(64), "");
        Assert.equal(stream.offset, uint(52), "");
    }

    function testDeserializeInts() public {
        bytes memory buffer = hex'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000301';
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(buffer, buffer.length);

        Assert.equal(int(stream.readInt8()), int(1), "");
        Assert.equal(int(stream.readInt32()), int(3), "");
        Assert.equal(int(stream.readInt64()), int(4), "");
    }

    function testDeserializeStrings() public {
        bytes memory buffer = hex'436f6f6c20427574746f6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b';
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(buffer, buffer.length);
        Assert.equal(stream.readString(), "Cool Button", "");

        buffer = hex'000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f6c20427574746f6e20300000000000000000000000000000000000000000003720436f6f6c20427574746f6e203820436f6f6c20427574746f6e203920436f746f6e203520436f6f6c20427574746f6e203620436f6f6c20427574746f6e2020427574746f6e203320436f6f6c20427574746f6e203420436f6f6c20427574436f6f6c20427574746f6e203120436f6f6c20427574746f6e203220436f6f6c000000000000000000000000000000000000000000000000000000000000008b';
        stream = SerialityBinaryStream.BinaryStream(buffer, buffer.length);
        Assert.equal(stream.readString(), "Cool Button 1 Cool Button 2 Cool Button 3 Cool Button 4 Cool Button 5 Cool Button 6 Cool Button 7 Cool Button 8 Cool Button 9 Cool Button 0", "");
    }

    function testDeserializeGameState() public {
        bytes memory buffer = hex'0a0a06030000140100000000010000000301000000035075736868680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000015010000000001000000020100000002507566666572000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000e010000000001000000010100000002576865657a7900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000110100000000010000000101000000015768697a70617200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000013010000000001000000010100000001536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000001000000005010000000001000000010100000001417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000b010000000001000000010100000001417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000c010000000001000000010100000002576865657a79000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000001200000003000000000000000244656661756c740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000706c617965722d3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080a0a0603000014010000000001000000010100000001536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000004010000000001000000010100000001536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000005010000000001000000020100000003426f756e63657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000009010000000001000000030100000003507573686868000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000a010000000001000000010100000001417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000005010000000001000000010100000001417a7572617a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000001010000000001000000010100000002576865657a790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000007010000000001000000010100000002576865657a79000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000600000003000000000000000244656661756c740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000005';
        ZBGameMode.GameState memory gameState;
        gameState.init(buffer);

        Assert.equal(gameState.id, int64(5), "");
        Assert.equal(int(gameState.currentPlayerIndex), uint8(0), "");
        Assert.equal(int(gameState.playerStates[0].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[0].currentGoo), int(0), "");
        Assert.equal(int(gameState.playerStates[0].gooVials), int(0), "");
        Assert.equal(int(gameState.playerStates[0].initialCardsInHandCount), int(3), "");
        Assert.equal(int(gameState.playerStates[0].maxCardsInPlay), int(6), "");
        Assert.equal(int(gameState.playerStates[0].maxCardsInHand), int(10), "");
        Assert.equal(int(gameState.playerStates[0].maxGooVials), int(10), "");
        Assert.equal(int(gameState.playerStates[0].deck.id), int(0), "");
        Assert.equal(int(gameState.playerStates[0].deck.heroId), int(2), "");
        Assert.equal(int(gameState.playerStates[0].cardsInDeck.length), int(5), "");
        Assert.equal(int(gameState.playerStates[0].cardsInHand.length), int(3), "");

        Assert.equal(int(gameState.playerStates[1].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[1].currentGoo), int(0), "");
        Assert.equal(int(gameState.playerStates[1].gooVials), int(0), "");
        Assert.equal(int(gameState.playerStates[1].initialCardsInHandCount), int(3), "");
        Assert.equal(int(gameState.playerStates[1].maxCardsInPlay), int(6), "");
        Assert.equal(int(gameState.playerStates[1].maxCardsInHand), int(10), "");
        Assert.equal(int(gameState.playerStates[1].maxGooVials), int(10), "");
        Assert.equal(int(gameState.playerStates[1].deck.id), int(0), "");
        Assert.equal(int(gameState.playerStates[1].deck.heroId), int(2), "");
        Assert.equal(int(gameState.playerStates[1].cardsInDeck.length), int(5), "");
        Assert.equal(int(gameState.playerStates[1].cardsInHand.length), int(3), "");
    }
}