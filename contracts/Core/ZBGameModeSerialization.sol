pragma solidity ^0.4.24;

import "./ZB/ZBEnum.sol";
import "./ZB/ZBGameMode.sol";
import "./../3rdParty/Seriality/BytesToTypes.sol";
import "./../3rdParty/Seriality/SizeOf.sol";
import "./../3rdParty/Seriality/TypesToBytes.sol";

library ZBGameModeSerialization {
    struct SerializedGameStateChanges {
        bytes buffer;
        uint offset;
    }

    struct SerializedCustomUi {
        bytes buffer;
        uint offset;
    }

    // GameState

    function initWithSerializedData(ZBGameMode.GameState memory self, bytes serializedGameState) internal pure {
        uint offset = serializedGameState.length;

        self.id = BytesToTypes.bytesToInt64(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(64);

        self.currentPlayerIndex = BytesToTypes.bytesToUint8(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(8);

        self.playerStates = new ZBGameMode.PlayerState[](2);
        for (uint i = 0; i < self.playerStates.length; i++) {
            self.playerStates[i].defense = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            self.playerStates[i].goo = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);
        }
    }

    // SerializedGameStateChanges

    function init(SerializedGameStateChanges memory self, uint bufferSize) internal pure {
        self.buffer = new bytes(bufferSize);
        self.offset = bufferSize;
    }

    function getBytes(SerializedGameStateChanges memory self) internal pure returns (bytes) {
        return self.buffer;
    }

    function changePlayerDefense(SerializedGameStateChanges memory self, uint8 playerIndex, uint8 defense) internal pure returns (uint) {
        serializeStartGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerDefense);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, defense, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerGoo(SerializedGameStateChanges memory self, uint8 playerIndex, uint8 goo) internal pure {
        serializeStartGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerGoo);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, goo, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function serializeStartGameStateChangeAction(SerializedGameStateChanges memory self, ZBEnum.GameStateChangeAction action) private pure {
        TypesToBytes.intToBytes(self.offset, uint32(action), self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
    }

    // SerializedCustomUi

    function init(SerializedCustomUi memory self, uint bufferSize) internal pure {
        self.buffer = new bytes(bufferSize);
        self.offset = bufferSize;
    }

    function getBytes(SerializedCustomUi memory self) internal pure returns (bytes) {
        return self.buffer;
    }

    function addLabel(SerializedCustomUi memory self, ZBGameMode.Rect rect, string text) internal pure {
        serializeStartCustomUiElement(self, ZBEnum.CustomUiElement.Label, rect);

        TypesToBytes.stringToBytes(self.offset, bytes(text), self.buffer);
        self.offset -= SizeOf.sizeOfString(text);
    }

    function addButton(SerializedCustomUi memory self, ZBGameMode.Rect rect, string title, string onClickFunctionName) internal pure {
        serializeStartCustomUiElement(self, ZBEnum.CustomUiElement.Button, rect);

        TypesToBytes.stringToBytes(self.offset, bytes(title), self.buffer);
        self.offset -= SizeOf.sizeOfString(title);

        TypesToBytes.stringToBytes(self.offset, bytes(onClickFunctionName), self.buffer);
        self.offset -= SizeOf.sizeOfString(onClickFunctionName);
    }

    function serializeStartCustomUiElement(SerializedCustomUi memory self, ZBEnum.CustomUiElement element) private pure {
        TypesToBytes.intToBytes(self.offset, uint32(element), self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
    }

    function serializeStartCustomUiElement(SerializedCustomUi memory self, ZBEnum.CustomUiElement element, ZBGameMode.Rect rect) private pure {
        serializeStartCustomUiElement(self, element);
        self.offset = serializeRect(self.buffer, self.offset, rect);
    }

    function serializeRect(bytes buffer, uint offset, ZBGameMode.Rect rect) private pure returns (uint) {
        uint newOffset = offset;
        newOffset = serializeVector2Int(buffer, newOffset, rect.position);
        newOffset = serializeVector2Int(buffer, newOffset, rect.size);
        return newOffset;
    }

    function serializeVector2Int(bytes buffer, uint offset, ZBGameMode.Vector2Int v) private pure returns (uint) {
        uint newOffset = offset;

        TypesToBytes.intToBytes(newOffset, v.x, buffer);
        newOffset -= SizeOf.sizeOfInt(32);

        TypesToBytes.intToBytes(newOffset, v.y, buffer);
        newOffset -= SizeOf.sizeOfInt(32);

        return newOffset;
    }
}