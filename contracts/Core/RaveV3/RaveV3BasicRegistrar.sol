pragma solidity ^0.8.19;

/*
 * A contract that resolves Rave Names with basic funcitonality. Allows for DNS-like
 * records to be set. Registrations, etc are controlled by the Rave Hub.
 *
 * Subdomain resolution is done with another resolver, and can be used to create
 * subdomains of subdomains, i.e.
 *  hello.my.name.is.z.ftm, in which is.z.ftm, name.is.z.ftm are all different names.
 */

import {IRaveV3Resolver} from "./IRaveV3Resolver.sol";
import {OmniRaveStorage as RaveV3} from "./RaveV3.sol";
import {Name} from "./RaveStructs.sol";
import {StringUtils} from "../../Other/StringUtilities.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract RaveV3BasicRegistry is
    UUPSUpgradeable,
    IRaveV3Resolver,
    ERC721Upgradeable,
    OwnableUpgradeable
{
    mapping(bytes32 name => Name data) public names;
    mapping(bytes32 name => address resolver) public subdomains;
    mapping(bytes32 name => mapping(bytes32 key => string record))
        public records;
    address hub;
    uint price = 5;
    bool acceptsRave = false;

    using StringUtils for string;

    function initialize(
        address _hub,
        string calldata a,
        string calldata b,
        bool rave
    ) external initializer {
        hub = _hub;
        acceptsRave = rave;
        __ERC721_init(a, b);
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /*********************\
    |    Access Control    |
    \*********************/

    modifier onlyHub() {
        require(msg.sender == hub, "onlyHub: Not hub.");

        _;
    }

    /**********************\
    |    Write Functions    |
    \**********************/

    function registerName(
        string calldata _name,
        address owner,
        address resolvee
    ) external onlyHub {
        require(
            !_name.contains("."),
            "RaveV3Registrar: You cannot have .'s in your name."
        );

        Name memory name = Name({
            name: _name,
            resolvee: resolvee,
            exists: true,
            resolver: address(0)
        });

        names[_name.hash()] = name;

        _mint(owner, _name.nameHash());
    }

    function setSubDomainResolver(
        bytes32 name,
        address resolver
    ) external onlyHub {
        subdomains[name] = resolver;
    }

    function setResolver(bytes32 name, address resolver) external onlyHub {
        names[name].resolver = resolver;
    }

    function setRecord(
        bytes32 name,
        bytes32 key,
        string calldata value
    ) external onlyHub {
        records[name][key] = value;
    }

    function setPrice(uint _price) external onlyOwner {
        price = _price;
    }

    /**********************\
    |    View Functions     |
    \**********************/

    function acceptsRAVE() external view returns (bool) {
        return acceptsRave;
    }

    function resolveName(bytes32 name) external view returns (Name memory) {
        if (names[name].resolver != address(0)) {
            return IRaveV3Resolver(names[name].resolver).resolveName(name);
        }
        return names[name];
    }

    function getUSDPrice(uint characters) external view returns (uint) {
        return price;
    }

    function resolveSubDomain(
        bytes32 name,
        bytes32 subdomain
    ) external view returns (Name memory) {
        address resolver = subdomains[name];
        require(
            resolver != address(0),
            "RaveV3Registrar: There is no resolver associated with this name."
        );
        return IRaveV3Resolver(resolver).resolveName(subdomain);
    }

    function getRecord(
        bytes32 name,
        bytes32 key
    ) external view returns (string memory) {
        return records[name][key];
    }

    function getController(
        string calldata name
    ) external view returns (address) {
        return ownerOf(name.nameHash());
    }

    function getOwned(bytes32 name) external view returns (bool) {
        return names[name].exists;
    }

    // TODO: Add a beforeTokenTransfer that changes the resolvee when a token is transferred (maybe ?)

    // overrides
    function _authorizeUpgrade(address) internal override onlyOwner {}
}
