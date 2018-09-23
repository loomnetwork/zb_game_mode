//THIS FILE IS AUTO GENERATED IN THE GAMECHAIN REPO
//TO MAKE CHANGES YOU NEED TO EDIT THE GAMECHAIN REPO 

pragma solidity ^0.4.24;

contract ZUBGEnum {


    enum AbilityActivity  {Passive,Active}
    AbilityActivity activity;

    enum AbilityCall  {Turn,Entry,End,Attack,Death,Permanent,GotDamage,AtDefence,InHand}
    AbilityCall call;
 

    enum ActionPlayer  {Startgame,Endturn,Drawcardplayer,Playcard,Cardattack,Usecardability}
    ActionPlayer player;
 

    enum StaticGameConfig  {None,Health,Customdeck,Addcard,Setdeck}
    StaticGameConfig gameconfig;
}