pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";
import "./ZB/ZBEnum.sol";


contract ConquerMode is ZBGameMode  {
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

    constructor() public {

    }

    //TODO take payment confirmation, with the ticketID and r,s,v
    //TODO         onlyWithThreshold(createMessage(keccak256(abi.encodePacked("mint", _tokenId, _tokenDNA))), _v, _r, _s)
    function RegisterGame(address useraddr, uint256 ticketId, uint256 gameId,  uint8[] _v,  bytes32[] _r, bytes32[] _s) external {
        UserGame storage userS = userGames[useraddr];
        assert(gameId == 1); //make sure you cant use tickets from other games, we may use the public address in future

        userS.status = uint(Stages.Paid);

        userAccts.push(useraddr);

        //TODO make sure ticket is only used once

        emit UserRegistered(useraddr);
    }

    function GameStart(address useraddr1, address useraddr2) external {
        UserGame storage player1 = userGames[useraddr1];
        UserGame storage player2 = userGames[useraddr2];

        assert(player1.status != uint(Stages.Finished));
        assert(player2.status != uint(Stages.Finished));

        player1.status = uint(Stages.Playing);
        player2.status = uint(Stages.Playing);

        emit MatchedStarted(useraddr1);
        emit MatchedStarted(useraddr2);
    }

    //TODO should we break this into two events, 1 per player?
    function GameFinished(address player1Addr,  address player2Addr, uint winner ) external  {
        uint player1Wins = 3;
        uint player2Wins = 3;

        if(winner == 1) {
            player1Wins = 1;
            player2Wins = 0;
        } else if(winner == 2) {
            player1Wins = 0;
            player2Wins = 1;
        }

        gameFinishedPlayer(player1Addr, player1Wins);
        gameFinishedPlayer(player2Addr, player2Wins);

        emit MatchFinished(player1Addr, player2Addr, winner);
    }

    // winner 0, for lose, 1 for win, 2 for muligan
    function gameFinishedPlayer(address playerAddr, uint winner) private {
        UserGame storage player = userGames[playerAddr];

        //Yikes ! prevent from double awarding or anything funny
        assert(player.status != uint(Stages.Finished));

        //In theory this should handle mulligans also
        player.gamesCount += 1;
        if (winner == 1) {
            player.wins += 1;

            //TODO perhaps switch this to a state machine
            if(player.wins == 7){
                emit AwardTokens(playerAddr, costToEnter);
            }
            if(player.wins == 12){
                emit AwardPack(playerAddr, 1, 0);
                player.status = uint(Stages.Finished);
            }
        } else if (winner == 0) {
            player.loses += 1;

            if(player.loses == 3){
                player.status = uint(Stages.Finished);
            }
        }
    }
}
