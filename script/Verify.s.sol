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
        bytes32 resultInPoseidonHash = computePoseidon2Hash();
        console.logBytes32(resultInPoseidonHash);


        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/ip_nft_ownership_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);
        // string memory proof = vm.readLine("./circuits/target/ip_nft_ownership_proof.bin");
        // bytes memory proofBytes = vm.parseBytes(proof);

        bytes32 merkleRoot = 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629;
        bytes32 nullifierHash = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8;

        bytes32[] memory correctPublicInputs = new bytes32[](2);
        correctPublicInputs[0] = merkleRoot;
        correctPublicInputs[1] = nullifierHash;

        bool isValidProof = ipNFTOwnershipVerifier.verifyIPNFTOwnership(proofBytes, correctPublicInputs);
        return isValidProof;
    }


    function computePoseidon2Hash() public returns (bytes32) {

        string[] memory ffi_commands = new string[](3);
        ffi_commands[0] = "sh";
        ffi_commands[1] = "-c";
        ffi_commands[2] = "cat script/utils/poseidon2-hash-generator/usages/sync/output/output.json | grep 'hash' | awk -F '\"' '{print $4}'"; // Extracts the 'hash' field

        bytes memory poseidon2HashBytes = vm.ffi(ffi_commands);
        string memory poseidon2HashString = string(poseidon2HashBytes);
        console.log("Poseidon2 Hash (read from the output.json):", poseidon2HashString);

        // string[] memory ffi_commands = new string[](1);
        // ffi_commands[0] = "./utils/poseidon2-hash-generator/usages/sync/runningScript_poseidon2HashGenerator.sh";
        // //ffi_command[1] = _testName;
        // bytes memory commandResponse = vm.ffi(ffi_commands);
        // console.log(string(commandResponse));

        bytes32 poseidon2HashBytes32 = DataTypeConverter.bytesToBytes32(poseidon2HashBytes);
        console.logBytes32(poseidon2HashBytes32);

        return poseidon2HashBytes32;
    }

}