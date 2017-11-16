pragma solidity ^0.4.0;


import "daox-tokens/contracts/standard/NotifyingTokenImpl.sol";


contract PayingToken is NotifyingTokenImpl {
    function PayingToken(address initialAccount, uint256 initialBalance) public {
        balances[initialAccount] = initialBalance;
        totalSupply = initialBalance;
    }
}
