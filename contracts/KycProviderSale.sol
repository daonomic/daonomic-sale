pragma solidity ^0.4.21;
pragma experimental ABIEncoderV2;


import "@daonomic/interfaces/contracts/KycProvider.sol";
import "./AbstractSale.sol";


contract KycProviderSale is AbstractSale, HasInvestor {
	KycProvider[] public kycProviders;

	constructor(KycProvider[] _kycProviders) public {
		kycProviders = _kycProviders;
	}

	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
		super.checkPurchaseValid(buyer, sold, bonus);
		require(canBuy(buyer), "investor is not verified by KycProviders");
	}

	function canBuy(address _address) constant public returns (bool) {
		for (uint i = 0; i < kycProviders.length; i++) {
			Investor memory investor = kycProviders[i].resolve(_address);
			if (investor.jurisdiction != 0) {
				return true;
			}
		}
		return false;
	}

	function getKycProviders() view public returns (KycProvider[]) {
		return kycProviders;
	}

	function setKycProviders(KycProvider[] _kycProviders) onlyOwner public {
		kycProviders = _kycProviders;
	}
}
