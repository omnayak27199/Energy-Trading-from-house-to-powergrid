// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnergyTrading.sol";

contract Buyer {
    // Create a private reference to the EnergyTrading contract
    EnergyTrading private energyTradingContract;
    
    // Define the buyer's address
    address public buyerAddress;
    
    // Constructor to initialize the reference to the EnergyTrading contract
    constructor(address _energyTradingContractAddress) {
        energyTradingContract = EnergyTrading(_energyTradingContractAddress);
        buyerAddress = msg.sender;
    }
    
    // Function for the buyer to purchase energy from a seller
    function buyEnergyFromSeller(address payable _seller, uint256 _energyAmount, uint256 _price) public payable {
        energyTradingContract.initiateTransaction(_seller, _energyAmount, _price);
        energyTradingContract.completeTransaction{value: _price}(energyTradingContract.transactionCounter()-1);
    }
    
    // Function for the buyer to purchase energy from the centralized power hub
    function buyEnergyFromCentralizedHub(uint256 _energyAmount, uint256 _price) public payable {
        energyTradingContract.initiateTransactionWithPowerGrid(_energyAmount, _price);
        energyTradingContract.completeTransaction{value: _price}(energyTradingContract.transactionCounter()-1);
    }
    
    // Function for the buyer to request energy from the centralized power hub
    function requestEnergyFromCentralizedHub(uint256 _energyAmount) public {
        energyTradingContract.requestEnergyFromPowerGrid(_energyAmount);
    }
    
    // Function for the buyer to get their energy balance
    function getEnergyBalance() public view returns (uint256) {
        return energyTradingContract.energyBalances(buyerAddress);
    }
}
