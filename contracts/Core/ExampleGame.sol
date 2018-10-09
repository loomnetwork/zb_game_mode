pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";
import "./ZB/ZBEnum.sol";
import "./ZBGameModeSerialization.sol";

// ExampleGameMode
contract ExampleGame is ZBGameMode  {
    uint[] values;

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
        ZBGameModeSerialization.GameStateSerializedChanges memory changes;
        changes.init(64);
        changes.changePlayerDefense(0, 5);
        changes.changePlayerDefense(1, 6);
        changes.changePlayerGoo(0, 7);
        changes.changePlayerGoo(1, 8);
        return changes.getBytes();
    }
}
