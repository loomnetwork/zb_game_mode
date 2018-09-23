pragma solidity 0.4.24;

import "./ZUBG/ZUBGGameMode.sol";
import "./ZUBG/Enum.sol";


contract ConquerMode is ZUBGGameMode  {
    uint[] values;

    enum Stages {
        Paid,
        Playing,
        Finished
    }

    enum PaymentState {
        None,
        ReturnPayment,
        AwardCards
    }

    struct UserGame {
        uint status;
        uint gamesCount;
        uint wins;
        uint loses;
    }

    mapping(address => UserGame) public userGames;
    address[] public userAccts; 

    uint public costToEnter = 25; //TODO lets make this configurable

    function activeUsers()  view public returns (uint) {
        return  userAccts.length;
    }

    //TODO figure out how to get structs back to the javascript
    function Wins(address useraddr)  view public returns (uint) {
        UserGame storage userS = userGames[useraddr];
        return userS.wins;
    }
    function Loses(address useraddr)  view public returns (uint) {
        UserGame storage userS = userGames[useraddr];
        return userS.loses;
    }

    function Status(address useraddr)  view public returns (uint) {
        UserGame storage userS = userGames[useraddr];
        return userS.status;
    }

    function name() external view returns (string) {
        return  "ConquerMode";
    }

    constructor() public {
    }

    //TODO take payment confirmation
    function RegisterGame(address useraddr) external {
        UserGame storage userS = userGames[useraddr];
        
        userS.status = uint(Stages.Paid);
        
        userAccts.push(useraddr);

        emit ZUBGGameMode.UserRegistered(useraddr);
    }   

    function GameStart(address useraddr1, address useraddr2) external {
        UserGame storage player1 = userGames[useraddr1];
        UserGame storage player2 = userGames[useraddr2];
        
        assert(player1.status != uint(Stages.Finished));
        assert(player2.status != uint(Stages.Finished));

        player1.status = uint(Stages.Playing);
        player2.status = uint(Stages.Playing);

        emit ZUBGGameMode.MatchedStarted(useraddr1);
        emit ZUBGGameMode.MatchedStarted(useraddr2);
    }

    //TODO should we break this into two events, 1 per player?
    function GameFinished(address player1Addr,  address player2Addr, uint winner ) external  {
        UserGame storage player1 = userGames[player1Addr]; 
        UserGame storage player2 = userGames[player2Addr]; 

        //Yikes ! prevent from double awarding or anything funny
        assert(player1.status != uint(Stages.Finished));
        assert(player2.status != uint(Stages.Finished));

        //In theory this should handle mulligans also
        player1.gamesCount += 1;
        player2.gamesCount += 2;
        if (winner == 1) {
            player1.wins += 1;
            player2.loses += 1;

            //TODO perhaps switch this to a state machine
            if(player1.wins == 7){
                emit ZUBGGameMode.AwardTokens(player1Addr, costToEnter);
            }
            if(player1.wins == 12){
                emit ZUBGGameMode.AwardPack(player1Addr, 1, 0);
                player1.status = uint(Stages.Finished);
            }
            if(player2.loses == 3){
                player2.status = uint(Stages.Finished);
            }            
        } else if (winner == 2) {
            player1.loses += 1;
            player2.wins += 1;

            //TODO perhaps switch this to a state machine
            if(player2.wins == 7){
                emit ZUBGGameMode.AwardTokens(player2Addr, costToEnter);
            }
            if(player2.wins == 12){
                emit ZUBGGameMode.AwardPack(player2Addr, 1, 0);
                player1.status = uint(Stages.Finished);
            }
            if(player1.loses == 3){
                player1.status = uint(Stages.Finished);
            }
        }

        emit ZUBGGameMode.MatchFinished(player1Addr, player2Addr, winner);
    }
}
