pragma solidity ^0.8.19;

interface IRavePriceFeed {
    function get(uint key) external view returns (int256);
}
