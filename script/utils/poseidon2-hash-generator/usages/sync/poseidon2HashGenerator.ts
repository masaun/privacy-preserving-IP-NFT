import * as fs from "fs";

import { poseidon2Hash } from "@zkpassport/poseidon2"

/** 
 * @notice - Get the poseidon hash from the specified data
 */
function computePoseidon2Hash() {  
  // Hash an array of bigints
  const input = getInputData();
  //const input = [1n, 2n, 3n]; 
  const hash = poseidon2Hash(input);
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
 * @notice - The main function
 */
function main() {
  // const data1 = 100;
  // const data2 = 200;
  // const data3 = 300;
  const hash = computePoseidon2Hash(); // Await the promise
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  /// @dev - Export a return value (= hash) as a JSON file
  const result = {
    hash: String(hash)
    //message: "Poseidon2 hash-generated is successfully exported"
  };
  exportJSON(result, "script/utils/poseidon2-hash-generator/usages/sync/output/output.json");

  return hash; // Return the resolved value
}

/**
 * @notice - Execute the main function
 */
const hash = main();
console.log(`hash (at the main()): ${ hash }`);
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
