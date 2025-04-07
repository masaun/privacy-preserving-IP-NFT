// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFTOwnershipVerifier } from "./circuit/IPNFTOwnershipVerifier.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { DataTypeConverter } from "./libraries/DataTypeConverter.sol";

import "forge-std/console.sol";


/**
 * @title - IP NFT contract
 * @notice - NFT can be minted and its ownership can be verified without revealing metadata by verfying a ZK Proof.
 */
contract IPNFT is ERC721URIStorage, Ownable {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;

    mapping(uint256 => mapping(address => mapping(bytes32 => bool))) private nullifiers;        // Store a "nullifier" into the "private" storage.

    uint256 private nextTokenId = 1;

    constructor(IPNFTOwnershipVerifier _ipNFTOwnershipVerifier, address creator) ERC721("IP-NFT", "IP-NFT") Ownable(creator) {
        ipNFTOwnershipVerifier = _ipNFTOwnershipVerifier;
        //transferOwnership(creator); /// @dev - Transfer the ownership of this IPNFT contract to a given creator, who is the caller of the IPNFTFactory#createNewIPNFT() function.
    }

    /**
     * @notice - Mint a new IP-NFT
     * @dev - A given metadata URI is stored in the tokenURI mapping of the ERC721 contract.
     * @dev - A given metadata URI includes a CID (IPFS Hash), where a proof is stored (instead of that its actual metadata is stored)
     * param metadataURI - The URI of the metadata associated with the NFT (i.e. IPFS Hash, which is called "CID")
     */
    function mintIPNFT(bytes calldata proof, bytes32 merkleRoot, bytes32 nullifierHash, bytes32 metadataCidHash) public returns (uint256 tokenId) {
        /// @dev - Convert the data type of a given metadataCidHash from bytes32 to string
        string memory metadataCidHashString = DataTypeConverter.bytes32ToString(metadataCidHash); // Convert bytes32 to string
        console.logString(metadataCidHashString);  // [Log]: 

        /// @dev - Check before/after converting a given metadataCidHash. 
        /// @dev - [NOTE]: We could confirm this check was passed. Hence, the following validation code is commented out for the moment.
        // bytes32 metadataCidHashReversed = DataTypeConverter.stringToBytes32(metadataCidHashString);
        // require(metadataCidHash == metadataCidHashReversed, "metadataCidHash and metadataCidHashReversed must be the same value");
        // console.logBytes32(metadataCidHash);          // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0        
        // console.logBytes32(metadataCidHashReversed);  // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0
        
        /// @dev - Mint a new IP-NFT
        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, metadataCidHashString);    /// @dev - Store a given metadataCidHash, which is a hashed-metadataURI, instead of storing a given metadataURI directly.
        //_setTokenURI(tokenId, metadataURI);   /// @dev - A given metadata URI includes a CID (IPFS Hash), where a proof is stored (instead of that its actual metadata is stored)

        /// @dev - Verify the proof
        bytes32[] memory publicInputs = new bytes32[](3);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = nullifierHash;
        publicInputs[2] = metadataCidHash; // [NOTE]: The tokenId is used as a public input to verify the proof.
        bool isValidProof = ipNFTOwnershipVerifier.verifyIPNFTOwnershipProof(proof, publicInputs);
        require(isValidProof, "Invalid proof");
        //require(ipNFTOwnershipVerifier.verifyIPNFTOwnershipProof(proof, publicInputs), "Invalid proof");  
        console.logBool(isValidProof); // [Log]: true

        /// @dev - Save a nullifier to prevent double-spending of a proof.
        nullifiers[tokenId][ownerOf(tokenId)][nullifierHash] = true;
        
        nextTokenId++;

        return tokenId;
    }

    /** 
     * @notice - Check whether or not a given proof is valid without revealing metadata
     */
    function verifyIPNFTOwnershipProof(uint256 tokenId, bytes calldata proof, bytes32 merkleRoot, bytes32 nullifierHash) public view returns (bool isValidProof) {
        require(ownerOf(tokenId) != address(0), "This IPNFT does not exist");
        
        require(!nullifiers[tokenId][ownerOf(tokenId)][nullifierHash], "This ZK Proof has already been submitted"); // Prevent from 'double-spending' of a ZK Proof.
        //nullifiers[nullifierHash] = true;

        bytes32[] memory publicInputs = new bytes32[](2);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = nullifierHash;
        return ipNFTOwnershipVerifier.verifyIPNFTOwnershipProof(proof, publicInputs); // If "False", this proof is invalid
    }
}
