import { Noir } from '@noir-lang/noir_js';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';

async function poseidonHash(data1: any, data2: any, data3: any): Promise<string> {
    const backendPoseidon = new BarretenbergBackend(poseidonCompiled);
    const noirPoseidon = new Noir(poseidonCompiled as any, backendPoseidon);
  
    const hashPrivate = await noirPoseidon.execute({
      amount1: data1.toString(),
      amount2: data2.toString(),
      secretShare: data3.toString(),
    });
  
    return hashPrivate.returnValue.toString();
}