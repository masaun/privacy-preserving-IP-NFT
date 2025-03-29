import * as fs from "fs";

import { poseidon2HashAsync } from "@zkpassport/poseidon2"

import { Noir } from "@noir-lang/noir_js";
import { UltraHonkBackend } from "@aztec/bb.js";
import circuit from "../../../../../circuits/target/ip_nft_ownership.json";  // [TODO]: Replace with the actual path to your circuit file

/** 
 * @notice - Get the poseidon hash from the specified data asynchronously
 */
async function computePoseidon2Hash() {
  // [TEST] - Hash a single bigint
  const { proof, publicInputs, provingTime } = await generateProof();
  console.log(`publicInputs (proof.publicInputs): ${ publicInputs }`);

  // Hash an array of bigints asynchronously
  const input_for_nullifier = getInputData();
  //const input = [1n, 2n, 3n]
  const hash = await poseidon2HashAsync(input_for_nullifier) // Using the asynchronous function
  console.log(hash) // Returns a single bigint hash value
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  return hash;
}

/** 
 * @notice - Get the input data for the poseidon hash
 */
function getInputData() {
  const root = BigInt(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629);
  const secret = BigInt(1);
  const nft_owner = BigInt(0xC6093Fd9cc143F9f058938868b2df2daF9A91d28);
  const nft_token_id = BigInt(1);
  const metadata_cid_hash = BigInt(0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8);

  console.log(`nft_token_id (in BigInt): ${nft_token_id}`);

  const inputs_for_nullifier = [nft_token_id];
  //const inputs_for_nullifier = [root, secret, nft_owner, nft_token_id, metadata_cid_hash];
  return inputs_for_nullifier;
}

/**
 * @notice - The function to export JSON file
 */
function exportJSON(data: object, filename: string = "output.json") {
  fs.writeFileSync(filename, JSON.stringify(data, null, 2), "utf-8");
  console.log(`JSON saved to ${filename}`);
}

/**
 * @notice - Generate a proof using the Noir circuit
 */
async function generateProof() {
  // Get the input data for the circuit
  const { root, hash_path, index, secret, expected_nullifier, ip_nft_data } = getInputDataForCircuit();

  const noir = new Noir(circuit);
  const backend = new UltraHonkBackend(circuit.bytecode);

  // Generate witness and prove
  const startTime = performance.now();
  const { witness } = await noir.execute({ root, hash_path, index, secret, expected_nullifier, ip_nft_data });
  //const { witness } = await noir.execute(input);
  const proof = await backend.generateProof(witness); // This "proof" generated would includes both the "proof.proof" and "proof.publicInputs"
  const provingTime = performance.now() - startTime;

  return { proof: proof.proof, publicInputs: proof.publicInputs, provingTime };  // The "public input" data can be retrieved via the "proof.publicInputs"
}

function getInputDataForCircuit() {
  let root = "0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629"
  let hash_path = [
      "0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8", 
      "0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77"
  ]
  let index = 0
  let secret = 1
  let expected_nullifier = "10190015755989328289879378487807721086446093622177241109507523918927702106995"
  //let expected_nullifier = "0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373"
  
  //[ip_nft_data]
  let ip_nft_data = {
    nft_owner: "0xC6093Fd9cc143F9f058938868b2df2daF9A91d28",
    nft_token_id: "1",
    metadata_cid_hash: "0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8"
  }
  return { root, hash_path, index, secret, expected_nullifier, ip_nft_data };
}

/**
 * @notice - The main function
 */
async function main(): Promise<bigint> { // Mark the function as async
  // const data1 = 100;
  // const data2 = 200;
  // const data3 = 300;
  const hash = await computePoseidon2Hash(); // Await the promise
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  /// @dev - Export a return value (= hash) as a JSON file
  const result = {
    hash: String(hash)
    //message: "Poseidon2 hash-generated is successfully exported"
  };
  exportJSON(result, "script/utils/poseidon2-hash-generator/usages/async/output/output.json");

  return hash; // Return the resolved value
}

/**
 * @notice - Execute the main function
 */
main().then((result) => {
  console.log(`Result: ${result}`);
}).catch((error) => {
  console.error(`Error: ${error}`);
});