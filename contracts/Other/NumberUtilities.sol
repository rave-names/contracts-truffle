pragma solidity >=0.8.18;

// SPDX-License-Identifier: Unlisence

library NumberUtils {
    function toDecimals(
        uint input,
        uint decimals
    ) internal pure returns (uint) {
        return (input * (10 ** decimals));
    }
}
