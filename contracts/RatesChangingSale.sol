pragma experimental ABIEncoderV2;
pragma solidity ^0.4.21;

import "./AbstractSale.sol";

contract RatesChangingSale is AbstractSale {
	event RateChange(address token, uint256 rate);
	mapping(address => uint256) rates;

	struct Rate {
		address token;
		uint256 rate;
	}

	function getRate(address _token) constant public returns (uint256) {
		return rates[_token];
	}

	function setRate(address _token, uint256 _rate) onlyOwner public {
		rates[_token] = _rate;
		emit RateChange(_token, _rate);
		if (_rate == 0) {
			emit RateRemove(_token);
		} else {
			emit RateAdd(_token);
		}
	}

	function setRates(Rate[] _rates) onlyOwner public {
		for (uint i = 0; i < _rates.length; i++) {
			setRate(_rates[i].token, _rates[i].rate);
		}
	}
}
