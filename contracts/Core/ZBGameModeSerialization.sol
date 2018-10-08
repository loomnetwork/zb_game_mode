pragma solidity ^0.4.24;

import "./ZB/ZBEnum.sol";
import "./../3rdParty/Seriality/BytesToTypes.sol";
import "./../3rdParty/Seriality/SizeOf.sol";
import "./../3rdParty/Seriality/TypesToBytes.sol";

library ZBGameModeSerialization {
    struct PlayerState {
        uint8 defense;
        uint8 goo;
    }

    struct GameState {
        int64 id;
        uint8 currentPlayerIndex;
        PlayerState[] playerStates;
    }

    struct GameStateSerializedChanges {
        bytes buffer;
        uint offset;
    }

    function initWithSerializedData(GameState memory self, bytes serializedGameState) internal pure {
        uint offset = serializedGameState.length;

        self.id = BytesToTypes.bytesToInt64(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(64);

        self.currentPlayerIndex = BytesToTypes.bytesToUint8(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(8);

        self.playerStates = new PlayerState[](2);
        for (uint i = 0; i < self.playerStates.length; i++) {
            self.playerStates[i].defense = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            self.playerStates[i].goo = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);
        }
    }

    function getBytes(GameStateSerializedChanges memory self) internal pure returns (bytes) {
        return self.buffer;
    }

    function init(GameStateSerializedChanges memory self, uint bufferSize) internal pure {
        self.buffer = new bytes(bufferSize);
        self.offset = bufferSize;
    }

    function changePlayerDefense(GameStateSerializedChanges memory self, uint8 playerIndex, uint8 defense) internal pure returns (uint) {
        serializeStateGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerDefense);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, defense, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerGoo(GameStateSerializedChanges memory self, uint8 playerIndex, uint8 goo) internal pure {
        serializeStateGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerGoo);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, goo, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function serializeStateGameStateChangeAction(GameStateSerializedChanges memory self, ZBEnum.GameStateChangeAction action) private pure {
        TypesToBytes.intToBytes(self.offset, uint32(action), self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
    }
}