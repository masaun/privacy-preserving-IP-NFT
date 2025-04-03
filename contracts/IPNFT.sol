// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFTOwnershipVerifier } from "./circuit/IPNFTOwnershipVerifier.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title - IP NFT contract
 * @notice - NFT can be minted and its ownership can be verified without revealing metadata by verfying a ZK Proof.
 */
contract IPNFT is ERC721URIStorage {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;

    mapping(uint256 => bytes32) private metadataHashes; // Store a "metadata hash" into the "private" storage.
    mapping(bytes32 => bool) private nullifiers;        // Store a "nullifier" into the "private" storage.

    uint256 private nextTokenId = 1;

    constructor() ERC721("IP-NFT", "IP-NFT") {}

    /**
     * @notice - Mint a new IP-NFT
     * @dev - A given metadata URI is stored in the tokenURI mapping of the ERC721 contract.
     * @dev - A given metadata URI includes a CID (IPFS Hash), where a proof is stored (instead of that its actual metadata is stored)
     * @param metadataURI - The URI of the metadata associated with the NFT (i.e. IPFS Hash, which is called "CID")
     */
    function mintIPNFT(string memory metadataURI, bytes32 metadataHash) public {
        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, metadataURI);     /// @dev - A given metadata URI includes a CID (IPFS Hash), where a proof is stored (instead of that its actual metadata is stored)
        metadataHashes[tokenId] = metadataHash; /// Store a "metadata hash (as a secret) into the "private" storage
        nextTokenId++;
    }

    /** 
     * @notice - Verify the proof without revealing metadata
     */
    function verifyIPNFTOwnership(uint256 tokenId, bytes calldata proof, bytes32 merkleRoot, bytes32 nullifierHash) public view returns (bool isValidProof) {
        require(ownerOf(tokenId) != address(0), "This IPNFT does not exist");
        
        require(!nullifiers[nullifierHash], "This ZK Proof has been already submitted"); // Prevent from 'double-spending' of a ZK Proof.
        nullifiers[nullifierHash] = true;

        bytes32[] memory publicInputs = new bytes32[](2);
        publicInputs[0] = merkleRoot;
        publicInputs[1] = nullifierHash;
        return ipNFTOwnershipVerifier.verifyIPNFTOwnership(proof, publicInputs); // If "False", this proof is invalid
    }
}
