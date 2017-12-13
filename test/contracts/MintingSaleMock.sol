pragma solidity ^0.4.18;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "../../contracts/OneRateSale.sol";
import "../../contracts/MintingSale.sol";


contract MintingSaleMock is OneRateSale, MintingSale, OwnableImpl {
    function MintingSaleMock(address _mintableToken, address _token, uint256 _rate, uint256 _bonus) OneRateSale(_token, _rate, _bonus) MintingSale(_mintableToken) public {

    }
}
