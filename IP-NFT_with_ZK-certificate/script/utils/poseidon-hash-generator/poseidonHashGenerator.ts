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
  return circuitArtifact as CompiledCircuit;
}

/** 
 * @notice - Get the poseidon hash from the specified data
 */
async function poseidonHash(data1: any, data2: any, data3: any): Promise<string> {
  let circuitArtifact = await getCircuitArtifact();
  const backendPoseidon = new UltraHonkBackend(circuitArtifact.bytecode);
  //const backendPoseidon = new BarretenbergBackend(circuitArtifact);
  const noirPoseidon = new Noir(circuitArtifact as any);
  //const noirPoseidon = new Noir(circuitArtifact as any, backendPoseidon);

  const hashPrivate = await noirPoseidon.execute({
    amount1: data1.toString(),
    amount2: data2.toString(),
    secretShare: data3.toString(),
  });

  return hashPrivate.returnValue.toString();
}




/**
 * @notice - Main function
 */
async function main(): Promise<string> {
  const data1 = 100;
  const data2 = 200;
  const data3 = 300;
  const hashValueInPoseidon = await poseidonHash(data1, data2, data3);
  console.log(`hashValueInPoseidon: ${hashValueInPoseidon}`);
  return hashValueInPoseidon;
}

// const a = main();