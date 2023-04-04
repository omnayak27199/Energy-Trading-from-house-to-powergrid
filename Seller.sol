// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnergyTrading.sol";

contract Seller {
    // Create a private reference to the EnergyTrading contract
    EnergyTrading private energyTradingContract;
    
    // Define the seller's address
    address public sellerAddress;
    
    // Constructor to initialize the reference to the EnergyTrading contract
    constructor(address _energyTradingContractAddress) {
        energyTradingContract = EnergyTrading(_energyTradingContractAddress);
        sellerAddress = msg.sender;
    }
    
    // Function for the seller to sell energy to a buyer
    function sellEnergyToBuyer(address payable _buyer, uint256 _energyAmount, uint256 _price) public {
        energyTradingContract.initiateTransaction(_buyer, _energyAmount, _price);
        energyTradingContract.completeTransaction{value: _price}(energyTradingContract.transactionCounter()-1);
    }
    
    // Function for the seller to get their energy balance
    function getEnergyBalance() public view returns (uint256) {
        return energyTradingContract.energyBalances(sellerAddress);
    }
}