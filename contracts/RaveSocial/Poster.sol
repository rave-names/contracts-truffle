pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

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

interface IRaveBase {
    function getNameFromOwner(
        address owner
    ) external view returns (string memory);

    function isOwnedByMapping(string memory name) external view returns (bool);

    function getOwnerOfName(string memory name) external view returns (address);
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

contract Poster is RaveErrors {
    IRaveBase rave;

    constructor(address _rave) {
        rave = IRaveBase(_rave);
    }

    struct Post {
        string text; // contents
        string poster; // owner of the post
        uint256 likes; // amount of likes
        string tag; // a topic
    }

    mapping(bytes32 => Post[]) postsByUser;
    mapping(bytes32 => Post[]) postsByTag;

    //mapping(bytes32 => mapping(Post => bool)) userHasLiked;

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

    function _addPost(
        string memory text,
        string memory poster,
        string memory tag
    ) internal {
        Post memory post = Post(text, poster, 0, tag);
        postsByUser[_makeHash(poster)].push(post);
    }

    function _addLikeToPost(
        uint256 index,
        string memory poster,
        string memory liker
    ) internal {
        Post memory iPost = postsByUser[_makeHash(poster)][index];
        Post memory post = Post(
            iPost.text,
            iPost.poster,
            (iPost.likes + 1),
            iPost.tag
        );
        postsByUser[_makeHash(poster)][index] = post;
        //userHasLiked[_makeHash(liker)][post] = true;
    }

    function _removeLikeFromPost(
        uint256 index,
        string memory poster,
        string memory liker
    ) internal {
        Post memory iPost = postsByUser[_makeHash(poster)][index];
        Post memory post = Post(
            iPost.text,
            iPost.poster,
            (iPost.likes - 1),
            iPost.tag
        );
        postsByUser[_makeHash(poster)][index] = post;
        //  userHasLiked[_makeHash(liker)][post] = false;
    }

    function _getPost(
        uint256 index,
        string memory poster
    ) internal view returns (Post memory) {
        return (postsByUser[_makeHash(poster)][index]);
    }
}
