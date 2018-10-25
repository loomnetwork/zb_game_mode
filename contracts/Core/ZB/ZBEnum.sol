//THIS FILE IS AUTO GENERATED IN THE GAMECHAIN REPO
//TO MAKE CHANGES YOU NEED TO EDIT THE GAMECHAIN REPO

pragma solidity ^0.4.24;

library ZBEnum {

    enum AbilityActivityType
    {
            PASSIVE,
            ACTIVE
    }

    enum AbilityCallType
    {
            TURN,
            ENTRY,
            END,
            ATTACK,
            DEATH,
            PERMANENT,
            GOT_DAMAGE,
            AT_DEFENCE,
            IN_HAND
    }

    enum PlayerAction
    {
            StartGame,
            EndTurn,
            DrawCardPlayer,
            PlayCard,
            CardAttack,
            UseCardAbility
    }

    enum GameStateChangeAction
    {
            None,
            SetPlayerDefense,
            SetPlayerCurrentGoo,
            SetPlayerGooVials,
            SetPlayerCardsInDeck,
            SetPlayerCardsInHand,
            SetPlayerInitialCardsInHandCount,
            SetPlayerMaxCardsInPlay,
            SetPlayerMaxCardsInHand,
            SetPlayerMaxGooVials,
            SetPlayerTurnTime
    }

    enum CustomUiElement
    {
            None,
            Label,
            Button
    }

}