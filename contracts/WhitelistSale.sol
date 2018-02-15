pragma solidity ^0.4.18;

import "./AbstractSale.sol";
import "@daonomic/util/contracts/Secured.sol";

contract WhitelistSale is AbstractSale, Secured {
	mapping(address => bool) whitelist;
	event WhitelistChange(address indexed buyer, bool allow);

	function isBuyerAllowed(address buyer) constant public returns (bool) {
		return whitelist[buyer];
	}

	function setWhitelist(address buyer, bool allow) only("operator") public {
		whitelist[buyer] = allow;
		WhitelistChange(buyer, allow);
	}

	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
		super.checkPurchaseValid(buyer, sold, bonus);
		require(isBuyerAllowed(buyer));
	}
}
