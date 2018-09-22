pragma solidity 0.4.24;

import "./ZUBG/ZUBGGameModeContract.sol";

// ExampleGameMode
contract ExampleGame is ZUBGGameMode  {

    function name() external view returns (string) {
        return "ExampleGame";
    }

    function GameStart() external {
    }
}
