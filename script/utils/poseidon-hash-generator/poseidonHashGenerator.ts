import { BackendInstances, Circuits, Noirs } from './types.js';
import { join, resolve } from 'path';

import { Noir, type CompiledCircuit, type InputMap } from '@noir-lang/noir_js';
import { UltraHonkBackend } from '@aztec/bb.js';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { compile, createFileManager } from '@noir-lang/noir_wasm';
import { ProofData } from '@noir-lang/types';


//let circuitArtifact: any;

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
async function getCircuitArtifact(): Promise<CompiledCircuit> {
  let circuitArtifact = await import(`../../../circuits/target/ip_nft_ownership.json`);
  return circuitArtifact as CompiledCircuit;
}

/** 
 * @notice - Get the poseidon hash from the specified data
 */
async function poseidonHash(data1: any, data2: any, data3: any): Promise<string> {
    let circuitArtifact: CompiledCircuit = await getCircuitArtifact();
    //console.log(`circuitArtifact: ${JSON.stringify(circuitArtifact)}`);
    //console.log(`circuitArtifact.bytecode: ${JSON.stringify(circuitArtifact.bytecode)}`);  /// [Result]: Success to retrieve in String.
    if (!circuitArtifact || !circuitArtifact.bytecode) {
      throw new Error('Circuit artifact or bytecode is undefined');
    }


    const backend = new UltraHonkBackend(circuitArtifact.bytecode);
    //const backend = new BarretenbergBackend(circuitArtifact);
    //const backend = new BarretenbergBackend(circuitArtifact.bytecode, { threads: 8 });
    //const noir = new Noir(circuitArtifact as CompiledCircuit);
    const noir = new Noir(circuitArtifact as CompiledCircuit);
  
    const inputs: InputMap = {
      //const hashPrivate = await noirPoseidon.execute({
        amount1: data1.toString(),
        amount2: data2.toString(),
        secretShare: data3.toString(),
      }

    const { witness } = await noir.execute(inputs);
    // const hashPrivate = await noir.execute({
    //   amount1: data1.toString(),
    //   amount2: data2.toString(),
    //   secretShare: data3.toString(),
    // });
  
    return witness.toString();
    //return hashPrivate.returnValue.toString();
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