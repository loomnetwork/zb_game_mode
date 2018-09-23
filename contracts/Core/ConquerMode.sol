pragma solidity 0.4.24;

import "./ZUBG/ZUBGGameModeContract.sol";
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
        AwardCards,
        PaidOut
    }

    struct UserGame {
        uint status;
        uint gamesCount;
        uint wins;
        uint loses;
    }

    mapping(address => UserGame) public userGames;
    address[] public userAccts; 

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
        values = [1,2,3,4,5,6];
    }

    event UserRegistered(
        address indexed _from
    );
    event MatchFinished(
        address player1Addr,  address player2Addr, uint winner
    );    

    //TODO take payment confirmation
    function RegisterGame(address useraddr) external {
        UserGame storage userS = userGames[useraddr];
        
        userS.status = uint(Stages.Paid);
        
        userAccts.push(useraddr);

        emit UserRegistered(useraddr);
    }   


    function GameStart(address useraddr) external {
    }

    function GameFinished(address player1Addr,  address player2Addr, uint winner ) external  {
        UserGame storage player1 = userGames[player1Addr]; 
        UserGame storage player2 = userGames[player2Addr]; 

        //In theory this should handle mulligans also
        player1.gamesCount += 1;
        player2.gamesCount += 2;
        if (winner == 1) {
            player1.wins += 1;
            player2.loses += 1;
        } else if (winner == 2) {
            player1.loses += 1;
            player2.wins += 1;
        }

        emit MatchFinished(player1Addr, player2Addr, winner);
    }
}
