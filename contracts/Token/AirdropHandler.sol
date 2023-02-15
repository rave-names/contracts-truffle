pragma solidity >= 0.8.0;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { Ownable } from "@openzeppelin/contracts-upgradable/access/Ownable.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts-upgradable/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract AirdropHandler is Ownable, ERC721Enumerable, Initializable {
    ERC20 rave;
    uint amount;
    bytes32 root;

    function initialize(
        address _rave,
        uint _amount,
        bytes32 _root
    ) public initializer {
        rave = ERC20(_rave);
        amount = _amount;
        root = _root;
    }
}