pragma solidity ^0.8.17;

import { UltraVerifier } from "../contracts/circuit/ultra-verifier/plonk_vk.sol";
import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { IPNFTFactory } from "../contracts/IPNFTFactory.sol";
import { IPNFT } from "../contracts/IPNFT.sol";

import "forge-std/console.sol";

import { Test } from "forge-std/Test.sol";
import { NoirHelper } from "foundry-noir-helper/NoirHelper.sol";


contract IPNFTTest is Test {
    UltraVerifier public verifier;
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    IPNFTFactory public ipNFTFactory;
    //IPNFT public ipNFT;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);
        ipNFTFactory = new IPNFTFactory(ipNFTOwnershipVerifier); /// @dev - Deploy the IPNFTFactory contract
    }

    function test_createNewIPNFT() public {
        IPNFT ipNFT = ipNFTFactory.createNewIPNFT();
        console.log(address(ipNFT));            // [Log]: 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        assertEq(ipNFT.owner(), address(this)); // Verify the owner is set correctly
    }

    /**
     * @notice - Mint a new IP-NFT
     */
    function test_mintIPNFT() public {
        /// @dev - Deploy a new IPNFT contrac
        IPNFT ipNFT = ipNFTFactory.createNewIPNFT();
        console.log(address(ipNFT));            // [Log]: 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        assertEq(ipNFT.owner(), address(this)); // Verify the owner is set correctly

        /// @dev - Generate a proof /w public inputs
        //string memory metadataURI = "ipfs://QmYwAPJzv5CZsnAzt8auVZRn5W4mBkpLsD4HaBFN6r5y6F";       // Replace with actual IPFS URI
        string memory metadataHash = "0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8";  /// @dev - This is a hashed-metadataURI.
        //bytes32 metadataHash = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8; // Replace with actual metadata hash

        bytes32 merkleRoot;
        bytes32 nullifierHash;
        (bytes memory proof, bytes32[] memory publicInputs) = generateNewProof(); // Generate proof and merkle root using NoirHelper
        merkleRoot = publicInputs[0];
        nullifierHash = publicInputs[1];

        /// @dev - Mint a new IP-NFT
        uint256 tokenId = ipNFT.mintIPNFT(metadataHash, proof, merkleRoot, nullifierHash); /// @dev - Store a given metadataHash, which is a hashed-metadataURI, instead of storing a given metadataURI directly.
        //uint256 tokenId = ipNFT.mintIPNFT(metadataURI, metadataHash, proof, merkleRoot, nullifierHash);
    }

    /**
     * @notice - Generate a new proof using NoirHelper
     */
    function generateNewProof() public returns (bytes memory _proof, bytes32[] memory _publicInputs) {
        uint256[] memory hash_path = new uint256[](2);
        hash_path[0] = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8;
        hash_path[1] = 0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77;

        bytes32[] memory hash_path_bytes32 = new bytes32[](2);
        hash_path_bytes32[0] = bytes32(hash_path[0]);
        hash_path_bytes32[1] = bytes32(hash_path[1]);

        noirHelper.withInput("root", bytes32(uint256(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629)))
                  .withInput("hash_path", hash_path_bytes32)
                  .withInput("index", bytes32(uint256(0)))
                  .withInput("secret", bytes32(uint256(1)))                   
                  .withInput("expected_nullifier", bytes32(uint256(0x1265c921cb8e0dc6c91f70ae08b14352b8f10451aee7582b9ed44abea8d4123c)))
                  .withStruct("ip_nft_data")
                  .withStructInput("nft_owner", bytes32(uint256(uint160(0xC6093Fd9cc143F9f058938868b2df2daF9A91d28)))) // [NOTE]: An input data of 'Address' type must be cast to uint160 first. Then, it should be cast to uint256 and bytes32.
                  .withStructInput("nft_token_id", bytes32(uint256(1)))
                  .withStructInput("nft_metadata_cid", bytes32(uint256(0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8)));

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 2);
        console.logBytes32(publicInputs[0]); // [Log]: 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629
        console.logBytes32(publicInputs[1]); // [Log]: 0x1265c921cb8e0dc6c91f70ae08b14352b8f10451aee7582b9ed44abea8d4123c
        return (proof, publicInputs);
    }
}