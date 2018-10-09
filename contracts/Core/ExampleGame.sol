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

    function onMatchStarting(bytes) public pure returns(bytes) {
        ZBGameModeSerialization.SerializedGameStateChanges memory changes;
        changes.init(64);
        changes.changePlayerDefense(0, 5);
        changes.changePlayerDefense(1, 6);
        changes.changePlayerGoo(0, 7);
        changes.changePlayerGoo(1, 8);
        return changes.getBytes();
    }

    function getCustomUi() public view returns (bytes) {
        ZBGameModeSerialization.SerializedCustomUi memory customUi;
        customUi.init(1024);
        customUi.addLabel(
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
        customUi.addButton(
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
        customUi.addButton(
            ZBGameMode.Rect({
                position: ZBGameMode.Vector2Int ({
                    x: 300,
                    y: 30
                }),
                size: ZBGameMode.Vector2Int ({
                    x: 200,
                    y: 150
                })
            }),
            uint2str(counter),
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
