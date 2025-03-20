echo "Load the environment variables from the .env file..."
. ./.env

echo "Verifying a proof via the Starter (UltraVerifier) contract on EDU Chain testnet..."
forge script script/Verify.s.sol --broadcast --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} --rpc-url ${EDU_CHAIN_TESTNET_RPC} --skip-simulation