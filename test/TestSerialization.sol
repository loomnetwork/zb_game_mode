pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";

contract TestSerialization is ZBGameModeSerialization {
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

    function testDeserializeGameState() public {
        bytes memory buffer = hex'01140114000000000000000005';
        GameState memory gameState = deserializeGameState(buffer);
        Assert.equal(gameState.id, int64(5), "");
        Assert.equal(int(gameState.currentPlayerIndex), uint8(0), "");
        Assert.equal(int(gameState.playerStates[0].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[0].goo), int(1), "");
        Assert.equal(int(gameState.playerStates[1].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[1].goo), int(1), "");
    }
}