pragma solidity 0.4.24;

import "./ZUBG/ZUBGGameModeContract.sol";
import "./ZUBG/Enum.sol";

// ExampleGameMode
contract ExampleGame is ZUBGGameMode  {

    function name() external view returns (string) {
        return "ExampleGame";
    }

    function GameStart() external returns (uint) {
        return uint(ZUBGEnum.AbilityCall.Attack);
    }
}
