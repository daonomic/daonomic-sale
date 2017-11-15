pragma solidity ^0.4.11;


import 'daox-tokens/contracts/standard/TokenImpl.sol';


// mock class using StandardToken
contract ERC20Mock is TokenImpl {

  function ERC20Mock(address initialAccount, uint256 initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply = initialBalance;
  }

}
