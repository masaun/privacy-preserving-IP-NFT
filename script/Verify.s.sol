pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { UltraVerifier } from "../../contracts/circuit/plonk_vk.sol";
//import { UltraVerifier } from "../../circuits/target/contract.sol";
import { ProofConverter } from "./utils/ProofConverter.sol";

contract VerifyScript is Script {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/ip_nft_ownership_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);
        // bytes memory proofBytes = sliceAfter64Bytes(proof_w_inputs);
        // string memory proof = vm.readLine("./circuits/target/ip_nft_ownership_proof.bin");
        // bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correct = new bytes32[](2);
        correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);
        correct[1] = correct[0];

        bool equal = ipNFTOwnershipVerifier.verifyIPNFTOwnership(proofBytes, correct);
        return equal;
    }

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
