pragma solidity ^0.4.0;


import "@daonomic/tokens/contracts/NotifyingTokenImpl.sol";


contract PayingToken is NotifyingTokenImpl {
    function PayingToken(address initialAccount, uint256 initialBalance) public {
        balances[initialAccount] = initialBalance;
        totalSupply = initialBalance;
    }
}
