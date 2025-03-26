echo "Load the environment variables from the .env file..."
#source .env
. ./.env

echo "Run the poseidonHashGenerator.ts..."
npx ts-node script/utils/poseidon-hash-generator/poseidonHashGenerator.ts
#npx tsx script/utils/poseidon-hash-generator/poseidonHashGenerator.ts

# See the detail of how to run a Typescript file in shell script: https://nodejs.org/en/learn/typescript/run#running-typescript-with-a-runner