// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./EnergyTrading.sol";
contract RegisterUser {
// Declare the struct to represent user information
struct User {
    uint256 areaId;
    uint256 homeNumber;
    string name;
    string contactNumber;
    bool isRegistered;
}

// Declare the mapping to store the user information
mapping(address => User) public users;

// Declare the owner of the contract
address public owner;

// Declare the energy trading contract
EnergyTrading public energyTrading;

// Constructor to set the owner of the contract and the energy trading contract
constructor(address _energyTrading) {
    owner = msg.sender;
    energyTrading = EnergyTrading(_energyTrading);
}

// Function to register a new user
function registerUser(uint256 _areaId, uint256 _homeNumber, string memory _name, string memory _contactNumber) public {
    require(!users[msg.sender].isRegistered, "User already registered");
    users[msg.sender] = User(_areaId, _homeNumber, _name, _contactNumber, true);
}

// Function to unregister a user
function unregisterUser() public {
    require(users[msg.sender].isRegistered, "User not registered");
    delete users[msg.sender];
}

// Function to sell energy
function sellEnergy(address payable _recipient, uint256 _energyAmount, uint256 _price) public {
    require(users[msg.sender].isRegistered, "User not registered");
    energyTrading.initiateTransaction(_recipient, _energyAmount, _price);
}

// Function to buy energy
function buyEnergy(uint256 _energyAmount, uint256 _price) public payable {
    require(users[msg.sender].isRegistered, "User not registered");
    energyTrading.initiateTransactionWithPowerGrid(_energyAmount, _price);
    energyTrading.completeTransaction{value: msg.value}(energyTrading.transactionCounter() - 1);
}

// Function to check if a user is registered
function isUserRegistered(address _user) public view returns (bool) {
    return users[_user].isRegistered;
}

}
