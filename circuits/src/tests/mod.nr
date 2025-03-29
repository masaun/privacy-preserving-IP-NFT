mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;                   // src/main.nr
    use crate::data_types::IPNftData;  // src/data_types.nr
    use std::hash::poseidon2;

    #[test]
    fn test_nft_metadata_verifier() {
        let root: Field = 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629;   // @dev - Merkle Root
        let hash_path: [Field; 2] = [0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8, 0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77];
        let index: Field = 0;
        let secret: Field = 1;

        let ip_nft_data: IPNftData = IPNftData {
            nft_owner: 0xC6093Fd9cc143F9f058938868b2df2daF9A91d28,
            nft_token_id: 1,
            metadata_cid_hash: 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8
        };

        let expected_nullifier: Field = 10190015755989328289879378487807721086446093622177241109507523918927702106995; // @dev - Same with the "hash" in the output.json
        //let expected_nullifier = poseidon2::Poseidon2::hash([root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash], 5);
        println(expected_nullifier); // [Log]: 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373

        let nullifier = main(
            root,
            hash_path,
            index,
            secret,
            expected_nullifier,
            ip_nft_data
        );
        println(nullifier); // [Log]: 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373

        let inputs_for_note_commitment: [Field; 1] = [secret];
        let note_commitment = poseidon2::Poseidon2::hash(inputs_for_note_commitment, inputs_for_note_commitment.len());

        let inputs_for_nullifier: [Field; 1] = [ip_nft_data.nft_token_id];
        //let inputs_for_nullifier: [Field; 5] = [root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash];
        let _nullifier = poseidon2::Poseidon2::hash(inputs_for_nullifier, inputs_for_nullifier.len());

        // Constraint check
        assert(nullifier == _nullifier, "Invalid nullifier");

        println("The test of the test_nft_metadata_verifier()) has been successful");
    }

}