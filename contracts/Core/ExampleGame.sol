pragma solidity 0.4.24;

import "./ZUBG/ZUBGGameModeContract.sol";
import "./ZUBG/Enum.sol";

// ExampleGameMode
contract ExampleGame is ZUBGGameMode  {
    uint[] values;

    function name() external view returns (string) {
        return  "ExampleGame";
    }

    constructor() public {
        values = [1,2,3,4,5,6];
    }

    function GameStart() external pure returns (uint) {
        return uint(ZUBGEnum.AbilityCall.Attack);
    }

    function countOdds(uint[] v) internal pure returns(uint) {
        uint counter = 0;
        for (uint i = 0; i < v.length; i++) {
            if (v[i] % 2 != 0) {
                counter++;   
            }
        }

        return counter;
    }

    function getOdds() public view returns(uint[], uint[]) {
        uint[] memory v = new uint[](countOdds(values));
        uint[] memory b = new uint[](countOdds(values));
        uint counter = 0;
        for (uint i = 0;i < values.length; i++) {
            if (values[i] % 2 != 0) {
                v[counter] = values[i];
                b[counter] = 2;
                counter++;
            }
        }

        return (v, b);

    }
}
