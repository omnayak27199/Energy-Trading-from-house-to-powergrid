//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnergyTrading {
    
    // Declare the struct to represent an energy transaction
    struct EnergyTransaction {
        address payable sender;
        address payable recipient;
        uint256 energyAmount;
        uint256 price;
        bool isCompleted;
    }
    
    // Declare the mapping to store the energy transactions
    mapping(uint256 => EnergyTransaction) public energyTransactions;
    uint256 public transactionCounter;
    
    // Declare the mapping to store the energy balances of households
    mapping(address => uint256) public energyBalances;
    
    // Declare the centralized power hub's address
    address payable public centralizedPowerHub;
    // Declare the government electricity price
    uint256 public governmentElectricityPrice;
    
    // Constructor to set the centralized power hub's address
    constructor(address payable _centralizedPowerHub,uint256 _governmentElectricityPrice) {
        centralizedPowerHub = _centralizedPowerHub;
        governmentElectricityPrice = _governmentElectricityPrice;
    }
    
    // Function to initiate an energy transaction between buyers and sellers
    function initiateTransaction(address payable _recipient, uint256 _energyAmount, uint256 _price) public {
        require(energyBalances[msg.sender] >= _energyAmount, "Insufficient energy balance");
        energyBalances[msg.sender] -= _energyAmount;
        energyBalances[_recipient] += _energyAmount;
        energyTransactions[transactionCounter] = EnergyTransaction(payable(msg.sender), _recipient, _energyAmount, _price, false);
        transactionCounter++;
    }
    
    // Function to initiate an energy transaction between buyers and the power grid
    function initiateTransactionWithPowerGrid(uint256 _energyAmount, uint256 _price) public {
        require(energyBalances[msg.sender] >= _energyAmount, "Insufficient energy balance");
        energyBalances[msg.sender] -= _energyAmount;
        energyBalances[centralizedPowerHub] += _energyAmount;
        energyTransactions[transactionCounter] = EnergyTransaction(payable(msg.sender), centralizedPowerHub, _energyAmount, _price, false);
        transactionCounter++;
    }
    
    // Function to complete an energy transaction
    function completeTransaction(uint256 _transactionId) public payable {
        EnergyTransaction storage transaction = energyTransactions[_transactionId];
        require(!transaction.isCompleted, "Transaction already completed");
        require(msg.value == transaction.price, "Incorrect payment amount");
        transaction.sender.transfer(msg.value);
        energyBalances[transaction.recipient] -= transaction.energyAmount;
        energyBalances[transaction.sender] += transaction.energyAmount;
        transaction.isCompleted = true;
    }
    
    // Function to request energy from the power grid
    function requestEnergyFromPowerGrid(uint256 _energyAmount) public {
        energyBalances[msg.sender] += _energyAmount;
        energyBalances[centralizedPowerHub] -= _energyAmount;
    }
}
