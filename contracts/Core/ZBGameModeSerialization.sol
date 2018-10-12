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
        uint stringLength;

        self.id = BytesToTypes.bytesToInt64(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(64);

        self.currentPlayerIndex = BytesToTypes.bytesToUint8(offset, serializedGameState);
        offset -= SizeOf.sizeOfInt(8);

        self.playerStates = new ZBGameMode.PlayerState[](2);
        for (uint i = 0; i < self.playerStates.length; i++) {
            // Generic
            self.playerStates[i].defense = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            self.playerStates[i].currentGoo = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            self.playerStates[i].gooVials = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            // Deck
            ZBGameMode.Deck memory deck;

            deck.id = BytesToTypes.bytesToInt64(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(64);

            stringLength = BytesToTypes.getStringSize(offset, serializedGameState);
            deck.name = new string(stringLength);
            BytesToTypes.bytesToString(offset, serializedGameState, bytes(deck.name));
            offset -= stringLength;

            deck.heroId = BytesToTypes.bytesToInt64(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(64);

            uint8 cardCount = BytesToTypes.bytesToUint8(offset, serializedGameState);
            offset -= SizeOf.sizeOfInt(8);

            deck.cards = new ZBGameMode.CollectionCard[](cardCount);

            for (uint j = 0; j < deck.cards.length; j++) {
                stringLength = BytesToTypes.getStringSize(offset, serializedGameState);
                deck.cards[j].name = new string(stringLength);
                BytesToTypes.bytesToString(offset, serializedGameState, bytes(deck.cards[j].name));
                offset -= stringLength;

                deck.cards[j].amount = BytesToTypes.bytesToInt64(offset, serializedGameState);
                offset -= SizeOf.sizeOfInt(64);
            }

            self.playerStates[i].deck = deck;
            delete(deck);
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

    function changePlayerCurrentGoo(SerializedGameStateChanges memory self, uint8 playerIndex, uint8 currentGoo) internal pure {
        serializeStartGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerCurrentGoo);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, currentGoo, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerGooVials(SerializedGameStateChanges memory self, uint8 playerIndex, uint8 gooVials) internal pure {
        serializeStartGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerGooVials);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, gooVials, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerDeckCards(SerializedGameStateChanges memory self, uint8 playerIndex, ZBGameMode.CollectionCard[] cards) internal pure {
        serializeStartGameStateChangeAction(self, ZBEnum.GameStateChangeAction.SetPlayerDeckCards);

        TypesToBytes.intToBytes(self.offset, playerIndex, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        TypesToBytes.intToBytes(self.offset, uint8(cards.length), self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);

        for (uint i = 0; i < cards.length; i++) {
            serializeCollectionCard(self, cards[i]);
        }
    }

    function serializeStartGameStateChangeAction(SerializedGameStateChanges memory self, ZBEnum.GameStateChangeAction action) private pure {
        TypesToBytes.intToBytes(self.offset, uint32(action), self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
    }

    function serializeCollectionCard(SerializedGameStateChanges memory self, ZBGameMode.CollectionCard card) private pure {
        TypesToBytes.stringToBytes(self.offset, bytes(card.name), self.buffer);
        self.offset -= SizeOf.sizeOfString(card.name);

        TypesToBytes.intToBytes(self.offset, card.amount, self.buffer);
        self.offset -= SizeOf.sizeOfInt(64);
    }

    // SerializedCustomUi

    function init(SerializedCustomUi memory self, uint bufferSize) internal pure {
        self.buffer = new bytes(bufferSize);
        self.offset = bufferSize;
    }

    function getBytes(SerializedCustomUi memory self) internal pure returns (bytes) {
        return self.buffer;
    }

    function label(SerializedCustomUi memory self, ZBGameMode.Rect rect, string text) internal pure {
        serializeStartCustomUiElement(self, ZBEnum.CustomUiElement.Label, rect);

        TypesToBytes.stringToBytes(self.offset, bytes(text), self.buffer);
        self.offset -= SizeOf.sizeOfString(text);
    }

    function button(SerializedCustomUi memory self, ZBGameMode.Rect rect, string title, string onClickFunctionName) internal pure {
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