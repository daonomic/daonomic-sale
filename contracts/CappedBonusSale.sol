pragma solidity ^0.4.18;


import "./AbstractSale.sol";


contract CappedBonusSale is AbstractSale {
    uint256 public cap;
    uint256 public initialCap;

    function CappedBonusSale(uint256 _cap) public {
        cap = _cap;
        initialCap = _cap;
    }

    function checkPurchaseValid(address buyer, uint256 sold, uint256 bonus) internal {
        super.checkPurchaseValid(buyer, sold, bonus);
        require(cap >= sold.add(bonus));
    }

    function onPurchase(address buyer, address token, uint256 value, uint256 sold, uint256 bonus) internal {
        super.onPurchase(buyer, token, value, sold, bonus);
        cap = cap.sub(sold).sub(bonus);
    }
}