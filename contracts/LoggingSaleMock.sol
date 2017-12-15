pragma solidity ^0.4.0;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "./OneRateSale.sol";
import "./LoggingSale.sol";


contract LoggingSaleMock is OneRateSale, LoggingSale, OwnableImpl {
    function LoggingSaleMock(address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) public {
    }
}
