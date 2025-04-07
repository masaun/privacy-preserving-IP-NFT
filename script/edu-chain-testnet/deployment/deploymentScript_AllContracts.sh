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