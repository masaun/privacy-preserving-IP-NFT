pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import "forge-std/console.sol";

import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { UltraVerifier } from "../../contracts/circuit/ultra-verifier/plonk_vk.sol";
//import { UltraVerifier } from "../../circuits/target/contract.sol";
import { ProofConverter } from "./utils/ProofConverter.sol";
import { DataTypeConverter } from "../../contracts/libraries/DataTypeConverter.sol";


contract VerifyScript is Script {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    UltraVerifier public verifier;

    struct Poseidon2HashAndPublicInputs {
        string hash;
        bytes32 merkleRoot;
        bytes32 nftMetadataCidHash;
        bytes32 nullifier;
    }

    function setUp() public {}

    function run() public returns (bool) {
        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);

        // @dev - Retrieve the Poseidon2 hash and public inputs, which was read from the output.json file
        Poseidon2HashAndPublicInputs memory poseidon2HashAndPublicInputs = computePoseidon2Hash();
        bytes32 merkleRoot = poseidon2HashAndPublicInputs.merkleRoot;   // [Log]: 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629
        bytes32 nullifierHash = poseidon2HashAndPublicInputs.nullifier; // [Log]: 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373
        bytes32 nftMetadataCidHash = poseidon2HashAndPublicInputs.nftMetadataCidHash; // [Log]:
        console.logBytes32(merkleRoot);          // [Log]: 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629
        console.logBytes32(nullifierHash);       // [Log]: 0x26df0d347e961cb94e1cc6d2ad8558696de8c1964b30e26f2ec8b926cbbbf862
        console.logBytes32(nftMetadataCidHash);  // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/ip_nft_ownership_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);
        // string memory proof = vm.readLine("./circuits/target/ip_nft_ownership_proof.bin");
        // bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correctPublicInputs = new bytes32[](3);
        correctPublicInputs[0] = merkleRoot;
        correctPublicInputs[1] = nullifierHash;
        correctPublicInputs[2] = nftMetadataCidHash;

        bool isValidProof = ipNFTOwnershipVerifier.verifyIPNFTOwnershipProof(proofBytes, correctPublicInputs);
        return isValidProof;
    }

    /**
     * @dev - Compute Poseidon2 hash
     */
    function computePoseidon2Hash() public returns (Poseidon2HashAndPublicInputs memory _poseidon2HashAndPublicInputs) {
        /// @dev - Run the Poseidon2 hash generator script
        string[] memory ffi_commands_for_generating_poseidon2_hash = new string[](2);
        ffi_commands_for_generating_poseidon2_hash[0] = "sh";
        ffi_commands_for_generating_poseidon2_hash[1] = "script/utils/poseidon2-hash-generator/usages/async/runningScript_poseidon2HashGeneratorWithAsync.sh";
        bytes memory commandResponse = vm.ffi(ffi_commands_for_generating_poseidon2_hash);
        console.log(string(commandResponse));

        /// @dev - Write the output.json of the Poseidon2 hash-generated and Read the 'hash' field from the output.json
        string[] memory ffi_commands_for_generating_output_json = new string[](3);
        ffi_commands_for_generating_output_json[0] = "sh";
        ffi_commands_for_generating_output_json[1] = "-c";
        ffi_commands_for_generating_output_json[2] = "cat script/utils/poseidon2-hash-generator/usages/async/output/output.json | grep 'hash' | awk -F '\"' '{print $4}'"; // Extracts the 'hash' field

        bytes memory poseidon2HashBytes = vm.ffi(ffi_commands_for_generating_output_json);
        //console.logBytes(poseidon2HashBytes);

        /// @dev - Read the output.json file and parse the JSON data
        string memory json = vm.readFile("script/utils/poseidon2-hash-generator/usages/async/output/output.json");
        console.log(json);
        bytes memory data = vm.parseJson(json);
        Poseidon2HashAndPublicInputs memory poseidon2HashAndPublicInputs = abi.decode(data, (Poseidon2HashAndPublicInputs));
        //console.logBytes(data);
        console.logString(poseidon2HashAndPublicInputs.hash);
        console.logBytes32(poseidon2HashAndPublicInputs.merkleRoot);
        console.logBytes32(poseidon2HashAndPublicInputs.nullifier);
        console.logBytes32(poseidon2HashAndPublicInputs.nftMetadataCidHash);

        return poseidon2HashAndPublicInputs;
    }

}