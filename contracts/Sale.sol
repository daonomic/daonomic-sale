pragma solidity ^0.4.18;


/**
 * @title Sale contract for Daonomic platform should implement this
 */
contract Sale {
    /**
     * @dev This event should be emitted when user buys something
     */
    event Purchase(address indexed buyer, address token, uint256 value, uint256 amount);
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
    function getRate(address _token) constant public returns (uint256);
    /**
     * @dev Calculate current bonus in percents (10, 15, 30 etc)
     */
    function getBonus() constant public returns (uint256);
}
