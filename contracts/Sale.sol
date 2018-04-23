pragma solidity ^0.4.21;


/**
 * @title Sale contract for Daonomic platform should implement this
 */
contract Sale {
    /**
     * @dev This event should be emitted when user buys something
     */
    event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);
    /**
     * @dev Should be emitted if new payment method added
     */
    event RateAdd(address token);
    /**
     * @dev Should be emitted if payment method removed
     */
    event RateRemove(address token);

    /**
     * @dev Calculate rate for specified payment method
     */
    function getRate(address token) constant public returns (uint256);
    /**
     * @dev Calculate current bonus in tokens
     */
    function getBonus(uint256 sold) constant public returns (uint256);
    /**
     * @dev get xpub key for payment method (if applicable)
     */
    function getXPub(address token) constant public returns (string);
}
