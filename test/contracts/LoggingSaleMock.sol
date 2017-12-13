pragma solidity ^0.4.0;


import "./OneRateSale.sol";
import "../../contracts/LoggingSale.sol";


contract LoggingSaleMock is OneRateSale, LoggingSale {
    function LoggingSaleMock(address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) public {
    }
}
