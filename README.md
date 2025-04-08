# Climate Change ZK Certificate (i.e. GHG certificate) /or IP-NFT /w ZK certificate-attached metadata in Noir

## Tech Stack


<br>

## Overview

- Climate Change ZK Certificate (i.e. GHG certificate)
  
Or,

- IP-NFT /w ZK certificate-attached metadata

<br>

## Deployed-smart contracts on [`EDU Chain` Testnet](https://edu-chain-testnet.blockscout.com)

| Contract Name | Descripttion | Deployed-contract addresses on EDU Chain (testnet) |
| ------------- |:-------------:| -----:|
| UltraVerifier | The UltraPlonk Verifer contract (`./contracts/circuit/ultra-verifier/plonk_vk.sol`), which is generated based on ZK circuit in Noir (`./circuits/src/main.nr`). FYI: To generated this contract, the way of the [Noir's Solidity Verifier generation](https://noir-lang.org/docs/how_to/how-to-solidity-verifier) was used. | [0x4f615AA7d9315918569C2C36dc4658929700CF9E](https://edu-chain-testnet.blockscout.com/address/0x4f615AA7d9315918569C2C36dc4658929700CF9E) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x4f615AA7d9315918569C2C36dc4658929700CF9E?tab=contract) |
| IPNFTOwnershipVerifier | The IPNFTOwnershipVerifier contract, which the validation using the UltraVerifier contract is implemented | [0x473c88d42212aafe64B363c4378BeA8DC5665Ec5](https://edu-chain-testnet.blockscout.com/address/0x473c88d42212aafe64B363c4378BeA8DC5665Ec5) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x473c88d42212aafe64B363c4378BeA8DC5665Ec5?tab=contract) |
| IPNFTFactory | The IPNFTFactory contract, which create (deploy) a new `IPNFT` contract | [0x112e8b814d72A24eeae2e6A258c689d2FB0520E7](https://edu-chain-testnet.blockscout.com/address/0x112e8b814d72A24eeae2e6A258c689d2FB0520E7) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x112e8b814d72A24eeae2e6A258c689d2FB0520E7?tab=contract) |

NOTE: A `IPNFT` contract is deployed via the IPNFTFactory#`createNewIPNFT()`.

<br>

## Installation

<br>

## ZK circuit - Test

```bash
cd circuits
sh circuit_test.sh
```

<br>

## SC - Script
- Run the `Verify.s.sol` on the Local Network
```bash
sh ./script/runningScript_Verify.sh
```

- Run the `Verify_onEDUChainTestnet.s.sol` on the EDU Chain Testnet
```bash
sh ./script/edu-chain-testnet/runningScript_Verify_onEDUChainTestnet.sh
```

- NOTE: The ProofConverter#`sliceAfter96Bytes()` would be used in the both script file above.
  - The reason is that the number of public inputs is `3` (`bytes32 * 3 = 96 bytes`), meaning that the proof file includes `96 bytes` of the public inputs **at the beginning**. 
     - Hence it should be removed by using the `sliceAfter96Bytes()` 


<br>

## SC - Test
- Run the `IPNFTOwnershipVerifier.t.sol` on the Local Network
```bash
sh ./test/runningTest_IPNFTOwnershipVerifier.sh
```

- Run the `IPNFTOwnershipVerifier_onEDUChainTestnet.t.sol` on the EDU Chain Testnet
```bash
sh ./test/edu-chain-testnet/runningTest_IPNFTOwnershipVerifier_onEDUChainTestnet.sh
```

- Run the `IPNFT.t.sol` on the Local Network
```bash
sh ./test/runningTest_IPNFT.sh
```

- Run the `IPNFT_onEDUChainTestnet.t.sol` on the EDU Chain Testnet
```bash
sh ./test/edu-chain-testnet/runningTest_IPNFT_onEDUChainTestnet.sh
```

<br>

## Deployment
- Run the `DeploymentAllContracts.s.sol`
```bash
sh ./script/edu-chain-testnet/deployment/deploymentScript_AllContracts.sh
```


<br>

## Utils

### Hashing with Poseidon2 Hash (Async)
- Run the `poseidon2HashGeneratorWithAsync.ts`
```bash
sh script/utils/poseidon2-hash-generator/usages/async/runningScript_poseidon2HashGeneratorWithAsync.sh
```
(Ref: https://nodejs.org/en/learn/typescript/run#running-typescript-with-a-runner )

<br>

## References and Resources

- Noir:
  - Doc: https://noir-lang.org/docs/getting_started/quick_start


- EDU Chain: 
  - Block Explorer: https://edu-chain-testnet.blockscout.com
  - Doc (icl. RPC, Fancet, etc): https://devdocs.opencampus.xyz/build/ 

<br>

<hr>

# Noir with Foundry

This example uses Foundry to deploy and test a verifier.

## Getting Started

Want to get started in a pinch? Start your project in a free Github Codespace!

[![Start your project in a free Github Codespace!](https://github.com/codespaces/badge.svg)](https://codespaces.new/noir-lang/noir-starter)

In the meantime, follow these simple steps to work on your own machine:

Install [noirup](https://noir-lang.org/docs/getting_started/noir_installation) with

1. Install [noirup](https://noir-lang.org/docs/getting_started/noir_installation):

   ```bash
   curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
   ```

2. Install Nargo:

   ```bash
   noirup
   ```

3. Install foundryup and follow the instructions on screen. You should then have all the foundry
   tools like `forge`, `cast`, `anvil` and `chisel`.

```bash
curl -L https://foundry.paradigm.xyz | bash
```

4. Install foundry dependencies by running `forge install 0xnonso/foundry-noir-helper --no-commit`.

5. Install `bbup`, the tool for managing Barretenberg versions, by following the instructions
   [here](https://github.com/AztecProtocol/aztec-packages/blob/master/barretenberg/bbup/README.md#installation).

6. Then run `bbup`.

## Generate verifier contract and proof

