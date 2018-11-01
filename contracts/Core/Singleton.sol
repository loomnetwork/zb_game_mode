pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract Singleton is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            CardInstance[] memory newCards = new CardInstance[](gameState.playerStates[i].cardsInDeck.length);
            uint cardCount = 0;

            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                bool cardAlreadyInDeck = false;

                for (uint k = 0; k < cardCount; k++) {
                    if (keccak256(abi.encodePacked(newCards[k].mouldName)) == keccak256(abi.encodePacked(gameState.playerStates[i].cardsInDeck[j].mouldName))) {
                        cardAlreadyInDeck = true;
                    }
                }

                if (!cardAlreadyInDeck) {
                    newCards[cardCount] = gameState.playerStates[i].cardsInDeck[j];
                    cardCount++;
                }

            }

            changes.changePlayerCardsInDeck(Player(i), newCards, cardCount);
        }

        changes.emit();

    }

}

