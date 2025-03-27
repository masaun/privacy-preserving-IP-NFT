use std::hash::poseidon2;
mod tests;      // tests/mod.nr
mod data_types; // data_types.nr

use data_types::IPNftData; // @dev - IPNftData struct



fn main(
    root: pub Field, // @dev - Merkle Root
    hash_path: [Field; 2],
    index: Field,
    secret: Field,   // @dev - A hidden metadata hash (private)
    expected_nullifier: Field,
    ip_nft_data: IPNftData
) -> pub Field {
    let inputs_for_note_commitment: [Field; 1] = [secret];
    let note_commitment = poseidon2::Poseidon2::hash(inputs_for_note_commitment, inputs_for_note_commitment.len());
    //let note_commitment = std::hash::pedersen_hash([secret]);

    let inputs_for_nullifier: [Field; 5] = [root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash];
    let nullifier = poseidon2::Poseidon2::hash(inputs_for_nullifier, inputs_for_nullifier.len());
    //let nullifier = std::hash::pedersen_hash([root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash]);
    
    // Constraint: nullifier (hash) == expected_nullifier (hash)
    assert(nullifier == expected_nullifier);

    // [TODO]: Constraint: root == check_root
    //let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    //assert(root == check_root);

    nullifier
}
