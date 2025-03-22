use dep::std;
mod tests;      // tests/mod.nr
mod data_types; // data_types.nr

use data_types::IPNftData; // @dev - IPNftData struct


fn main(
    root: pub Field, // @dev - Merkle Root
    hash_path: [Field; 2],
    index: Field,
    secret: Field,   // @dev - a one time secret code that was distributed to each customer (before the proof generation get started)
    ip_nft_data: IPNftData
) -> pub Field {
    let note_commitment = std::hash::pedersen_hash([secret]);
    let nullifier = std::hash::pedersen_hash([root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash]);

    // Constraint: root == check_root
    let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    assert(root == check_root);

    nullifier
}
