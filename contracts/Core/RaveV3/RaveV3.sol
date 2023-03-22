pragma solidity ^0.8.19;
/*
 * Rave v3
 *
 * A multi-chain name service, powered by layer zero. The storage for the names and
 * all their data is done on Fantom, due to the low costs. Users can register .rave
 * names in either >=100 RAVE or the equivalent in the chain's native token. The
 * plus-side to multichain names is that anyone can resolve a name on any chain,
 * natively. This allows for developers to use .rave names in the stead of addresses
 * as a sort of verification, or anti-bot measure.
 *
 * Rave v3 will be compatiable with any ENS-enabled wallet through ENS sub-domains
 * (similar to the current .ftm.fyi solution), just with an on-chain resolver as a
 * pose to an off-chain one.
 *
 * This contract is designed to store the resolver values, and is intended to be deployed
 * on the Fantom chain. We call it the 'Hub'.
 */

import {IRaveV3Resolver} from "./IRaveV3Resolver.sol";
import {IRavePriceFeed} from "./IRavePriceFeed.sol";
import {StringUtils} from "../../Other/StringUtilities.sol";
import {Name} from "./RaveStructs.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract OmniRaveStorage is OwnableUpgradeable, UUPSUpgradeable {
    IRavePriceFeed public feed;

    mapping(bytes32 extension => Extension data) public extensions;

    using StringUtils for string;

    struct Extension {
        address resolver;
        bool valid;
        address owner;
    }

    function initialize(address priceFeed) external initializer {
        feed = IRavePriceFeed(priceFeed);
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function resolveName(
        string calldata name,
        string calldata extension
    ) external view returns (Name memory) {
        IRaveV3Resolver resolver = IRaveV3Resolver(
            extensions[extension.hash()].resolver
        );
        return resolver.resolveName(name.hash());
    }

    function resolveSubdomain(
        string[] calldata subdomains,
        string calldata name,
        string calldata extension
    ) external view returns (Name memory) {
        IRaveV3Resolver extensionResolver = IRaveV3Resolver(
            extensions[extension.hash()].resolver
        );
        IRaveV3Resolver resolver = IRaveV3Resolver(
            extensionResolver.resolveName(name.hash()).resolver
        );

        if (subdomains.length == 1) {
            return resolver.resolveSubDomain(name.hash(), subdomains[0].hash());
        }

        for (uint64 i = 1; i < subdomains.length; i++) {
            resolver = IRaveV3Resolver(
                resolver.resolveName(subdomains[i].hash()).resolver
            );
        }

        return resolver.resolveName(subdomains[subdomains.length - 1].hash());
    }
}
