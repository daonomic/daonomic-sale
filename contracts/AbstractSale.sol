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

    function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
        uint256 sold = getSold(_token, _value);
        require(sold > 0);
        uint256 bonus = getBonus(sold);
        address buyer;
        if (_data.length == 20) {
            buyer = address(toBytes20(_data, 0));
        } else {
            require(_data.length == 0);
            buyer = _from;
        }
        checkPurchaseValid(buyer, sold, bonus);
        doPurchase(buyer, sold, bonus);
        Purchase(buyer, _token, _value, sold, bonus);
        onPurchase(buyer, _token, _value, sold, bonus);
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

    function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
        require(_start + 20 <= b.length);
        assembly {
            let from := add(_start, add(b, 0x20))
            result := mload(from)
        }
    }

    function withdrawEth(address _to, uint256 _value) onlyOwner public {
        withdraw(address(0), _to, _value);
    }

    function withdraw(address _token, address _to, uint256 _value) onlyOwner public {
        require(_to != address(0));
        verifyCanWithdraw(_token, _to, _value);
        if (_token == address(0)) {
            _to.transfer(_value);
        } else {
            Token(_token).transfer(_to, _value);
        }
        Withdraw(_token, _to, _value);
    }

    function verifyCanWithdraw(address token, address to, uint256 amount) internal;

    function burnWithData(address _token, uint256 _value, bytes _data) onlyOwner public {
        ExternalToken(_token).burn(_value, _data);
        Burn(_token, _value, _data);
    }
}
