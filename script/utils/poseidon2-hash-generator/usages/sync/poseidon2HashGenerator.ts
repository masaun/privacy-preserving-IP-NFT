import * as fs from "fs";

import { poseidon2Hash } from "@zkpassport/poseidon2"

/** 
 * @notice - Get the poseidon hash from the specified data
 */
function computePoseidon2Hash() {
  // Hash an array of bigints
  const input = [1n, 2n, 3n]
  const hash = poseidon2Hash(input)
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  return hash;
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
