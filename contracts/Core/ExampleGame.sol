pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

// ExampleGameMode
contract ExampleGame is ZBGameMode  {

    mapping (string => bool) internal bannedCards;

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        initializeDeckRules();

        // Tweak some initial starting values
        changes.changePlayerDefense(Player.Player1, 15);
        changes.changePlayerDefense(Player.Player2, 15);
        changes.changePlayerCurrentGooVials(Player.Player1, 5);
        changes.changePlayerCurrentGooVials(Player.Player2, 5);
        changes.changePlayerCurrentGoo(Player.Player1, 5);
        changes.changePlayerCurrentGoo(Player.Player2, 5);
        changes.changePlayerMaxGooVials(Player.Player1, 8);
        changes.changePlayerMaxGooVials(Player.Player2, 8);

        // Go through each player's deck and modify it to remove banned cards
        for (uint i = 0; i < gameState.playerStates.length; i++) {
            uint totalCount = 0;
            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                if (!isBanned(gameState.playerStates[i].cardsInDeck[j].prototype.name)) {
                    totalCount++;
                }
            }

            CardInstance[] memory newCards = new CardInstance[](totalCount);
            uint count = 0;
            for (j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                if (!isBanned(gameState.playerStates[i].cardsInDeck[j].prototype.name)) {
                    newCards[count] = gameState.playerStates[i].cardsInDeck[j];
                    count++;
                }
            }
            changes.changePlayerCardsInDeck(Player(i), newCards);
        }

        changes.emit();
    }

    // Initialize banned cards. This could also be implemented as `allowedCards`, if the list of allowed
    // cards is shorter than the list of banned cards.
    function initializeDeckRules() internal {
        bannedCards["Stapler"] = true;
        bannedCards["Nail Bomb"] = true;
        bannedCards["Stapler"] = true;
        bannedCards["Fresh Meat"] = true;
        bannedCards["Chainsaw"] = true;
        bannedCards["Fresh Meat"] = true;
    }

    // Checks if a card is banned
    function isBanned(string cardName) internal view returns(bool) {
        if (bannedCards[cardName]) return true;
    }
}
