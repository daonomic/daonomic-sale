pragma solidity ^0.4.21;
pragma experimental ABIEncoderV2;

import "./AbstractSale.sol";

contract RatesChangingSale is AbstractSale {
	event RateChange(address token, uint256 rate);
	event XPubChange(address token, string xpub);
	mapping(address => uint256) rates;
	mapping(address => string) xpubs;

	struct Rate {
		address token;
		uint256 rate;
		string xpub;
	}

	function getRate(address _token) constant public returns (uint256) {
		return rates[_token];
	}

	function setRate(address _token, uint256 _rate, string _xpub) onlyOwner public {
		rates[_token] = _rate;
		emit RateChange(_token, _rate);
		if (_rate == 0) {
			emit RateRemove(_token);
		} else {
			emit RateAdd(_token);
		}
		setXPub(_token, _xpub);
	}

	function setRates(Rate[] _rates) onlyOwner public {
		for (uint i = 0; i < _rates.length; i++) {
			setRate(_rates[i].token, _rates[i].rate, _rates[i].xpub);
		}
	}

	function setXPub(address _token, string _xpub) internal {
		xpubs[_token] = _xpub;
		emit XPubChange(_token, _xpub);
	}

	function getXPub(address token) constant public returns (string) {
		return xpubs[token];
	}
}
