pragma solidity ^0.4.24;

import "./ZBEnum.sol";
import "./ZBSerializer.sol";

contract ZBGameMode {
    using ZBSerializer for ZBSerializer.SerializedGameStateChanges;
    using ZBSerializer for GameState;

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
        uint32 turnTime;
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

    struct CardInstance {
        int32 instanceId;
        string mouldName;
        int32 defense;
        bool defenseInherited;
        int32 attack;
        bool attackInherited;
        int32 gooCost;
        bool gooCostInherited;
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

    event GameStateChanges (
        bytes serializedChanges
    );

    function getInterfaceVersion() external pure returns (int) {
        return 1;
    }

    function getDataStructureVersion() external pure returns (int) {
        return 1;
    }

    function beforeMatchStart(bytes) external {
    }

    function afterInitialDraw(bytes) external {
    }

    function getCustomUi() external view returns (bytes) {
        return new bytes(0);
    }
}
