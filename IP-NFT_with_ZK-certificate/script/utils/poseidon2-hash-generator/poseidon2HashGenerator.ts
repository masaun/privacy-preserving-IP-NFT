import { poseidon2Hash } from "@zkpassport/poseidon2"

/** 
 * @notice - Get the poseidon hash from the specified data
 */
function hashInPoseidon2() {
  // Hash an array of bigints
  const input = [1n, 2n, 3n]
  const hash = poseidon2Hash(input)
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value

  return hash;
}


/**
 * @notice - The main function
 */
function main() {
//function main(): Promise<bigint> { // Mark the function as async
  // const data1 = 100;
  // const data2 = 200;
  // const data3 = 300;
  const hash = hashInPoseidon2(); // Await the promise
  console.log(`hash (Poseidon2 hash): ${ hash }`); // Returns a single bigint hash value
  //return hash; // Return the resolved value
}

/**
 * @notice - Execute the main function
 */
main();
// main().then((result) => {
//   console.log(`Result: ${result}`);
// }).catch((error) => {
//   console.error(`Error: ${error}`);
// });