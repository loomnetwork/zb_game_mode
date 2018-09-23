pragma solidity ^0.4.24;

import "./../../Interfaces/ZUBGGameMode.sol";
//import "./../../Interfaces/ERC721XReceiver.sol";
import "./Enum.sol";

import "openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol";


contract ZUBGGameMode is ZUBGMode, SupportsInterfaceWithLookup, ZUBGEnum {
    //define properties of the game
    uint[] staticConfigs;
    uint[] staticConfigValues;
uint[] values;

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


    function countConfigs(uint[] v) internal pure returns(uint) {
        uint counter = 0;
        for (uint i = 0; i < v.length; i++) {
            if (v[i] % 2 != 0) {
                counter++;   
            }
        }

        return counter;
    }

    function getStaticConfigs() public view returns(uint[], uint[]) {
        uint[] memory v = new uint[](staticConfigs.length);
        uint[] memory b = new uint[](staticConfigValues.length);
        for (uint i = 0;i < staticConfigs.length; i++) {
            v[i] = staticConfigs[i];
            b[i] = staticConfigValues[i];
        }

        return (v, b);
    }
}
