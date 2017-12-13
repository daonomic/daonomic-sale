pragma solidity ^0.4.0;

import "@daonomic/util/contracts/OwnableImpl.sol";
import "../../contracts/OneRateSale.sol";
import "../../contracts/LoggingSale.sol";
import "../../contracts/CappedSale.sol";


contract CappedSaleMock is OneRateSale, LoggingSale, CappedSale, OwnableImpl {
    function CappedSaleMock(uint256 _cap, address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) CappedSale(_cap) public {

    }
}
