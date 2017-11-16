pragma solidity ^0.4.18;


contract Sale {
    event BonusChange(uint256 bonus);
    event RateChange(address token, uint256 rate);
    event Purchase(address indexed buyer, address token, uint256 value, uint256 amount);
}
