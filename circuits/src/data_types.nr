pub struct IPNftData {
    nft_owner: Field,
    nft_token_id: Field,
    nft_metadata_hash: Field  // Hashed IPFS CID. (IPFS CID for the metadata of NFT, which is generated when uploading to IPFS. And then, the IPFS CID is hashed)
}
