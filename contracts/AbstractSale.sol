pragma solidity ^0.4.21;


import './Sale.sol';
import '@daonomic/util/contracts/SafeMath.sol';
import '@daonomic/util/contracts/Ownable.sol';
import '@daonomic/interfaces/contracts/Token.sol';
import "@daonomic/util/contracts/Secured.sol";


contract AbstractSale is Sale, Ownable, Secured {
    using SafeMath for uint256;

    event Withdraw(address to, uint256 value);

    function () payable public {
        receiveWithData("");
    }

    function receiveWithData(bytes _data) payable public {
        if (_data.length == 20) {
            onReceivePrivate(address(toBytes20(_data, 0)), address(0), msg.value, "");
        } else {
            require(_data.length == 0);
            onReceivePrivate(msg.sender, address(0), msg.value, "");
        }
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

    function toBytes20(bytes b, uint256 _start) pure private returns (bytes20 result) {
        require(_start + 20 <= b.length);
        assembly {
            let from := add(_start, add(b, 0x20))
            result := mload(from)
        }
    }

    function withdrawEth(address _to, uint256 _value) onlyOwner public {
        _to.transfer(_value);
        emit Withdraw(_to, _value);
    }

    function getXPub(address token) constant public returns (string) {
        return "";
    }
}
