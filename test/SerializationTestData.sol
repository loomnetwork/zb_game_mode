pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";
import "../contracts/3rdParty/Seriality/BytesToTypes.sol";
import "../contracts/3rdParty/Seriality/SizeOf.sol";
import "../contracts/3rdParty/Seriality/TypesToBytes.sol";

contract SerializationTestData {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedCustomUi;
    using ZBGameModeSerialization for ZBGameMode.GameState;

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

    function serializeShortString() public pure returns (bytes) {
        bytes memory buffer = new bytes(256);
        uint offset = 256;
        string memory text = "Cool Button";
        TypesToBytes.stringToBytes(offset, bytes(text), buffer);
        offset -= SizeOf.sizeOfString(text);
        return buffer;
    }

    function serializeLongString() public pure returns (bytes) {
        bytes memory buffer = new bytes(256);
        uint offset = 256;
        string memory text = "Cool Button 1 Cool Button 2 Cool Button 3 Cool Button 4 Cool Button 5 Cool Button 6 Cool Button 7 Cool Button 8 Cool Button 9 Cool Button 0";
        TypesToBytes.stringToBytes(offset, bytes(text), buffer);
        offset -= SizeOf.sizeOfString(text);
        return buffer;
    }

    function serializeGameStateChangeActions() public pure returns (bytes) {
        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(64);
        changes.changePlayerDefense(0, 5);
        changes.changePlayerDefense(1, 6);
        changes.changePlayerGoo(0, 7);
        changes.changePlayerGoo(1, 8);
        return changes.getBytes();
    }

    function serializeGameStateChangePlayerDeckCards() public pure returns (bytes) {
        ZBGameMode.CollectionCard[] memory cards = new ZBGameMode.CollectionCard[](2);
        cards[0].name = "Zhampion";
        cards[0].amount = 3;
        cards[1].name = "Germs";
        cards[1].amount = 4;

        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(512);

        changes.changePlayerDeckCards(0, cards);
        changes.changePlayerDeckCards(1, cards);
        return changes.getBytes();
    }

    function serializeCustomUi() public pure returns (bytes) {
        ZBGameModeSerialization.SerializedCustomUi memory customUi;
        customUi.init(256);
        customUi.label(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 25,
                    y: 230
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 200,
                    y: 150
                })
            }),
            "Some Very Cool text!"
        );
        customUi.button(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 25,
                    y: 30
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 200,
                    y: 150
                })
            }),
            "Click Me",
            "someFunction"
        );
        return customUi.getBytes();
    }
}