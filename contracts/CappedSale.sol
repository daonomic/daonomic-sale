pragma solidity ^0.4.0;


import "./AbstractSale.sol";


contract CappedSale is AbstractSale {
    uint256 public cap;

    function CappedSale(uint256 _cap) public {
        cap = _cap;
    }

    function checkPurchaseValid(address buyer, uint256 amount, uint256 beforeBonus) internal {
        super.checkPurchaseValid(buyer, amount, beforeBonus);
        require(cap >= beforeBonus);
    }

    function onPurchase(address buyer, address token, uint256 value, uint256 amount, uint256 beforeBonus) internal {
        super.onPurchase(buyer, token, value, amount, beforeBonus);
        cap = cap.sub(beforeBonus);
    }
}
