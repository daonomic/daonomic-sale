pragma solidity ^0.4.11;


import '@daonomic/tokens/contracts/TokenImpl.sol';


// mock class using StandardToken
contract ERC20Mock is TokenImpl {

  function ERC20Mock(address initialAccount, uint256 initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply = initialBalance;
  }

}
