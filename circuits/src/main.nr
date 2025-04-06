mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
mod converters; // converters.nr -> converters/convert_cid_to_poseidon_hash.nr -> convert_nft_metadata_cid_to_poseidon_hash()

use std::hash::poseidon2;
use data_types::{ IPNftData, RevealedData }; // @dev - IPNftData struct


fn main(
    root: pub Field, // @dev - Merkle Root
    hash_path: [Field; 2],
    index: Field,
    secret: Field,   // @dev - A hidden metadata hash (private)
    expected_nullifier: Field,
    expected_nft_metadata_cid_hash: Field,
    ip_nft_data: IPNftData
//) -> pub Field {
) -> pub RevealedData {
    println(expected_nullifier); // [Log]: 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373

    let inputs_for_note_commitment: [Field; 1] = [secret];
    let note_commitment = poseidon2::Poseidon2::hash(inputs_for_note_commitment, inputs_for_note_commitment.len());

    //let inputs_for_nullifier: [Field; 1] = [ip_nft_data.nft_token_id];
    let inputs_for_nullifier: [Field; 5] = [root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.nft_metadata_hash];
    let nullifier = poseidon2::Poseidon2::hash(inputs_for_nullifier, inputs_for_nullifier.len());
    
    // Constraint: nullifier (hash) == expected_nullifier (hash)
    assert(nullifier == expected_nullifier);

    // Convert a IPFS CID (sha256) -> bytes -> Field -> Poseidon2 Hash
    let nft_metadata_cid: str<46> = "QmYwAPJzv5CZsnAzt8auVZRn5W4mBkpLsD4HaBFN6r5y6F";
    let nft_metadata_cid_hash: Field = converters::convert_cid_to_poseidon_hash::convert_nft_metadata_cid_to_poseidon_hash(nft_metadata_cid);
    println(nft_metadata_cid_hash); // [Log]: 0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0

    // Constraint: nft_metadata_cid_hash == expected_nft_metadata_hash
    assert(nft_metadata_cid_hash == expected_nft_metadata_cid_hash);

    // [TODO]: Constraint - [NOTE]: The std::merkle::compute_merkle_root() can be used with only a "Pedersen" hash.
    //let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    //assert(root == check_root);

    //nullifier
    //(nullifier, nft_metadata_cid_hash)
    RevealedData {
        nullifier,
        nft_metadata_cid_hash,
    }
}
