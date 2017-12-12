pragma solidity ^0.4.18;


contract Sale {
    event Purchase(address indexed buyer, address token, uint256 value, uint256 amount);
    event RateAdd(address token);
    event RateRemove(address token);

    function getRate(address _token) constant public returns (uint256);
    function getBonus() constant public returns (uint256);
}
