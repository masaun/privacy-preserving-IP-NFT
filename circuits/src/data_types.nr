pub struct IPNftData {
    nft_owner: Field,
    nft_token_id: Field,
    nft_metadata_hash: Field  // IPFS CID, which is hashed (IPFS CID for the metadata of NFT, which is generated when uploading to IPFS)}
}

pub struct RevealedData {
    nullifier: Field,
    nft_metadata_cid_hash: Field,
}