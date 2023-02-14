pragma solidity >=0.8.12;

import "./RaveV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract GooolSpace is Ownable, Initializable {
    struct NFT {
        address address_;
        uint256 tokenId;
    }

    struct Profile {
        string website; // 0
        string twitter; // 1
        string discord; // 2
        string telegram; // 3
        string email; // 4
        string github; // 5
        NFT[8] nfts;
        string[3] posts;
    }

    Rave registrar;
    mapping(bytes32 => Profile) profiles;

    // bytes32 is much better to use than string, so we pass a string value into this function and get a bytes32 back.
    function _makeHash(string memory input) internal pure returns (bytes32) {
        return keccak256(abi.encode(input));
    }

    function initialize(address _registrar) public payable initializer {
        registrar = Rave(_registrar);
        require(
            _makeHash(registrar.extension()) == _makeHash("goool"),
            "GooolSpace: Registrar extension must be .goool"
        );
    }

    function _verifyOwnership(
        string memory name,
        address caller
    ) internal view returns (bool) {
        (bool isOwned, bool isOwner) = (
            registrar.owned(name),
            ((registrar.getOwner(name) == caller) &&
                (registrar.balanceOf(caller) > 0))
        );
        bool success = isOwned && isOwner;
        return success;
    }

    modifier mustPassOwnershipTest(string memory name, address sender) {
        require(
            _verifyOwnership(name, sender),
            string.concat("GooolSpace: Not the owner of ", name)
        );
        _;
    }

    function _setAttribute(
        bytes32 name,
        string calldata attribute,
        uint8 id
    ) internal {
        if (id == 0) {
            profiles[name].website = attribute;
        } else if (id == 1) {
            profiles[name].twitter = attribute;
        } else if (id == 2) {
            profiles[name].discord = attribute;
        } else if (id == 3) {
            profiles[name].telegram = attribute;
        } else if (id == 4) {
            profiles[name].email = attribute;
        } else if (id == 5) {
            profiles[name].github = attribute;
        } else {
            revert();
        }
    }

    function setWebsite(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 0);
    }

    function setTwitter(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 1);
    }

    function setDiscord(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 2);
    }

    function setTelegram(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 3);
    }

    function setEmail(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 4);
    }

    function setGithub(
        string calldata name,
        string calldata attribute
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        _setAttribute(_makeHash(name), attribute, 5);
    }

    function setNFT(
        string calldata name,
        uint index,
        NFT calldata nft
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        require(
            (IERC721(nft.address_).ownerOf(nft.tokenId)) == msg.sender,
            "GooolSpace: You must own the NFT to add it to your gallery"
        );
        profiles[_makeHash(name)].nfts[index] = nft;
    }

    function post(
        string calldata name,
        string calldata content
    ) external payable mustPassOwnershipTest(name, msg.sender) {
        profiles[_makeHash(name)].posts[2] = profiles[_makeHash(name)].posts[1];
        profiles[_makeHash(name)].posts[1] = profiles[_makeHash(name)].posts[0];
        profiles[_makeHash(name)].posts[0] = content;
    }

    function getData(
        string calldata name
    ) external view returns (Profile memory) {
        return profiles[_makeHash(name)];
    }
}
