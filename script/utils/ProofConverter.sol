pragma solidity ^0.8.17;


/**
 * @title ProofConverter library
 */
library ProofConverter {
    /**
     * @dev - Utility function, because the proof file includes the public inputs at the beginning
     */
    function sliceAfter64Bytes(bytes memory data) internal pure returns (bytes memory) {
        uint256 length = data.length - 64;
        bytes memory result = new bytes(data.length - 64);
        for (uint i = 0; i < length; i++) {
            result[i] = data[i + 64];
        }
        return result;
    }
}