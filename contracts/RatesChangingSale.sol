pragma solidity ^0.4.18;

import "./AbstractSale.sol";

contract RatesChangingSale is AbstractSale {
	event RateChange(address token, uint256 rate);
	mapping (address => uint256) rates;

	function getRate(address _token) constant public returns (uint256) {
		return rates[_token];
	}

	function setRate(address _token, uint256 _rate) onlyOwner public {
		rates[_token] = _rate;
		RateChange(_token, _rate);
		if (_rate == 0) {
			RateRemove(_token);
		} else {
			RateAdd(_token);
		}
	}
}
