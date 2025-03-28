pragma solidity ^0.8.17;

import "forge-std/console.sol";

/**
 * @title DataTypeConverter library
 */
library DataTypeConverter {

    /// @notice - Convert bytes to bytes32
    function bytesToBytes32(bytes memory data) internal pure returns (bytes32 result) {
        //console.logBytes(data);
        return bytes32(data);
    }

    /// @notice - Convert bytes32 to bytes
    // function bytes32ToBytes(bytes32 data) public pure returns (bytes memory) {
    //     uint256 len = 32;
    //     while (len > 0 && data[len - 1] == 0) {
    //         len--;
    //     }
    //     bytes memory result = new bytes(len);
    //     for (uint256 i = 0; i < len; i++) {
    //         result[i] = data[i];
    //     }
    //     return result;
    // }

    /// @notice - Convert string to bytes32
    // function stringToBytes32(string memory str) public pure returns (bytes32 result) {
    //     require(bytes(str).length <= 32, "String too long");
    //     assembly {
    //         result := mload(add(str, 32))
    //     }
    // }



}