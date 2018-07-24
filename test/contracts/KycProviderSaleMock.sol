pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/util/contracts/SecuredImpl.sol";
import "../../contracts/OneRateSale.sol";
import "../../contracts/LoggingSale.sol";
import "../../contracts/KycProviderSale.sol";


contract KycProviderSaleMock is OwnableImpl, SecuredImpl, OneRateSale, LoggingSale, KycProviderSale {
	constructor(address _token, uint256 _rate, uint256 _bonus, KycProvider[] _kycProviders) KycProviderSale(_kycProviders) OneRateSale(_token, _rate, _bonus) public {

	}
}
