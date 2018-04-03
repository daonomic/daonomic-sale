pragma solidity ^0.4.21;

import "@daonomic/util/contracts/Secured.sol";

contract Whitelist is Secured {
	mapping(address => bool) whitelist;
	event WhitelistChange(address indexed addr, bool allow);

	function isInWhitelist(address addr) constant public returns (bool) {
		return whitelist[addr];
	}

	function setWhitelist(address addr, bool allow) only("operator") public {
		setWhitelistInternal(addr, allow);
	}

	function setWhitelistInternal(address addr, bool allow) internal {
		whitelist[addr] = allow;
		emit WhitelistChange(addr, allow);
	}
}
