pragma solidity ^0.4.24;

import "./../../Interfaces/ZBMode.sol";
//import "./../../Interfaces/ERC721XReceiver.sol";
import "./ZBEnum.sol";
import "./../ZBGameModeSerialization.sol";

contract ZBGameMode is ZBMode {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for GameState;

    struct PlayerState {
        uint8 defense;
        uint8 goo;
    }

    struct GameState {
        int64 id;
        uint8 currentPlayerIndex;
        PlayerState[] playerStates;
    }

    struct Vector2Int {
        int32 x;
        int32 y;
    }

    struct Rect {
        Vector2Int position;
        Vector2Int size;
    }

    event MatchedStarted(
        address indexed _from
    );
    event MatchFinished(
        address player1Addr,  address player2Addr, uint winner
    );
    event AwardTokens(
        address indexed to,
        uint tokens
    );
    //Awards a specific Card
    event AwardCard(
        address indexed to,
        uint cardID
    );
    event AwardPack(
        address indexed to,
        uint packCount,
        uint packType
    );
    event UserRegistered(
        address indexed _from
    );

    function onMatchStarting(bytes) public pure returns (bytes) {
        return new bytes(0);
    }

    function getCustomUi() public view returns (bytes) {
        return new bytes(0);
    }
}
