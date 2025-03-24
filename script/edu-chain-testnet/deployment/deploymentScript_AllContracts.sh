echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the UltraVerifier and the IPNFTOwnershipVerifier contract on EDU Chain Testnet..."
forge script script/edu-chain-testnet/deployment/DeploymentAllContracts.s.sol --broadcast --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} \
    ./contracts/circuit/plonk_vk.sol:UltraVerifier \
    ./IPNFTOwnershipVerifier.sol:IPNFTOwnershipVerifier \
    --skip-simulation