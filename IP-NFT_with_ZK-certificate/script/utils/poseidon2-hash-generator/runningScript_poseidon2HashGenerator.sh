echo "Load the environment variables from the .env file..."
#source .env
. ./.env

echo "Run the poseidon2HashGenerator.ts..."
npx tsx script/utils/poseidon2-hash-generator/poseidon2HashGenerator.ts  # Success
#npx ts-node script/utils/poseidon2-hash-generator/poseidon2HashGenerator.ts

# See the detail of how to run a Typescript file in shell script: https://nodejs.org/en/learn/typescript/run#running-typescript-with-a-runner