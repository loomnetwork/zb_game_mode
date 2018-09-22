pragma solidity ^0.4.24;

import "./../../Interfaces/ZUBGGameMode.sol";
//import "./../../Interfaces/ERC721XReceiver.sol";
import "./Enum.sol";

//import "./../../Libraries/ObjectsLib.sol";
import "openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol";


contract ZUBGGameModeContract is ZUBGGameMode, SupportsInterfaceWithLookup {
}
