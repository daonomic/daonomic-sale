pragma solidity ^0.4.15;


import './Sale.sol';
import '@daonomic/util/contracts/SafeMath.sol';
import '@daonomic/util/contracts/Ownable.sol';
import '@daonomic/interfaces/contracts/Token.sol';
import '@daonomic/interfaces/contracts/ExternalToken.sol';
import '@daonomic/receivers/contracts/CompatReceiveAdapter.sol';


contract AbstractSale is Sale, CompatReceiveAdapter, Ownable {
    using SafeMath for uint256;

    event Withdraw(address token, address to, uint256 value);
    event Burn(address token, uint256 value, bytes data);

    function doPurchase(address buyer, uint256 amount) internal;

    function getBonus() constant public returns (uint256);

    function getRate(address _token) constant public returns (uint256);

    function verifyCanWithdraw(address _token, address _to, uint256 _amount) internal;

    function checkPurchaseValid(address /*_buyer*/, uint256 /*_amount*/) internal {

    }

    function onPurchase(address /*_buyer*/, address /*_token*/, uint256 /*_value*/, uint256 /*_amount*/) internal {

    }

    function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
        uint256 tokens = getAmount(_token, _value);
        require(tokens > 0);
        address buyer;
        if (_data.length == 20) {
            buyer = address(toBytes20(_data, 0));
        } else {
            require(_data.length == 0);
            buyer = _from;
        }
        checkPurchaseValid(buyer, tokens);
        doPurchase(buyer, tokens);
        Purchase(buyer, _token, _value, tokens);
        onPurchase(buyer, _token, _value, tokens);
    }

    function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
        require(_start + 20 <= b.length);
        assembly {
            let from := add(_start, add(b, 0x20))
            result := mload(from)
        }
    }

    function getAmount(address _token, uint256 _value) constant public returns (uint256) {
        uint256 rate = getRate(_token);
        require(rate > 0);
        uint256 beforeBonus = _value.mul(rate);
        return beforeBonus.add(beforeBonus.mul(getBonus()).div(100));
    }

    function withdraw(address _token, address _to, uint256 _amount) onlyOwner public {
        require(_to != address(0));
        verifyCanWithdraw(_token, _to, _amount);
        if (_token == address(0)) {
            _to.transfer(_amount);
        } else {
            Token(_token).transfer(_to, _amount);
        }
        Withdraw(_token, _to, _amount);
    }

    function burnWithData(address _token, uint256 _amount, bytes _data) onlyOwner public {
        ExternalToken(_token).burn(_amount, _data);
        Burn(_token, _amount, _data);
    }
}
