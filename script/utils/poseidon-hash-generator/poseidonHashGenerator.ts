import { BackendInstances, Circuits, Noirs } from './types.js';
import { join, resolve } from 'path';

import { Noir, type CompiledCircuit, type InputMap } from '@noir-lang/noir_js';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { compile, createFileManager } from '@noir-lang/noir_wasm';
import { ProofData } from '@noir-lang/types';

let circuitArtifact: any;

// /**
//  * @notice - Get the circuit from the specified path
//  */
// async function getCircuit(name: string) {
//   const basePath = resolve(join('../../../circuits', name));
//   //const basePath = resolve(join('../noir', name));
//   const fm = createFileManager(basePath);
//   const compiled = await compile(fm, basePath);
//   if (!('program' in compiled)) {
//     throw new Error('Compilation failed');
//   }
//   return compiled.program;
// }

/** 
 * @notice - Get the circuit artifact (= Compiled Circuit) from the specified path
 */
async function getCircuitArtifact() {
  circuitArtifact = await import(`../../../circuits/target/ip_nft_ownership.json`);
  return circuitArtifact;
}

/** 
 * @notice - Get the poseidon hash from the specified data
 */
async function poseidonHash(data1: any, data2: any, data3: any): Promise<string> {
    const circuitArtifact = await getCircuitArtifact();
    const backend = new BarretenbergBackend(circuitArtifact.bytecode);
    const noir = new Noir(circuitArtifact as CompiledCircuit);
  
    const hashPrivate = await noir.execute({
    //const hashPrivate = await noirPoseidon.execute({
      amount1: data1.toString(),
      amount2: data2.toString(),
      secretShare: data3.toString(),
    });
  
    return hashPrivate.returnValue.toString();
}