/*
 * A contract to lock skull LP tokens until the handler allows them to be released
 */

contract LockContract {
    uint stakedLP;
    Pair lp;
    address handler;

    modifier onlyHandler() {
        require(msg.sender == handler)
    }

    constructor(address lpAddress) {
        lp = Pair(lpAddress); 
        handler = msg.sender;
    }
    
    function startLock() external onlyHandler {
    }

    function endLock(address sendTo) external onlyHandler {
    }
}