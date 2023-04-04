// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnergyTrading.sol";

contract CentralizedPowerHub {
    EnergyTrading private energyTradingContract;
    address public hubAddress;
    
    constructor(address _energyTradingContractAddress) {
        energyTradingContract = EnergyTrading(_energyTradingContractAddress);
        hubAddress = msg.sender;
    }
    
    function sellEnergyToBuyer(address payable _buyer, uint256 _energyAmount, uint256 _price) public {
        energyTradingContract.initiateTransaction(_buyer, _energyAmount, _price);
        energyTradingContract.completeTransaction{value: _price}(energyTradingContract.transactionCounter()-1);
    }
    
    function getEnergyBalance() public view returns (uint256) {
        return energyTradingContract.energyBalances(hubAddress);
    }
    
    function getGovernmentElectricityPrice() private pure returns (uint256) {
        //Assume: government electricity price 1 unit-10 rs
        return 10; // Placeholder value
    }
}
