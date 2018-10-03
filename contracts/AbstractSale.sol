pragma solidity ^0.4.21;


import '@daonomic/util/contracts/SafeMath.sol';
import '@daonomic/util/contracts/Ownable.sol';
import "@daonomic/util/contracts/Secured.sol";
import './Sale.sol';


contract AbstractSale is Ownable, Sale, Secured {
    using SafeMath for uint256;

    event Withdraw(address to, uint256 value);

    function () payable public {
        onReceivePrivate(msg.sender, address(0), msg.value, "");
    }

    function buyTokens(address _buyer) payable public {
        onReceivePrivate(_buyer, address(0), msg.value, "");
    }

    function buyTokensSigned(address _buyer, bytes _txId, uint _value, uint8 _v, bytes32 _r, bytes32 _s) payable public {
        var hash = keccak256(_value, msg.sender);
        require(ecrecover(hash, _v, _r, _s) == getRole("signer"));
        onReceivePrivate(_buyer, address(0), _value, _txId);
    }

    function onReceive(address _buyer, address _token, uint256 _value, bytes _txId) only("operator") public {
        require(_token != address(0));
        onReceivePrivate(_buyer, _token, _value, _txId);
    }

    function onReceivePrivate(address _buyer, address _token, uint256 _value, bytes _txId) private {
        uint256 sold = getSold(_token, _value);
        require(sold > 0);
        uint256 bonus = getBonus(sold);
        checkPurchaseValid(_buyer, sold, bonus);
        doPurchase(_buyer, sold, bonus);
        emit Purchase(_buyer, _token, _value, sold, bonus, _txId);
        onPurchase(_buyer, _token, _value, sold, bonus);
    }

    function getSold(address _token, uint256 _value) constant public returns (uint256) {
        uint256 rate = getRate(_token);
        require(rate > 0);
        return _value.mul(rate).div(10**18);
    }

    function getBonus(uint256 sold) constant public returns (uint256);

    function getRate(address _token) constant public returns (uint256);

    function doPurchase(address buyer, uint256 sold, uint256 bonus) internal;

    function checkPurchaseValid(address /*buyer*/, uint256 /*sold*/, uint256 /*bonus*/) internal {

    }

    function onPurchase(address /*buyer*/, address /*token*/, uint256 /*value*/, uint256 /*sold*/, uint256 /*bonus*/) internal {

    }

    function canBuy(address _address) constant public returns (bool) {
        return true;
    }

    function withdrawEth(address _to, uint256 _value) onlyOwner public {
        _to.transfer(_value);
        emit Withdraw(_to, _value);
    }

    function getXPub(address token) constant public returns (string) {
        return "";
    }
}
