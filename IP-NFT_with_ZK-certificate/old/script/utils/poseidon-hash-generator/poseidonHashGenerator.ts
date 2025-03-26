import { BackendInstances, Circuits, Noirs } from './types.js';
import { join, resolve } from 'path';

import { Noir, type CompiledCircuit, type InputMap } from '@noir-lang/noir_js';
import { UltraHonkBackend } from '@aztec/bb.js';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { compile, createFileManager } from '@noir-lang/noir_wasm';
import { ProofData } from '@noir-lang/types';

//let circuitArtifact: any;

/** 
 * @notice - Get the circuit artifact (= Compiled Circuit) from the specified path
 */
async function getCircuitArtifact(): Promise<CompiledCircuit> {
  let circuitArtifact = await import(`./circuits/poseidon_hash.json`);
  console.log(`circuitArtifact - typeof: ${ typeof circuitArtifact }`);
  console.log(`circuitArtifact - typeof: ${ typeof JSON.stringify(circuitArtifact) }`);
  return circuitArtifact as CompiledCircuit;
}

/** 
 * @notice - Get the poseidon hash from the specified data
 */
async function poseidonHash(data1: any, data2: any, data3: any): Promise<string> {
  let circuitArtifact = await getCircuitArtifact();
  const backendPoseidon = new UltraHonkBackend(circuitArtifact.bytecode);
  //const backendPoseidon = new BarretenbergBackend(circuitArtifact);
  const noirPoseidon = new Noir(circuitArtifact as CompiledCircuit);
  //const noirPoseidon = new Noir(circuitArtifact as any, backendPoseidon);

  const hashPrivate = await noirPoseidon.execute({
    value1: data1.toString(), // Match the expected input name
    value2: data2.toString(), // Match the expected input name
    value3: data3.toString(), // Match the expected input name
  });
  console.log(`hashPrivate: ${ hashPrivate }`);

  return hashPrivate.returnValue.toString();
}


/**
 * @notice - Main function
 */
async function main(): Promise<string> { // Mark the function as async
  const data1 = 100;
  const data2 = 200;
  const data3 = 300;
  const hashValueInPoseidon = await poseidonHash(data1, data2, data3); // Await the promise
  console.log(`hashValueInPoseidon: ${hashValueInPoseidon}`);
  return hashValueInPoseidon; // Return the resolved value
}

main().then((result) => {
  console.log(`Result: ${result}`);
}).catch((error) => {
  console.error(`Error: ${error}`);
});