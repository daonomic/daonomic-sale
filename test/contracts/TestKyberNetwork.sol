pragma solidity ^0.4.24;

import "../../contracts/kyberContracts/KyberNetworkProxyInterface.sol";

contract TestKyberNetwork is KyberNetworkProxyInterface{
  function () payable {

  }

  function maxGasPrice() public view returns(uint) {
    return 0;
  }

  function getUserCapInWei(address user) public view returns(uint) {
    return 0;
  }

  function getUserCapInTokenWei(address user, Token token) public view returns(uint) {
    return 0;
  }

  function enabled() public view returns(bool) {
    return true;
  }

  function info(bytes32 id) public view returns(uint) {
    return 0;
  }

  function getExpectedRate(Token src, Token dest, uint srcQty) public view returns (uint expectedRate, uint slippageRate) {
    return (0, 0);
  }

  function tradeWithHint(Token src, uint srcAmount, Token dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint) {
    destAddress.transfer(1000);
    return 1000;
  }
}
