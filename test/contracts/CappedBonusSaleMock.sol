pragma solidity ^0.4.18;

import "@daonomic/util/contracts/OwnableImpl.sol";
import "../../contracts/OneRateSale.sol";
import "../../contracts/LoggingSale.sol";
import "../../contracts/CappedBonusSale.sol";


contract CappedBonusSaleMock is OneRateSale, LoggingSale, CappedBonusSale, OwnableImpl {
    function CappedBonusSaleMock(uint256 _cap, address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) CappedBonusSale(_cap) public {

    }
}
