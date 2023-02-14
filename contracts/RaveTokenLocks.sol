pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RAVELocks_Dev is ReentrancyGuard {
    // Equation is:
    // (seconds since start)/10

    ERC20 public rave;
    uint256 public startTime;
    uint256 public totalClaimed;

    constructor(ERC20 _rave) {
        rave = _rave;
        startTime = block.timestamp;
    }

    function calc() internal returns (uint) {
        uint timeSinceStart = block.timestamp - startTime;
        uint amountToMint = (timeSinceStart / 10) - totalClaimed;
        totalClaimed = timeSinceStart / 10;
        return amountToMint;
    }

    // there doesnt need to be access control here since anyone should be able to claim for the treasury
    function claim() external nonReentrant {
        rave.transferFrom(
            address(this),
            0x87f385d152944689f92Ed523e9e5E9Bd58Ea62ef,
            calc()
        );
    }
}
