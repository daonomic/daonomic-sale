pragma solidity ^0.4.18;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/tokens/contracts/MintableTokenImpl.sol";


contract MintableTokenMock is MintableTokenImpl, OwnableImpl {
}
