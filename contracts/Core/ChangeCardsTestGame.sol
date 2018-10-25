pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ChangeCardsTestGame is ZBGameMode  {
    using ZBSerializer for CardInstance;

    function afterInitialDraw(bytes serializedGameState) external {
        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                gameState.playerStates[i].cardsInDeck[j].changeMouldName(i == 0 ? "Pyromaz" : "Fire-Maw");
            }

            for (j = 0; j < gameState.playerStates[i].cardsInHand.length; j++) {
                gameState.playerStates[i].cardsInHand[j].changeMouldName(i == 0 ? "Zhampion" : "Gargantua");
                gameState.playerStates[i].cardsInHand[j].changeDefense(i == 0 ? 3 : 4);
                gameState.playerStates[i].cardsInHand[j].changeAttack(i == 0 ? 1 : 2);
                gameState.playerStates[i].cardsInHand[j].changeGooCost(i == 0 ? 1 : 3);
            }

            changes.changePlayerCardsInDeck(Player(i), gameState.playerStates[i].cardsInDeck);
            changes.changePlayerCardsInHand(Player(i), gameState.playerStates[i].cardsInHand);
        }

        changes.changePlayerTurnTime(Player.Player1, 4);
        changes.changePlayerTurnTime(Player.Player2, 30);

        changes.emit();
    }
}
