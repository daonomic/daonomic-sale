pragma solidity ^0.4.18;

import "../../contracts/OneRateSale.sol";
import "../../contracts/LoggingSale.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/util/contracts/SecuredImpl.sol";
import "../../contracts/WhitelistSale.sol";

contract WhitelistSaleMock is OwnableImpl, SecuredImpl, OneRateSale, LoggingSale, WhitelistSale {
	function WhitelistSaleMock(address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) {

	}
}
