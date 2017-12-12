pragma solidity ^0.4.0;


import "./AbstractSale.sol";


contract CappedSale is AbstractSale {
    uint256 public cap;

    function CappedSale(uint256 _cap) public {
        cap = _cap;
    }

    function checkPurchaseValid(address _buyer, uint256 _amount) internal {
        require(cap >= _amount);
    }

    function onPurchase(address _buyer, address _token, uint256 _value, uint256 _amount) internal {
        cap = cap.sub(_amount);
    }
}
