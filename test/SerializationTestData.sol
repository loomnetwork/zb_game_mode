pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZBSerializer.sol";
import "../contracts/3rdParty/Seriality/BytesToTypes.sol";
import "../contracts/3rdParty/Seriality/SizeOf.sol";
import "../contracts/3rdParty/Seriality/TypesToBytes.sol";

contract SerializationTestData {
    using ZBSerializer for ZBSerializer.SerializedGameStateChanges;
    using ZBSerializer for ZBSerializer.SerializedCustomUi;
    using ZBSerializer for ZBGameMode.GameState;

    event GameStateChanges (
        bytes serializedChanges
    );

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

    function serializeGameStateChangeActions() public {
        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init(96);
        changes.changePlayerDefense(ZBGameMode.Player.Player1, 5);
        changes.changePlayerDefense(ZBGameMode.Player.Player2, 6);
        changes.changePlayerCurrentGooVials(ZBGameMode.Player.Player1, 5);
        changes.changePlayerCurrentGooVials(ZBGameMode.Player.Player2, 8);
        changes.changePlayerCurrentGoo(ZBGameMode.Player.Player1, 2);
        changes.changePlayerCurrentGoo(ZBGameMode.Player.Player2, 6);
        changes.emit();
    }

    function serializeGameStateChangePlayerCardsInHand() public pure returns (bytes) {
        ZBGameMode.CardInstance[] memory cards = new ZBGameMode.CardInstance[](2);
        cards[0].instanceId = 2;
        cards[0].mouldName = "Zhampion";
        cards[0].defense = 4;
        cards[0].attack = 5;
        cards[0].gooCost = 6;

        cards[0].instanceId = 3;
        cards[0].mouldName = "Fire-maw";
        cards[0].defense = 7;
        cards[0].attack = 8;
        cards[0].gooCost = 9;

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init(512);

        changes.changePlayerCardsInHand(ZBGameMode.Player.Player1, cards);
        changes.changePlayerCardsInHand(ZBGameMode.Player.Player2, cards);
        return changes.getBytes();
    }

    function serializeCustomUi() public pure returns (bytes) {
        ZBSerializer.SerializedCustomUi memory customUi;
        customUi.init(256);
        customUi.add(
            ZBGameMode.CustomUiLabel({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 25,
                        y: 230
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 200,
                        y: 150
                    })
                }),
                text: "Some Very Cool text!"
            })
        );

        customUi.add(
            ZBGameMode.CustomUiButton({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 675,
                        y: 300
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 300,
                        y: 150
                    })
                }),
                title: "Click Me",
                onClickCallData: new bytes(0)
            })
        );
        return customUi.getBytes();
    }
}