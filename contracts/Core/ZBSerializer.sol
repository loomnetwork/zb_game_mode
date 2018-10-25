pragma solidity ^0.4.24;

import "./ZB/ZBEnum.sol";
import "./ZB/ZBGameMode.sol";
import "./../3rdParty/Seriality/BytesToTypes.sol";
import "./../3rdParty/Seriality/SizeOf.sol";
import "./../3rdParty/Seriality/TypesToBytes.sol";

library ZBSerializer {
    event GameStateChanges (
        bytes serializedChanges
    );

    struct SerializationBuffer {
        bytes buffer;
        uint offset;
    }

    struct SerializedGameStateChanges {
        SerializationBuffer buffer;
    }

    struct SerializedCustomUi {
        SerializationBuffer buffer;
    }

    // GameState deserialization

    function init(ZBGameMode.GameState memory self, bytes serializedGameState) internal pure {
        SerializationBuffer memory buffer = SerializationBuffer(serializedGameState, serializedGameState.length);

        self.id = BytesToTypes.bytesToInt64(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(64);

        self.currentPlayerIndex = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        self.playerStates = new ZBGameMode.PlayerState[](2);
        for (uint i = 0; i < self.playerStates.length; i++) {
            self.playerStates[i] = deserializePlayerState(buffer);
        }
    }

    function deserializePlayerState(SerializationBuffer memory buffer) private pure returns (ZBGameMode.PlayerState) {
        ZBGameMode.PlayerState memory player;

        uint stringLength = BytesToTypes.getStringSize(buffer.offset, buffer.buffer);
        player.id = new string(stringLength);
        BytesToTypes.bytesToString(buffer.offset, buffer.buffer, bytes(player.id));
        buffer.offset -= stringLength;

        player.deck = deserializeDeck(buffer);
        player.cardsInHand = deserializeCardInstanceArray(buffer);
        player.cardsInDeck = deserializeCardInstanceArray(buffer);

        player.defense = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.currentGoo = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.gooVials = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.initialCardsInHandCount = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.maxCardsInPlay = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.maxCardsInHand = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        player.maxGooVials = BytesToTypes.bytesToUint8(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);

        return player;
    }

    function serializeCardInstance(SerializationBuffer memory buffer, ZBGameMode.CardInstance card) private pure {
        TypesToBytes.intToBytes(buffer.offset, card.instanceId, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        TypesToBytes.stringToBytes(buffer.offset, bytes(card.mouldName), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfString(card.mouldName);

        TypesToBytes.intToBytes(buffer.offset, card.defense, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        TypesToBytes.boolToBytes(buffer.offset, card.defenseInherited, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();

        TypesToBytes.intToBytes(buffer.offset, card.attack, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        TypesToBytes.boolToBytes(buffer.offset, card.attackInherited, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();

        TypesToBytes.intToBytes(buffer.offset, card.gooCost, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        TypesToBytes.boolToBytes(buffer.offset, card.gooCostInherited, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();
    }

    function deserializeCardInstance(SerializationBuffer memory buffer) private pure returns (ZBGameMode.CardInstance) {
        ZBGameMode.CardInstance memory card;

        card.instanceId = BytesToTypes.bytesToInt32(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        uint stringLength = BytesToTypes.getStringSize(buffer.offset, buffer.buffer);
        card.mouldName = new string(stringLength);
        BytesToTypes.bytesToString(buffer.offset, buffer.buffer, bytes(card.mouldName));
        buffer.offset -= stringLength;

        card.defense = BytesToTypes.bytesToInt32(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        card.defenseInherited = BytesToTypes.bytesToBool(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();

        card.attack = BytesToTypes.bytesToInt32(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        card.attackInherited = BytesToTypes.bytesToBool(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();

        card.gooCost = BytesToTypes.bytesToInt32(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
        card.gooCostInherited = BytesToTypes.bytesToBool(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfBool();

        return card;
    }

    function serializeCardInstanceArray(SerializationBuffer memory buffer, ZBGameMode.CardInstance[] cards) internal pure {
        TypesToBytes.uintToBytes(buffer.offset, cards.length, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        for (uint i = 0; i < cards.length; i++) {
            serializeCardInstance(buffer, cards[i]);
        }
    }

    function deserializeCardInstanceArray(SerializationBuffer memory buffer) private pure returns (ZBGameMode.CardInstance[]) {
        uint32 length = BytesToTypes.bytesToUint32(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        ZBGameMode.CardInstance[] memory cards = new ZBGameMode.CardInstance[](length);
        for (uint i = 0; i < length; i++) {
            cards[i] = deserializeCardInstance(buffer);
        }

        return cards;
    }

    function deserializeDeck(SerializationBuffer memory buffer) private pure returns (ZBGameMode.Deck) {
        ZBGameMode.Deck memory deck;

        deck.id = BytesToTypes.bytesToInt64(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(64);

        uint stringLength = BytesToTypes.getStringSize(buffer.offset, buffer.buffer);
        deck.name = new string(stringLength);
        BytesToTypes.bytesToString(buffer.offset, buffer.buffer, bytes(deck.name));
        buffer.offset -= stringLength;

        deck.heroId = BytesToTypes.bytesToInt64(buffer.offset, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(64);

        return deck;
    }

    function serializeStartGameStateChangeAction(SerializationBuffer memory buffer, ZBEnum.GameStateChangeAction action) private pure {
        TypesToBytes.intToBytes(buffer.offset, uint32(action), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);
    }

    function serializeStartGameStateChangeAction(
        SerializationBuffer memory buffer,
        ZBEnum.GameStateChangeAction action,
        ZBGameMode.Player player
        ) private pure {
        TypesToBytes.intToBytes(buffer.offset, uint32(action), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        TypesToBytes.intToBytes(buffer.offset, uint8(player), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    // CardInstance

    function changeMouldName(ZBGameMode.CardInstance memory self, string mouldName) internal pure {
        self.mouldName = mouldName;
    }

    function changeDefense(ZBGameMode.CardInstance memory self, uint8 defense) internal pure {
        self.defense = defense;
        self.defenseInherited = false;
    }

    function changeAttack(ZBGameMode.CardInstance memory self, uint8 attack) internal pure {
        self.attack = attack;
        self.attackInherited = false;
    }

    function changeGooCost(ZBGameMode.CardInstance memory self, uint8 gooCost) internal pure {
        self.gooCost = gooCost;
        self.gooCostInherited = false;
    }

    // SerializedGameStateChanges

    function init(SerializedGameStateChanges memory self) internal pure {
        init(self, 2 ** 15);
    }

    function init(SerializedGameStateChanges memory self, uint bufferSize) internal pure {
        self.buffer = SerializationBuffer(new bytes(bufferSize), bufferSize);
    }

    function getBytes(SerializedGameStateChanges memory self) internal pure returns (bytes) {
        return self.buffer.buffer;
    }

    function emit(SerializedGameStateChanges memory self) internal {
        emit GameStateChanges(getBytes(self));
    }

    function changePlayerDefense(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 defense) internal pure returns (uint) {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerDefense, player);

        TypesToBytes.intToBytes(buffer.offset, defense, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerCurrentGoo(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 currentGoo) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerCurrentGoo, player);

        TypesToBytes.intToBytes(buffer.offset, currentGoo, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerCurrentGooVials(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 gooVials) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerGooVials, player);

        TypesToBytes.intToBytes(buffer.offset, gooVials, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerCardsInDeck(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards,
        uint cardCount
        ) internal pure {
        require(
            cardCount <= cards.length,
            "cardCount > cards.length"
        );

        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerCardsInDeck, player);

        TypesToBytes.intToBytes(buffer.offset, uint32(cardCount), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        for (uint i = 0; i < cardCount; i++) {
            serializeCardInstance(buffer, cards[i]);
        }
    }

    function changePlayerCardsInDeck(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards
        ) internal pure {
        changePlayerCardsInDeck(self, player, cards, cards.length);
    }

    function changePlayerCardsInHand(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards,
        uint cardCount
        ) internal pure {
        require(
            cardCount <= cards.length,
            "cardCount > cards.length"
        );

        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerCardsInHand, player);

        TypesToBytes.intToBytes(buffer.offset, uint32(cardCount), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(32);

        for (uint i = 0; i < cardCount; i++) {
            serializeCardInstance(buffer, cards[i]);
        }
    }

    function changePlayerCardsInHand(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards
        ) internal pure {
        changePlayerCardsInHand(self, player, cards, cards.length);
    }

    function changePlayerInitialCardsInHandCount(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerInitialCardsInHandCount, player);

        TypesToBytes.intToBytes(buffer.offset, count, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerMaxCardsInPlay(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerMaxCardsInPlay, player);

        TypesToBytes.intToBytes(buffer.offset, count, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerMaxCardsInHand(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerMaxCardsInHand, player);

        TypesToBytes.intToBytes(buffer.offset, count, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    function changePlayerMaxGooVials(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerializationBuffer memory buffer = self.buffer;
        serializeStartGameStateChangeAction(buffer, ZBEnum.GameStateChangeAction.SetPlayerMaxGooVials, player);

        TypesToBytes.intToBytes(buffer.offset, count, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfInt(8);
    }

    // SerializedCustomUi

    function init(SerializedCustomUi memory self) internal pure {
        init(self, 2 ** 14);
    }

    function init(SerializedCustomUi memory self, uint bufferSize) internal pure {
        self.buffer = SerializationBuffer(new bytes(bufferSize), bufferSize);
    }

    function getBytes(SerializedCustomUi memory self) internal pure returns (bytes) {
        return self.buffer.buffer;
    }

    function add(SerializedCustomUi memory self, ZBGameMode.CustomUiLabel label) internal pure {
        SerializationBuffer memory buffer = self.buffer;

        serializeStartCustomUiElement(buffer, ZBEnum.CustomUiElement.Label, label.rect);

        TypesToBytes.stringToBytes(buffer.offset, bytes(label.text), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfString(label.text);
    }

    function add(SerializedCustomUi memory self, ZBGameMode.CustomUiButton button) internal pure {
        SerializationBuffer memory buffer = self.buffer;

        serializeStartCustomUiElement(buffer, ZBEnum.CustomUiElement.Button, button.rect);

        TypesToBytes.stringToBytes(buffer.offset, bytes(button.title), buffer.buffer);
        buffer.offset -= SizeOf.sizeOfString(button.title);

        TypesToBytes.stringToBytes(buffer.offset, button.onClickCallData, buffer.buffer);
        buffer.offset -= SizeOf.sizeOfString(string(button.onClickCallData));
    }

    function serializeStartCustomUiElement(SerializationBuffer memory self, ZBEnum.CustomUiElement element) private pure {
        TypesToBytes.intToBytes(self.offset, uint32(element), self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
    }

    function serializeStartCustomUiElement(SerializationBuffer memory self, ZBEnum.CustomUiElement element, ZBGameMode.Rect rect) private pure {
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
