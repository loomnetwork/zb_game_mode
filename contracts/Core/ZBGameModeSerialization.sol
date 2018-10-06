pragma solidity ^0.4.24;

import "./ZB/ZBEnum.sol";
import "./../3rdParty/Seriality/Seriality.sol";

contract ZBGameModeSerialization is ZBEnum, Seriality {
    struct PlayerState {
        uint8 defense;
        uint8 goo;
    }

    struct GameState {
        int64 id;
        uint8 currentPlayerIndex;
        PlayerState[] playerStates;
    }

    function deserializeGameState(bytes serializedGameState) internal pure returns (GameState) {
        uint offset = serializedGameState.length;

        GameState memory gameState;

        gameState.id = bytesToInt64(offset, serializedGameState);
        offset -= sizeOfInt(64);

        gameState.currentPlayerIndex = bytesToUint8(offset, serializedGameState);
        offset -= sizeOfInt(8);

        gameState.playerStates = new PlayerState[](2);
        for (uint i = 0; i < gameState.playerStates.length; i++) {
            gameState.playerStates[i].defense = bytesToUint8(offset, serializedGameState);
            offset -= sizeOfInt(8);

            gameState.playerStates[i].goo = bytesToUint8(offset, serializedGameState);
            offset -= sizeOfInt(8);
        }

        return gameState;
    }

    function startGameStateChangeAction(bytes buffer, uint offset, GameStateChangeAction action) internal pure returns (uint) {
        uint newOffset = offset;
        intToBytes(newOffset, uint32(action), buffer);
        newOffset -= sizeOfInt(32);
        return newOffset;
    }

    function changePlayerDefense(bytes buffer, uint offset, uint8 playerIndex, uint8 defense) internal pure returns (uint) {
        uint newOffset = startGameStateChangeAction(buffer, offset, GameStateChangeAction.SetPlayerDefense);

        intToBytes(newOffset, playerIndex, buffer);
        newOffset -= sizeOfInt(8);

        intToBytes(newOffset, defense, buffer);
        newOffset -= sizeOfInt(8);

        return newOffset;
    }

    function changePlayerGoo(bytes buffer, uint offset, uint8 playerIndex, uint8 goo) internal pure returns (uint) {
        uint newOffset = startGameStateChangeAction(buffer, offset, GameStateChangeAction.SetPlayerGoo);

        intToBytes(newOffset, playerIndex, buffer);
        newOffset -= sizeOfInt(8);

        intToBytes(newOffset, goo, buffer);
        newOffset -= sizeOfInt(8);

        return newOffset;
    }
}