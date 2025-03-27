import { poseidon2Hash } from "@zkpassport/poseidon2"

/** 
 * @notice - Get the poseidon hash from the specified data
 */
function hashInPoseidon2() {
  // Hash an array of bigints
  const input = [1n, 2n, 3n]
  const hash = poseidon2Hash(input)
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  return hash;
}


/**
 * @notice - The main function
 */
function main() {
  // const data1 = 100;
  // const data2 = 200;
  // const data3 = 300;
  const hash = hashInPoseidon2(); // Await the promise
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152
  return hash; // Return the resolved value
}

/**
 * @notice - Execute the main function
 */
const hash = main();
console.log(`hash (at the main()): ${ hash }`);