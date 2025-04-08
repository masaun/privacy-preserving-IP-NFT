echo "Load the environment variables from the .env file..."
source .env
#. ./.env

echo "Running the test of the IPNFTTest on EDU Chain testnet..."
forge test --optimize --optimizer-runs 5000 --evm-version cancun --match-contract IPNFTOnEDUChainTestnetTest --rpc-url ${EDU_CHAIN_TESTNET_RPC} -vv
