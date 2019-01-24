pragma solidity ^0.5.0;

import "./AbstractSale.sol";

contract BonusChangingSale is AbstractSale {
	event BonusChange(uint256 bonus);
	uint256 public bonus;

	function getBonus(uint256 sold) view public returns (uint256) {
		return sold.mul(bonus).div(100);
	}

	function setBonus(uint256 _bonus) onlyOwner public {
		bonus = _bonus;
		emit BonusChange(_bonus);
	}
}
