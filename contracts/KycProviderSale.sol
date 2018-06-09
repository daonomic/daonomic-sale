pragma solidity ^0.4.21;
pragma experimental ABIEncoderV2;


import "@daonomic/interfaces/contracts/KycProvider.sol";
import "./AbstractSale.sol";


contract KycProviderSale is AbstractSale, HasInvestor {
	KycProvider public kycProvider;

	constructor(KycProvider _kycProvider) public {
		kycProvider = _kycProvider;
	}

	function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
		super.checkPurchaseValid(buyer, sold, bonus);
		Investor memory investor = kycProvider.resolve(buyer);
		require(investor.jurisdiction != 0, "investor is not verified by KycProvider");
	}

	function canBuy(address _address) constant public returns (bool) {
		Investor memory investor = kycProvider.resolve(_address);
		return investor.jurisdiction != 0;
	}

	function setKycProvider(KycProvider _kycProvider) onlyOwner public {
		kycProvider = _kycProvider;
	}
}
