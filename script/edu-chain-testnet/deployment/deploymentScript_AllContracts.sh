echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the UltraVerifier and Starter contract on EDU Chain Testnet..."
forge script script/edu-chain-testnet/deployment/DeploymentAllContracts.s.sol --broadcast --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} \
    ./contracts/circuit/plonk_vk.sol:UltraVerifier \
    ./Starter.sol:Starter \
    --skip-simulation