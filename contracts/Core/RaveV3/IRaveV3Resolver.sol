pragma solidity ^0.8.19;
/*
 * An interface for RaveV3 to resolve names based on external rules.
 *
 * For example, a protocol wishes to tie an ownership of a name directly to
 * ownership of a token. They could do this using an on-chain RaveV3 resolver
 * that actively validates what address owns the tokenId, and also add some
 * logic to it, e.g. make sure a custodial NFT marketplace isnt resolved as
 * the owner/resolvee of the name.
 *
 */

import {Name} from "./RaveStructs.sol";

interface IRaveV3Resolver {
    function acceptsRAVE() external view returns (bool);

    function resolveName(bytes32 name) external view returns (Name memory);

    function registerName(
        string calldata name,
        address owner,
        address resolver
    ) external;

    function resolveSubDomain(
        bytes32 name,
        bytes32 subdomain
    ) external view returns (Name memory);

    function getController(
        string calldata name
    ) external view returns (address);

    function getOwned(bytes32 name) external view returns (bool);

    function getUSDPrice(uint characters) external returns (uint);

    function getRecord(
        bytes32 name,
        bytes32 key
    ) external view returns (string memory);

    function setSubDomainResolver(bytes32 name, address resolvee) external;

    function setResolver(bytes32 name, address resolver) external;

    function setRecord(
        bytes32 name,
        bytes32 key,
        string calldata value
    ) external;
}
