pragma solidity ^0.4.24;

//import "./../../Interfaces/ERC721XReceiver.sol";
import "./ZBEnum.sol";
import "./../ZBGameModeSerialization.sol";

contract ZBGameMode {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for GameState;

    enum Player {
        Player1,
        Player2
    }

    struct PlayerState {
        string id;
        //PlayerActionType currentAction = 2;
        //OverlordInstance overlordInstance = 3;
        CardInstance[] cardsInHand;
        //CardInstance[] CardsInPlay;
        CardInstance[] cardsInDeck;
        Deck deck;
        uint8 defense;
        uint8 currentGoo;
        uint8 gooVials;
        //bool hasDrawnCard = 11;
        //repeated CardInstance cardsInGraveyard = 12;
        uint8 initialCardsInHandCount;
        uint8 maxCardsInPlay;
        uint8 maxCardsInHand;
        uint8 maxGooVials;
    }

    struct Deck {
        int64 id;
        string name;
        int64 heroId;
    }

    struct CardPrototype {
        string name;
        uint8 gooCost;
    }

    struct CardInstance {
        int32 instanceId;
        CardPrototype prototype;
        int32 defense;
        int32 attack;
        string owner;
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

    struct CustomUiLabel {
        Rect rect;
        string text;
    }

    struct CustomUiButton {
        Rect rect;
        string title;
        bytes onClickCallData;
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

    function name() public view returns (string);

    function onMatchStartingBeforeInitialDraw(bytes) public pure returns (bytes) {
        return new bytes(0);
    }

    function onMatchStartingAfterInitialDraw(bytes) external pure returns (bytes) {
        return new bytes(0);
    }

    function getCustomUi() public view returns (bytes) {
        return new bytes(0);
    }
}
