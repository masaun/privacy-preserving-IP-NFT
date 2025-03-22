mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;                   // src/main.nr
    use crate::data_types::IPNftData;  // src/data_types.nr

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

        let nullifier = main(
            root,
            hash_path,
            index,
            secret,
            ip_nft_data
        );

        let note_commitment = std::hash::pedersen_hash([secret]);
        let _nullifier = std::hash::pedersen_hash([root, secret, ip_nft_data.nft_owner, ip_nft_data.nft_token_id, ip_nft_data.metadata_cid_hash]);

        // Constraint check
        assert(nullifier == _nullifier, "Invalid nullifier");

        println(nullifier);
        println("The test of the test_nft_metadata_verifier()) has been successful");
    }
}