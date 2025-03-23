// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFTOwnershipVerifier } from "./circuit/IPNFTOwnershipVerifier.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title - IP NFT contract
 */
contract IPNFT is ERC721URIStorage {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;

    mapping(uint256 => bytes32) private metadataHashes; // Store a "metadata hash" into the "private" storage.
    uint256 private nextTokenId = 1;

    constructor() ERC721("IPNFT", "IPNFT") {}

    function mintIPNFT(string memory metadataURI, bytes32 metadataHash) public {
        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, metadataURI);
        metadataHashes[tokenId] = metadataHash; // Store a "metadata hash (as a secret) into the "private" storage
        nextTokenId++;
    }

    function verifyIPNFTOwnership(uint256 tokenId, bytes memory proof) public view returns (bool) {
        require(ownerOf(tokenId) != address(0), "This IPNFT does not exist");
        return ipNFTOwnershipVerifier.verifyProof(proof, [uint256(uint160(ownerOf(tokenId))), uint256(secrets[tokenId])]);
    }
}
