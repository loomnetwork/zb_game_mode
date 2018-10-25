pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZB/ZBSerializer.sol";
import "../contracts/Core/ZB/SerialityBinaryStream.sol";

contract SerializationTestData {
    using ZBSerializer for ZBSerializer.SerializedGameStateChanges;
    using ZBSerializer for ZBSerializer.SerializedCustomUi;
    using ZBSerializer for ZBGameMode.GameState;
    using SerialityBinaryStream for SerialityBinaryStream.BinaryStream;

    event GameStateChanges (
        bytes serializedChanges
    );

    function serializeInts() public pure returns (bytes) {
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(new bytes(64), 64);

        stream.writeInt8(int8(1));
        stream.writeInt32(int32(3));
        stream.writeInt64(int64(4));

        return stream.buffer;
    }

    function serializeShortString() public pure returns (bytes) {
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(new bytes(256), 256);

        stream.writeString("Cool Button");
        return stream.buffer;
    }

    function serializeLongString() public pure returns (bytes) {
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(new bytes(256), 256);

        stream.writeString("Cool Button 1 Cool Button 2 Cool Button 3 Cool Button 4 Cool Button 5 Cool Button 6 Cool Button 7 Cool Button 8 Cool Button 9 Cool Button 0");
        return stream.buffer;
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