pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import "forge-std/console.sol";

import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { UltraVerifier } from "../../contracts/circuit/plonk_vk.sol";
//import { UltraVerifier } from "../../circuits/target/contract.sol";
import { ProofConverter } from "./utils/ProofConverter.sol";

//import { PoseidonUnit5L } from "iden3-contracts/lib/Poseidon.sol"; /// @dev - iden3/contracts/contracts/lib/Poseidon.sol --> [NOTE]: Import path has been adjusted. See the remapping.txt

contract VerifyScript is Script {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        // @dev - Test
        uint256 resultInPoseidonHash = computePoseidon2Hash([uint256(1), uint256(2), uint256(3), uint256(4), uint256(5)]);
        console.logUint(resultInPoseidonHash);


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


    function computePoseidon2Hash(uint256[5] memory inputs) public returns (uint256) {
        // Generate the proof by calling the script using ffi
        string[] memory ffi_command = new string[] (2);
        ffi_command[0] = "./script/utils/poseidon2-hash-generator/usages/sync/runningScript_poseidon2HashGenerator.sh";
        //ffi_command[1] = _testName;
        bytes memory commandResponse = vm.ffi(ffi_command);

        //return PoseidonUnit5L.poseidon(inputs); // PoseidonUnit5L for 5 inputs
        return 1; // Temporary
    }

}
