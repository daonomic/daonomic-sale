pragma solidity ^0.4.15;


import "./AbstractSale.sol";


/**
 * @title This Sale accepts ETH and ERC-223 tokens and does nothing. It only logs payments
 */
contract LoggingSale is AbstractSale {
    function doPurchase(address, uint256, uint256) internal {

    }

    function verifyCanWithdraw(address, address, uint256) internal {

    }
}
