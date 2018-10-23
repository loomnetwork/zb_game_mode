pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ChangeCardsTestGame is ZBGameMode  {
    function afterInitialDraw(bytes serializedGameState) external {
        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                gameState.playerStates[i].cardsInDeck[j].prototype.name = i == 0 ? "Pyromaz" : "Fire-Maw";
            }

            for (j = 0; j < gameState.playerStates[i].cardsInHand.length; j++) {
                gameState.playerStates[i].cardsInHand[j].prototype.name = i == 0 ? "Zhampion" : "Gargantua";
            }

            changes.changePlayerCardsInDeck(Player(i), gameState.playerStates[i].cardsInDeck);
            changes.changePlayerCardsInHand(Player(i), gameState.playerStates[i].cardsInHand);
        }

        changes.emit();
    }
}
