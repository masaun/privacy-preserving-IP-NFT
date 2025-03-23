pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import { IPNFTOwnershipVerifier } from "../../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { UltraVerifier } from "../../contracts/circuit/plonk_vk.sol";
//import { UltraVerifier } from "../../circuits/target/contract.sol";
import { ProofConverter } from "../utils/ProofConverter.sol";

contract VerifyScript is Script {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        uint256 deployerPrivateKey = vm.envUint("EDU_CHAIN_TESTNET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        /// @dev - Read the each deployed address from the configuration file.
        address ULTRAVERIFER = vm.envAddress("ULTRAVERIFER_ON_EDU_CHAIN_TESTNET");
        address IPNFT_OWNERSHIP_VERIFIER = vm.envAddress("IPNFT_OWNERSHIP_VERIFIER_ON_EDU_CHAIN_TESTNET");

        /// @dev - Create the SC instances /w deployed SC addresses
        verifier = UltraVerifier(ULTRAVERIFER);
        ipNFTOwnershipVerifier = IPNFTOwnershipVerifier(IPNFT_OWNERSHIP_VERIFIER);
        // verifier = new UltraVerifier();
        // ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/ip_nft_ownership_proof.bin");
        bytes memory proofBytes = ProofConverter.sliceAfter64Bytes(proof_w_inputs);
        //bytes memory proofBytes = sliceAfter64Bytes(proof_w_inputs);
        //string memory proof = vm.readLine("./circuits/target/ip_nft_ownership_proof.bin");
        //bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correct = new bytes32[](2);
        correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);
        correct[1] = correct[0];

        bool isValidProof = ipNFTOwnershipVerifier.verifyIPNFTOwnership(proofBytes, correct);
        return isValidProof;
    }
}
