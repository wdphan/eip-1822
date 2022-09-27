//SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

// proxy contract that contains the storage of information and uses the logic from the original contract

contract Proxy {
    // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
    // this is where you store the implementation contract address ^

    constructor(bytes memory constructData, address contractLogic) {
        // save the code address
        assembly {
            // solium-disable-line
            // every variable here like the address below gets their own slot, it's stored
            sstore(
                0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7,
                contractLogic
            )
        }
        (bool success, bytes memory result) = contractLogic.delegatecall(
            constructData
        ); // solium-disable-line
        require(success, "Construction failed");
    }

    // fallback used when the contract cannot find the method that is currently being called.
    // contract then resorts to the fallback function
    fallback() external payable {
        assembly {
            // solium-disable-line
            // loaded the contract logic with "sload(address)"
            // := "set equal to"
            let contractLogic := sload(
                0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7
            )
            calldatacopy(0x0, 0x0, calldatasize())
            // Uses the logic of a different smart contract (contractLogic) but with the state variables of the current contract
            // Basically delegates the call to the contract logic
            // := "set equal to"
            let success := delegatecall(
                sub(gas(), 10000),
                contractLogic,
                0x0,
                calldatasize(),
                0,
                0
            )
            let retSz := returndatasize()
            returndatacopy(0, 0, retSz)
            switch success
            case 0 {
                revert(0, retSz)
            }
            default {
                return(0, retSz)
            }
        }
    }
}
