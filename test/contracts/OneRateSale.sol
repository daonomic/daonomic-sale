pragma solidity ^0.4.0;


import "../../contracts/AbstractSale.sol";


contract OneRateSale is AbstractSale {
    address public token;
    uint256 public rate;
    uint256 public bonus;

    function OneRateSale(address _token, uint256 _rate, uint256 _bonus) public {
        token = _token;
        rate = _rate;
        bonus = _bonus;
        RateAdd(_token);
    }

    function getRate(address _token) constant public returns (uint256) {
        if (_token == token) {
            return rate;
        } else {
            return 0;
        }
    }

    function getBonus() constant public returns (uint256) {
        return bonus;
    }
}
