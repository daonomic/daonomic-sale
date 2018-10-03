pragma solidity ^0.4.24;

import "./AbstractSale.sol";
import "./kyberContracts/KyberNetworkProxyInterface.sol";

contract KyberNetworkWrapper {

  event ETHReceived(address indexed sender, uint amount);

  Token constant internal ETH_TOKEN_ADDRESS = Token(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

  function() payable {
    emit ETHReceived(msg.sender, msg.value);
  }

  function getETHPrice(AbstractSale _sale) public view returns (uint) {
    return _sale.getRate(address(0));
  }

  /// @dev Get the rate for user's token
  /// @param _kyberProxy KyberNetworkProxyInterface address
  /// @param token ERC20 token address
  /// @return expectedRate, slippageRate
  function getTokenRate(
    KyberNetworkProxyInterface _kyberProxy,
    AbstractSale _sale,
    Token token
  )
  public
  view
  returns (uint, uint)
  {
    uint256 ethRate = _sale.getRate(address(0));

    // Get the expected and slippage rates of the token to ETH
    (uint expectedRate, uint slippageRate) = _kyberProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, ethRate);

    return (expectedRate, slippageRate);
  }

  /// @dev Acquires selling token using Kyber Network's supported token
  /// @param _kyberProxy KyberNetworkProxyInterface address
  /// @param _sale Sale address
  /// @param token ERC20 token address
  /// @param tokenQty Amount of tokens to be transferred by user
  /// @param maxDestQty Max amount of eth to contribute
  /// @param minRate The minimum rate or slippage rate.
  /// @param walletId Wallet ID where Kyber referral fees will be sent to
  function tradeAndBuy(
    KyberNetworkProxyInterface _kyberProxy,
    AbstractSale _sale,
    Token token,
    uint tokenQty,
    uint maxDestQty,
    uint minRate,
    address walletId
  )
  public
  {
    // Check if user is allowed to buy
    require(_sale.canBuy(msg.sender));

    // Check that the user has transferred the token to this contract
    require(token.transferFrom(msg.sender, this, tokenQty));

    // Get the starting token balance of the wrapper's wallet
    uint startTokenBalance = token.balanceOf(this);

    // Mitigate ERC20 Approve front-running attack, by initially setting
    // allowance to 0
    require(token.approve(_kyberProxy, 0));

    // Verify that the token balance has not decreased from front-running
    require(token.balanceOf(this) == startTokenBalance);

    // Once verified, set the token allowance to tokenQty
    require(token.approve(_kyberProxy, tokenQty));

    // Swap user's token to ETH to send to Sale contract
    uint userETH = _kyberProxy.tradeWithHint(token, tokenQty, ETH_TOKEN_ADDRESS, address(this), maxDestQty, minRate, walletId, "");

    _sale.buyTokens.value(userETH)(msg.sender);
  }

}
