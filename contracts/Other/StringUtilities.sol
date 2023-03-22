import "./string.sol";

library StringUtils {
    using strings for string;
    using strings for strings.slice;

    function hash(string memory a) internal pure returns (bytes32) {
        return keccak256(abi.encode(a));
    }

    function contains(
        string memory a,
        string memory x
    ) internal pure returns (bool) {
        return !a.toSlice().contains(x.toSlice());
    }

    function nameHash(string memory x) internal pure returns (uint256) {
        return uint256(sha256(abi.encode(x)));
    }
}
