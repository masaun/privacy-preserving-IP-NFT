echo "Load the environment variables from the .env file..."
#source .env
. ./.env

echo "Verifying a proof via the Starter (UltraVerifier) contract on Local Network..."
forge script script/Verify.s.sol --broadcast --skip-simulation
