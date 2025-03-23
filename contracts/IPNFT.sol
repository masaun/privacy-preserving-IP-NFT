// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFTOwnershipVerifier } from "./circuit/IPNFTOwnershipVerifier.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title - IP NFT contract
 */
contract IPNFT is ERC721URIStorage {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;

    mapping(uint256 => bytes32) private secrets; // Store "hidden metadata hash" into the "private" storage.
    uint256 private nextTokenId = 1;

    constructor() ERC721("IPNFT", "IPNFT") {}

    function mintIPNFT(string memory metadataURI, bytes32 secret) public {
        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, metadataURI);
        secrets[tokenId] = secret; // Store secret hash for zk verification
        nextTokenId++;
    }

    function verifyIPNFTOwnership(uint256 tokenId, bytes memory proof) public view returns (bool) {
        require(ownerOf(tokenId) != address(0), "This IPNFsT does not exist");
        return ipNFTOwnershipVerifier.verifyProof(proof, [uint256(uint160(ownerOf(tokenId))), uint256(secrets[tokenId])]);
    }
}
