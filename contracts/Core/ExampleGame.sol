pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";
import "./ZB/ZBEnum.sol";

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

    function onMatchStarting(bytes gameState) public returns(bytes) {
        bytes memory buffer = new bytes(64);
        uint offset = buffer.length;
        offset = changePlayerDefense(buffer, offset, 0, 5);
        offset = changePlayerDefense(buffer, offset, 1, 6);
        offset = changePlayerGoo(buffer, offset, 0, 7);
        offset = changePlayerGoo(buffer, offset, 1, 8);
        return buffer;
    }
}
