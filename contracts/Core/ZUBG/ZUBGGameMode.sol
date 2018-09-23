pragma solidity ^0.4.24;

import "./../../Interfaces/ZUBGGameMode.sol";
//import "./../../Interfaces/ERC721XReceiver.sol";
import "./Enum.sol";

import "openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol";


contract ZUBGGameMode is ZUBGMode, SupportsInterfaceWithLookup {
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
}
