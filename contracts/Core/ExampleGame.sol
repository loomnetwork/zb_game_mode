pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";
import "./ZB/ZBEnum.sol";
import "./ZBGameModeSerialization.sol";

// ExampleGameMode
contract ExampleGame is ZBGameMode  {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedCustomUi;
    using ZBGameModeSerialization for ZBGameMode.GameState;

    uint counter = 0;

    function name() public view returns (string) {
        return  "ExampleGame";
    }

    function onMatchStartingBeforeInitialDraw(bytes) public pure returns (bytes) {
        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(2 ** 15);
        changes.changePlayerInitialCardsInHandCount(Player.Player1, 2);
        changes.changePlayerInitialCardsInHandCount(Player.Player2, 2);

        return changes.getBytes();
    }

    function onMatchStartingAfterInitialDraw(bytes serializedGameState) external pure returns(bytes) {
        GameState memory gameState;
        gameState.initWithSerializedData(serializedGameState);

        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(2 ** 15);

        changes.changePlayerDefense(Player.Player1, 5);
        changes.changePlayerDefense(Player.Player2, 6);
        changes.changePlayerGooVials(Player.Player1, 5);
        changes.changePlayerGooVials(Player.Player2, 8);
        changes.changePlayerCurrentGoo(Player.Player1, 2);
        changes.changePlayerCurrentGoo(Player.Player2, 6);
        changes.changePlayerMaxGooVials(Player.Player1, 2);
        changes.changePlayerMaxGooVials(Player.Player2, 2);

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            for (uint j = 0; j < gameState.playerStates[i].cardsInHand.length; j++) {
                gameState.playerStates[i].cardsInHand[j].prototype.name = "Zhampion";
            }

            for (j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                gameState.playerStates[i].cardsInDeck[j].prototype.name = "Pyromaz";
            }
        }

        changes.changePlayerCardsInHand(Player.Player1, gameState.playerStates[0].cardsInHand);
        changes.changePlayerCardsInHand(Player.Player2, gameState.playerStates[1].cardsInHand);
        changes.changePlayerCardsInDeck(Player.Player1, gameState.playerStates[0].cardsInDeck);
        changes.changePlayerCardsInDeck(Player.Player2, gameState.playerStates[1].cardsInDeck);

        return changes.getBytes();
    }

    function getCustomUi() public view returns (bytes) {
        ZBGameModeSerialization.SerializedCustomUi memory customUi;
        customUi.init();
        customUi.add(
            ZBGameMode.CustomUiLabel({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 25,
                        y: 300
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 300,
                        y: 150
                    })
                }),
                text: "Counter Value: "
            })
        );
        customUi.add(
            ZBGameMode.CustomUiLabel({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 325,
                        y: 300
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 300,
                        y: 150
                    })
                }),
                text: uint2str(counter)
            })
        );
        customUi.add(
            ZBGameMode.CustomUiButton({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 325,
                        y: 30
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 300,
                        y: 150
                    })
                }),
                title: "+1",
                onClickCallData: abi.encodeWithSignature("incrementCounter()")
            })
        );
        customUi.add(
            ZBGameMode.CustomUiButton({
                rect: ZBGameMode.Rect({
                    position: ZBGameMode.Vector2Int ({
                        x: 675,
                        y: 30
                    }),
                    size: ZBGameMode.Vector2Int ({
                        x: 300,
                        y: 150
                    })
                }),
                title: "+3",
                onClickCallData: abi.encodeWithSignature("incrementCounter(int32)", int32(3))
            })
        );

        return customUi.getBytes();
    }

    function incrementCounter() public {
        counter++;
    }

    function incrementCounter(int32 val) public {
        counter += uint(val);
    }

    function uint2str(uint val) internal pure returns (string) {
        uint i = val;
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
}
