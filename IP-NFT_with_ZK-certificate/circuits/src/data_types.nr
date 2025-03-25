pub struct IPNftData {
    nft_owner: Field,
    nft_token_id: Field,
    metadata_cid_hash: Field  // IPFS CID for the metadata of NFT, which is generated when uploading to IPFS.
}
