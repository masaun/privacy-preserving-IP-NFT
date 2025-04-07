pragma solidity ^0.8.17;

import { UltraVerifier } from "../contracts/circuit/ultra-verifier/plonk_vk.sol";
import { IPNFTOwnershipVerifier } from "../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { IPNFTFactory } from "../contracts/IPNFTFactory.sol";
import { IPNFT } from "../contracts/IPNFT.sol";

import { DataTypeConverter } from "../contracts/libraries/DataTypeConverter.sol";

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
        //string memory metadataCidHash = "0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8";  /// @dev - This is a hashed-metadataURI.
        //bytes32 metadataCidHash = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8; // Replace with actual metadata hash

        (bytes memory proof, bytes32[] memory publicInputs) = generateNewProof(); // Generate proof and merkle root using NoirHelper
        bytes32 merkleRoot = publicInputs[0];
        bytes32 nullifierHash = publicInputs[1];
        bytes32 metadataCidHash = publicInputs[2]; // Convert bytes32 to string

        /// @dev - Mint a new IP-NFT
        uint256 tokenId = ipNFT.mintIPNFT(proof, merkleRoot, nullifierHash, metadataCidHash); /// @dev - Store a given metadataCidHash, which is a hashed-metadataURI, instead of storing a given metadataURI directly.
        //uint256 tokenId = ipNFT.mintIPNFT(metadataURI, metadataCidHash, proof, merkleRoot, nullifierHash);

        /// @dev - Convert the data type of a given metadataCidHash from bytes32 to string
        string memory metadataCidHashString = DataTypeConverter.bytes32ToString(metadataCidHash); // Convert bytes32 to string
        console.logString(metadataCidHashString);  // [Log]: 

        /// @dev - Check the tokenURI, which is associated with a given tokenId of IPNFT, is equal to a given string version of metadataCidHash.
        assertEq(metadataCidHashString, ipNFT.tokenURI(tokenId));

        /// @dev - Check before/after converting a given metadataCidHash.
        bytes32 metadataCidHashReversed = DataTypeConverter.stringToBytes32(metadataCidHashString);
        console.logBytes32(metadataCidHashReversed);  // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0
        console.logBytes32(metadataCidHash);          // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0        
        assertEq(metadataCidHash, metadataCidHashReversed); // @dev - metadataCidHash and metadataCidHashReversed must be the same value.
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

        /// @dev - Set the input data for generating a proof
        noirHelper.withInput("root", bytes32(uint256(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629)))
                  .withInput("hash_path", hash_path_bytes32)
                  .withInput("index", bytes32(uint256(0)))
                  .withInput("secret", bytes32(uint256(1)))                   
                  .withInput("expected_nullifier", bytes32(uint256(0x26df0d347e961cb94e1cc6d2ad8558696de8c1964b30e26f2ec8b926cbbbf862)))
                  .withInput("expected_nft_metadata_cid_hash", bytes32(uint256(0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0)))
                  .withStruct("ip_nft_data")
                  .withStructInput("nft_owner", bytes32(uint256(uint160(0xC6093Fd9cc143F9f058938868b2df2daF9A91d28)))) // [NOTE]: An input data of 'Address' type must be cast to uint160 first. Then, it should be cast to uint256 and bytes32.
                  .withStructInput("nft_token_id", bytes32(uint256(1)))
                  .withStructInput("nft_metadata_cid", string('QmYwAPJzv5CZsnAzt8auVZRn5W4mBkpLsD4HaBFN6r5y6F'));

        /// @dev - Generate the proof
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 3); // [NOTE]: The number of public inputs is '3'.
        console.logBytes32(publicInputs[0]); // [Log]: 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629
        console.logBytes32(publicInputs[1]); // [Log]: 0x26df0d347e961cb94e1cc6d2ad8558696de8c1964b30e26f2ec8b926cbbbf862
        console.logBytes32(publicInputs[2]); // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0
        return (proof, publicInputs);
    }
}