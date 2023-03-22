pragma solidity ^0.8.19;

import {IRavePriceFeed} from "./IRavePriceFeed.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RavePriceFeed is IRavePriceFeed, Ownable {
    mapping(uint => AggregatorV3Interface) internal feeds;

    event AddFeed(address indexed _address, uint id);

    constructor() {
        /*
            Fantom, FTM/USD
         */
        feeds[uint(0)] = AggregatorV3Interface(
            0xf4766552D15AE4d256Ad41B6cf2933482B0680dc
        );
    }

    function get(uint key) external view returns (int256) {
        (, int price, , , ) = feeds[key].latestRoundData();

        return price;
    }

    function addFeed(address _address, uint key) external onlyOwner {
        feeds[key] = AggregatorV3Interface(_address);
    }
}
