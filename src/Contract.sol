//SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

import "/Users/williamphan/Desktop/Developer/eip-1822/src/Proxy.sol";

// contract that contains logic and functionality

contract MyContract is Proxy {
    address public owner;
    uint256 public count;
    bool public initalized = false;

    function initialize() public {
        require(owner == address(0), "Already initalized");
        require(!initalized, "Already initalized");
        owner = msg.sender;
        initalized = true;
    }

    function increment() public {
        count++;
    }

    //  you need this implementation, if you do not have this implementation to update
    // your code, you cannot update
    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner is allowed to perform this action"
        );
        _;
    }
}
