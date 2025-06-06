echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the UltraVerifier and the IPNFTOwnershipVerifier contract on EDU Chain Testnet..."
forge script script/edu-chain-testnet/deployment/DeploymentAllContracts.s.sol \
    --broadcast \
    --rpc-url ${EDU_CHAIN_TESTNET_RPC} \
    --chain-id ${EDU_CHAIN_CHAIN_ID} \
    --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} \
    ./contracts/circuit/ultra-verifier/plonk_vk.sol:UltraVerifier \
    ./contracts/IPNFTOwnershipVerifier.sol:IPNFTOwnershipVerifier \
    ./contracts/IPNFTFactory.sol:IPNFTFactory \
    --skip-simulation

echo "Verify the deployed-smart contracts (icl. UltraVerifier, IPNFTOwnershipVerifier, IPNFTFactory) on EDU Chain Testnet Explorer..."
forge script script/edu-chain-testnet/deployment/DeploymentAllContracts.s.sol \
    --rpc-url ${EDU_CHAIN_TESTNET_RPC} \
    --chain-id ${EDU_CHAIN_CHAIN_ID} \
    --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} \
    --resume \
    --verify \
    --verifier blockscout \
    --verifier-url https://edu-chain-testnet.blockscout.com/api/