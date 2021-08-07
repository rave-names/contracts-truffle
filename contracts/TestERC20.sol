// contracts/TestERC20.sol
// author: MaxflowO2
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor(string memory name, string memory symbol, uint256 initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}
