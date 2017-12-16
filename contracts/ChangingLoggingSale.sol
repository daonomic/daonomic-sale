pragma solidity ^0.4.18;

import "@daonomic/util/contracts/OwnableImpl.sol";
import "./ChangingSale.sol";
import "./LoggingSale.sol";


contract ChangingLoggingSale is ChangingSale, LoggingSale, OwnableImpl {
}
