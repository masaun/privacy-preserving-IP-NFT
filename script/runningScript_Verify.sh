echo "Load the environment variables from the .env file..."
#source .env
. ./.env

echo "Run the poseidon2HashGenerator.ts..."
npx tsx script/utils/poseidon2-hash-generator/usages/sync/poseidon2HashGenerator.ts  # Success

echo "Verifying a proof via the IPNFTOwnershipVerifier (icl. UltraVerifier) contract on Local Network..."
forge script script/Verify.s.sol --broadcast --skip-simulation
