pragma solidity ^0.4.0;

import "./AbstractSale.sol";

contract BonusChangingSale is AbstractSale {
	event BonusChange(uint256 bonus);
	uint256 public bonus;

	function getBonus(uint256 sold) constant public returns (uint256) {
		return sold.mul(bonus).div(100);
	}

	function setBonus(uint256 _bonus) onlyOwner public {
		bonus = _bonus;
		BonusChange(_bonus);
	}
}
