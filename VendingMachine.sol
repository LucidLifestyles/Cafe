// SPDX-License-Identifier: MIT
// Specify the Solidity compiler version - this contract requires version 0.8.9 or higher
pragma solidity ^0.8.9;

// Define a smart contract named VendingMachine
// Unlike regular classes, once deployed, this contract's code cannot be modified
// This ensures that the vending machine's rules remain constant and trustworthy
contract VendingMachine {
   // State variables are permanently stored in blockchain storage
   // These mappings associate Ethereum addresses with unsigned integers
   // The 'private' keyword means these variables can only be accessed from within this contract
   mapping(address => uint) private _cupcakeBalances;     // Tracks how many cupcakes each address owns
   mapping(address => uint) private _cupcakeDistributionTimes;  // Tracks when each address last received a cupcake

   // Function to give a cupcake to a specified address
   // 'public' means this function can be called by anyone
   // 'returns (bool)' specifies that the function returns a boolean value
   function giveCupcakeTo(address userAddress) public returns (bool) {
       // Initialize first-time users
       // In Solidity, uninitialized values default to 0, so this check isn't strictly necessary
       // but is included to mirror the JavaScript implementation
       if (_cupcakeDistributionTimes[userAddress] == 0) {
           _cupcakeBalances[userAddress] = 0;
           _cupcakeDistributionTimes[userAddress] = 0;
       }

       // Calculate when the user is eligible for their next cupcake
       // 'seconds' is a built-in time unit in Solidity
       // 'block.timestamp' gives us the current time in seconds since Unix epoch
       uint fiveSecondsFromLastDistribution = _cupcakeDistributionTimes[userAddress] + 5 seconds;
       bool userCanReceiveCupcake = fiveSecondsFromLastDistribution <= block.timestamp;

       if (userCanReceiveCupcake) {
           // If enough time has passed, give them a cupcake and update their last distribution time
           _cupcakeBalances[userAddress]++;
           _cupcakeDistributionTimes[userAddress] = block.timestamp;
           return true;
       } else {
           // If not enough time has passed, revert the transaction with an error message
           // 'revert' cancels the transaction and returns the error message to the user
           revert("HTTP 429: Too Many Cupcakes (you must wait at least 5 seconds between cupcakes)");
       }
   }

   // Function to check how many cupcakes an address owns
   // 'public' means anyone can call this function
   // 'view' means this function only reads data and doesn't modify state
   // This makes it free to call (no gas cost) when called externally
   function getCupcakeBalanceFor(address userAddress) public view returns (uint) {
       return _cupcakeBalances[userAddress];
   }
}
