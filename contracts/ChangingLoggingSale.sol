pragma solidity ^0.4.18;

import "@daonomic/util/contracts/OwnableImpl.sol";
import "./LoggingSale.sol";
import "./RatesChangingSale.sol";


contract ChangingLoggingSale is RatesChangingSale, LoggingSale, OwnableImpl {
}
