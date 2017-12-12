pragma solidity ^0.4.0;


import "./AbstractSale.sol";


contract ChangingSale is AbstractSale {

    event RateChange(address token, uint256 rate);
    event BonusChange(uint256 bonus);

    mapping (address => uint256) rates;
    uint256 public bonus;

    function getRate(address _token) constant public returns (uint256) {
        return rates[_token];
    }

    function setRate(address _token, uint256 _rate) onlyOwner public {
        rates[_token] = _rate;
        RateChange(_token, _rate);
    }

    function getBonus() constant public returns (uint256) {
        return bonus;
    }

    function setBonus(uint256 _bonus) onlyOwner public {
        bonus = _bonus;
        BonusChange(_bonus);
    }
}
