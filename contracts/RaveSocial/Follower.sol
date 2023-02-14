pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

interface IRaveBase {
    function getNameFromOwner(
        address owner
    ) external view returns (string memory);

    function isOwnedByMapping(string memory name) external view returns (bool);

    function getOwnerOfName(string memory name) external view returns (address);
}

library Strings {
    function compare(
        string memory _a,
        string memory _b
    ) internal pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i++)
            if (a[i] < b[i]) return -1;
            else if (a[i] > b[i]) return 1;
        if (a.length < b.length) return -1;
        else if (a.length > b.length) return 1;
        else return 0;
    }

    /// @dev Compares two strings and returns true iff they are equal.
    function equal(
        string memory _a,
        string memory _b
    ) internal pure returns (bool) {
        return compare(_a, _b) == 0;
    }
}

contract RaveErrors {
    struct Error {
        uint16 code;
        string message;
    }

    struct ErrorWithFallback {
        bool isError;
        Error error;
    }

    Error internal PASS = Error(0, "RaveErrors (0): Passed");

    Error internal NOT_AUTHORISED =
        Error(401, "RaveErrors (401): Not authorised to perform this action.");
    Error internal NOT_FOUND =
        Error(
            404,
            "RaveErrors (404): Name not found [try querying in all-capitals]"
        );
}

contract Follower is RaveErrors {
    IRaveBase rave;

    struct Profile {
        uint256 followers;
        uint256 follows;
    }

    mapping(bytes32 => mapping(bytes32 => bool)) following;
    mapping(bytes32 => string[]) followings;
    mapping(bytes32 => uint256) followers;
    mapping(bytes32 => uint256) follows;

    constructor(address _rave) {
        rave = IRaveBase(_rave);
    }

    function _verifyOwnership(
        string memory name,
        address owner
    ) internal view returns (ErrorWithFallback memory) {
        // HACKERMAN (https://betterttv.com/emotes/604e7880306b602acc59cf5e)
        (bool owned, bool isOwned) = (
            rave.isOwnedByMapping(name),
            ((rave.getOwnerOfName(name) == owner) &&
                (Strings.equal(rave.getNameFromOwner(owner), name)))
        );
        bool success = (owned && isOwned);
        return
            owned
                ? (
                    ErrorWithFallback(
                        !(success),
                        (success ? PASS : NOT_AUTHORISED)
                    )
                )
                : ErrorWithFallback(true, NOT_FOUND);
    }

    modifier mustPassOwnershipTest(string memory name, address sender) {
        ErrorWithFallback memory test = _verifyOwnership(name, sender);
        require(!(test.isError), test.error.message);

        _; // proceed as normal
    }

    // bytes32 is much better to use than string, so we pass a string memory value into this function and get a bytes32 back.
    function _makeHash(string memory input) internal pure returns (bytes32) {
        return keccak256(abi.encode(input));
    }

    function _changeFollowStatus(
        string memory follower,
        string memory followee,
        bool change
    ) internal {
        bytes32 _follower = _makeHash(follower);
        bytes32 _followee = _makeHash(followee);
        following[_follower][_followee] = change;
        followings[_follower].push(followee);
        if (change) {
            followers[_followee] += 1;
            follows[_follower] += 1;
        } else {
            followers[_followee] -= 1;
            follows[_follower] -= 1;
        }
    }

    function _getFollowStatus(
        string memory follower,
        string memory followee
    ) internal view returns (bool) {
        bytes32 _follower = _makeHash(follower);
        bytes32 _followee = _makeHash(followee);
        return following[_makeHash(followee)][_makeHash(follower)];
    }

    function _getProfileDetails(
        string memory profile
    ) internal view returns (Profile memory) {
        return
            Profile(followers[_makeHash(profile)], follows[_makeHash(profile)]);
    }

    function _getFollowings(
        string memory profile
    ) internal view returns (string[] memory) {
        return followings[_makeHash(profile)];
    }

    function follow(
        string memory follower,
        string memory followee
    ) external mustPassOwnershipTest(follower, msg.sender) {
        _changeFollowStatus(follower, followee, true);
    }

    function unfollow(
        string memory follower,
        string memory followee
    ) external mustPassOwnershipTest(follower, msg.sender) {
        _changeFollowStatus(follower, followee, false);
    }

    function getFollowings(
        string memory profile
    ) external view returns (string[] memory) {
        return _getFollowings(profile);
    }

    function doesFollow(
        string memory follower,
        string memory followee
    ) external view returns (bool) {
        return _getFollowStatus(follower, followee);
    }
}
