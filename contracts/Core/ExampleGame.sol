pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";
import "./ZB/ZBEnum.sol";
import "./ZBGameModeSerialization.sol";

// ExampleGameMode
contract ExampleGame is ZBGameMode  {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedCustomUi;
    using ZBGameModeSerialization for ZBGameMode.GameState;

    uint[] values;

    uint counter = 0;

    function name() external view returns (string) {
        return  "ExampleGame";
    }

    constructor() public {
        values = [1,2,3,4,5,6];
    }

    function GameStart() external pure returns (uint) {
        return uint(ZBEnum.AbilityCallType.ATTACK);
    }

    function triggerMemoryLeak() public pure returns(bytes) {
        return new bytes(25000);
    }

    function onMatchStarting(bytes serializedGameState) public pure returns(bytes) {
        GameState memory gameState;
        gameState.initWithSerializedData(serializedGameState);

        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(8192);
        changes.changePlayerDefense(0, 5);
        changes.changePlayerDefense(1, 6);
        changes.changePlayerGoo(0, 7);
        changes.changePlayerGoo(1, 8);

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            for (uint j = 0; j < gameState.playerStates[i].deck.cards.length; j++) {
                //gameState.playerStates[i].deck.cards[j].name = "Zhampion";
            }
        }

        //changes.changePlayerDeckCards(0, gameState.playerStates[0].deck.cards);
        //changes.changePlayerDeckCards(1, gameState.playerStates[1].deck.cards);

        return changes.getBytes();
    }

    function getCustomUi() public view returns (bytes) {
        ZBGameModeSerialization.SerializedCustomUi memory customUi;
        customUi.init(1024);
        customUi.label(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 25,
                    y: 300
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 300,
                    y: 150
                })
            }),
            "Counter Value: "
        );
        customUi.label(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 325,
                    y: 300
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 300,
                    y: 150
                })
            }),
            uint2str(counter)
        );
        customUi.button(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 25,
                    y: 30
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 500,
                    y: 200
                })
            }),
            "Click Me",
            "someFunction"
        );
        customUi.button(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 620,
                    y: 30
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 300,
                    y: 200
                })
            }),
            "+1",
            "incrementCounter"
        );
        return customUi.getBytes();
    }

    function incrementCounter() public {
        counter++;
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
