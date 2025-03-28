import { poseidon2HashAsync } from "@zkpassport/poseidon2"

/** 
 * @notice - Get the poseidon hash from the specified data asynchronously
 */
async function computePoseidon2Hash() {
  // Hash an array of bigints asynchronously
  const input = [1n, 2n, 3n]
  const hash = await poseidon2HashAsync(input) // Using the asynchronous function
  console.log(hash) // Returns a single bigint hash value
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value -> [Log]: 16068223842875184682212183064520144190817798559788034419026031423767658184152

  return hash;
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