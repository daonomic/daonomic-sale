pragma solidity ^0.4.21;
pragma experimental ABIEncoderV2;

import "@daonomic/util/contracts/Secured.sol";

contract Whitelist is Secured {
	mapping(address => bool) whitelist;
	event WhitelistChange(address indexed addr, bool allow);

	function isInWhitelist(address addr) constant public returns (bool) {
		return whitelist[addr];
	}

	function addToWhitelist(address[] _addresses) ownerOr("operator") public {
		for (uint i = 0; i < _addresses.length; i++) {
			setWhitelistInternal(_addresses[i], true);
		}
	}

	function removeFromWhitelist(address[] _addresses) ownerOr("operator") public {
		for (uint i = 0; i < _addresses.length; i++) {
			setWhitelistInternal(_addresses[i], false);
		}
	}

	function setWhitelist(address addr, bool allow) ownerOr("operator") public {
		setWhitelistInternal(addr, allow);
	}

	function setWhitelistInternal(address addr, bool allow) internal {
		whitelist[addr] = allow;
		emit WhitelistChange(addr, allow);
	}
}
