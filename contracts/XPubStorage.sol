pragma solidity ^0.4.0;

import "./AbstractSale.sol";

contract XPubStorage is AbstractSale {
    event XPubChange(address token, string xpub);
    mapping(address => string) xpubs;

    function setXPub(address _token, string _xpub) onlyOwner public {
        setXPubInternal(_token, _xpub);
    }

    function setXPubInternal(address _token, string _xpub) internal {
        xpubs[_token] = _xpub;
        emit XPubChange(_token, _xpub);
    }

    function getXPub(address token) constant public returns (string) {
        return xpubs[token];
    }
}
