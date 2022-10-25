# EIP-1822

> Universal Upgradeable Proxy Standard (UUPS)

The proxy contract stores the contract logic (implementation contract) on a specific storage slot which is predefined with an address. Then the proxy contract uses a `delegatecall()` (helps us execute with the transaction data on a different smart contract) to the implementation contract. So `delegatecall()` uses the logic of a different smart contract but with the variables of the current proxy contract. The state changes for the proxy contract only, not the implementation contract. 

So essentially, in order to upgrade the smart contract, you replace the implementation contract with a different addess (different implementation contract). Upgrading the contract is usually included in its original implementation (otherwise you cannot upgrade). You can include a `Proxiable` contract which contains a function to update the implemenation contract.

[Contract Source](src/Contract.sol) · [Proxy Source](src/Proxy.sol)
