pragma solidity ^0.4.0;


import "@daonomic/interfaces/contracts/MintableToken.sol";
import "./AbstractSale.sol";


contract MintingSale is AbstractSale {
    MintableToken public token;

    function doPurchase(address buyer, uint256 amount) internal {
        token.mint(buyer, amount);
    }
}
