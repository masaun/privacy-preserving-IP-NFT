pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import "forge-std/console.sol";

import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { UltraVerifier } from "../../contracts/circuit/plonk_vk.sol";
//import { UltraVerifier } from "../../circuits/target/contract.sol";
import { ProofConverter } from "./utils/ProofConverter.sol";
import { DataTypeConverter } from "../../contracts/libraries/DataTypeConverter.sol";


contract VerifyScript is Script {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        // @dev - Test
        //bytes32 resultInPoseidonHash = computePoseidon2Hash();
        //console.logBytes32(resultInPoseidonHash);


        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);

        bytes32 merkleRoot = 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629;
        bytes32 nullifierHash = computePoseidon2Hash(); // [TODO]: This should be "0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373"
        //bytes32 nullifierHash = 10190015755989328289879378487807721086446093622177241109507523918927702106995;
        console.logBytes32(nullifierHash);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/ip_nft_ownership_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);
        // string memory proof = vm.readLine("./circuits/target/ip_nft_ownership_proof.bin");
        // bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correctPublicInputs = new bytes32[](2);
        correctPublicInputs[0] = merkleRoot;
        correctPublicInputs[1] = nullifierHash;

        bool isValidProof = ipNFTOwnershipVerifier.verifyIPNFTOwnership(proofBytes, correctPublicInputs);
        return isValidProof;
    }

    /**
     * @dev - Compute Poseidon2 hash
     */
    function computePoseidon2Hash() public returns (bytes32) {
        /// @dev - Run the Poseidon2 hash generator script
        string[] memory ffi_commands_for_generating_poseidon2_hash = new string[](2);
        ffi_commands_for_generating_poseidon2_hash[0] = "sh";
        ffi_commands_for_generating_poseidon2_hash[1] = "script/utils/poseidon2-hash-generator/usages/sync/runningScript_poseidon2HashGenerator.sh";
        bytes memory commandResponse = vm.ffi(ffi_commands_for_generating_poseidon2_hash);
        console.log(string(commandResponse));

        /// @dev - Write the output.json of the Poseidon2 hash-generated and Read the 'hash' field from the output.json
        string[] memory ffi_commands_for_generating_output_json = new string[](3);
        ffi_commands_for_generating_output_json[0] = "sh";
        ffi_commands_for_generating_output_json[1] = "-c";
        ffi_commands_for_generating_output_json[2] = "cat script/utils/poseidon2-hash-generator/usages/sync/output/output.json | grep 'hash' | awk -F '\"' '{print $4}'"; // Extracts the 'hash' field

        bytes memory poseidon2HashBytes = vm.ffi(ffi_commands_for_generating_output_json);
        string memory poseidon2HashString = string(poseidon2HashBytes);
        console.log("Poseidon2 Hash (read from the output.json):", poseidon2HashString);

        /// @dev - Convert the data type of the poseidon2 hash-generated from bytes to bytes32
        bytes32 poseidon2HashBytes32 = DataTypeConverter.bytesToBytes32(poseidon2HashBytes);
        console.logBytes32(poseidon2HashBytes32);

        /// @dev - Test of 254-bit covertion operation
        uint256 hashIn254Bit = hashToField(poseidon2HashBytes32);
        console.logUint(hashIn254Bit); // [Log]: 22248477967052183372107787209157336655320796416731665409264174357672973840439

        //return poseidon2HashBytes;
        return poseidon2HashBytes32;
    }

    function hashToField(bytes32 hash) public pure returns (uint256) {
        uint256 FIELD_MODULUS = (1 << 254) - 1; // 2^254 - 1
        return uint256(hash) % FIELD_MODULUS; // Reduce to 254-bit range
    }

}