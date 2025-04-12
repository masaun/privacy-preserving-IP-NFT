# ZK (Zero-Knowledge) powered privacy preserving IP-NFT

## Tech Stack

- `ZK circuit`: Written in [`Noir`](https://noir-lang.org/docs/) powered by [Aztec](https://aztec.network/)) 
- Smart Contract: Written in Solidity (Framework: Foundry)
- Blockchain: [`EDU Chain`](https://edu-chain-testnet.blockscout.com) (Testnet)


<br>

## Overview

[`IP-NFT` (Intellectual Property Non-Fungible Token)](https://docs.molecule.to/documentation/ip-nfts/intro-to-ip-nft) provide a secure and immutable proof of ownership for intellectual property on-chain and it is used for a scentific research in DeSci space.
(More details about the concept of IP-NFT is written in the [Molecule's document](https://docs.molecule.to/documentation/ip-nfts/intro-to-ip-nft))

When a IP owner would create their IP-NFT contract, the IP owner basically associated with their IP's metadata URI (i.e. IPFS `CID`) via the ERC721#`_setTokenUR()`.
(In a case that an IPFS `CID` is used as a IP's metadata URI, anyone can know it by calling the ERC721#`tokenURI()` and retrieve it (IPFS `CID`) and see it - because it's "public")

However, within the IP's metadata URI (i.e. IPFS `CID`), some sensitive information that the IP owner does not want to disclose in public may be included.

For resolving this problem, the ZK (Zero-Knowledge) powered privacy preserving IP-NFT contract can be used.
This ZK-powered privacy preserving IP-NFT contract would enable an IP owner to attach its metadata without revealing a sensitive data thanks to using a ZKP (Zero-Knowledge Proof), which is generated via ZK circuit in Noir (`./circuits/src/main.nr`).

When a ZKP is generated via ZK circuit, a `Poseidon Hashed-IPFS CID` will be generated as a `public input`. Instead of associating a a public metadata URI (i.e. IPFS `CID`), the IP owner can associated the `Poseidon Hashed-IPFS CID` with their IP-NFT.

If a third party actor would like to check wether or not an owner is a valid IP owner and a metadada, which is asscoiated with a IP-NFT, is a valid metadata, the IP owner can show their ownership and valid metadata by calling the IPNFTOwnershipVerifier#`verifyIPNFTOwnershipProof()` with ZKP and public inputs (`Poseidon Hashed-IPFS CID`, etc) without disclosing a sensitive data-included in the IPFS `CID`.

(NOTE: The `IPNFTOwnershipVerifier` contract, which is the on-chain verifier contract for the ZK circuit (`./circuits/src/main.nr`))

<br>

## Userflow

- 1/ A IP owner would generate a new ZKP (Zero-Knowledge Proof) and public input data (`Poseidon Hashed-IPFS CID`, etc) through calling ZK circuit /w IPFS `CID`, etc.
  (NOTE: At this point, `Nullifier` and `Merkle Root` will also generated as `public inputs`).
  (NOTE: This step 1/ is an "off-chain" process)

- 2/ The IP owner would create/deploy a new IP-NFT contract via the IPNFTFactory#`createNewIPNFT()`.

- 3/ The IP owner would mint a new tokenID of IP-NFT /w the ZKP and public inputs, which was generated when the step 1/ through calling the IPNFT#`mintIPNFT()` /w the ZKP and public inputs.
  - At this point, a given `Poseidon Hashed-IPFS CID`, which is one of public inputs, will internally be associated with the tokenID of IP-NFT to be minted.

- 4/ If a third party actor would like to check wether or not an owner is a valid IP owner and a metadada, which is asscoiated with a IP-NFT, is a valid metadata, the IP owner can show their ownership and valid metadata by calling the IPNFTOwnershipVerifier#`verifyIPNFTOwnershipProof()` with ZKP and public inputs (`Poseidon Hashed-IPFS CID`, etc) without disclosing a sensitive data-included in the IPFS `CID`.


<br>


## Diagram of Userflow
- The diagram of userflow ([Link](https://github.com/masaun/privacy-preserving-IP-NFT/blob/develop/docs/diagrams/diagram_privacy-preserving-IP-NFT.jpg)):  
  ![Image](https://github.com/user-attachments/assets/662b28e1-a377-4e1a-b056-7165c47257c3)




<br>

## Deployed-smart contracts on [`EDU Chain` Testnet](https://edu-chain-testnet.blockscout.com)

| Contract Name | Descripttion | Deployed-contract addresses on EDU Chain (testnet) | Contract Source Code Verified |
| ------------- |:------------:|:--------------------------------------------------:|:-----------------------------:|
| UltraVerifier | The UltraPlonk Verifer contract (`./contracts/circuit/ultra-verifier/plonk_vk.sol`), which is generated based on ZK circuit in Noir (`./circuits/src/main.nr`). FYI: To generated this contract, the way of the [Noir's Solidity Verifier generation](https://noir-lang.org/docs/how_to/how-to-solidity-verifier) was used. | [0x4f615AA7d9315918569C2C36dc4658929700CF9E](https://edu-chain-testnet.blockscout.com/address/0x4f615AA7d9315918569C2C36dc4658929700CF9E) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x4f615AA7d9315918569C2C36dc4658929700CF9E?tab=contract) |
| IPNFTOwnershipVerifier | The IPNFTOwnershipVerifier contract, which the validation using the UltraVerifier contract is implemented | [0x473c88d42212aafe64B363c4378BeA8DC5665Ec5](https://edu-chain-testnet.blockscout.com/address/0x473c88d42212aafe64B363c4378BeA8DC5665Ec5) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x473c88d42212aafe64B363c4378BeA8DC5665Ec5?tab=contract) |
| IPNFTFactory | The IPNFTFactory contract, which create (deploy) a new `IPNFT` contract | [0x112e8b814d72A24eeae2e6A258c689d2FB0520E7](https://edu-chain-testnet.blockscout.com/address/0x112e8b814d72A24eeae2e6A258c689d2FB0520E7) | [Contract Source Code Verified](https://edu-chain-testnet.blockscout.com/address/0x112e8b814d72A24eeae2e6A258c689d2FB0520E7?tab=contract) |

NOTE: A `IPNFT` contract is deployed via the IPNFTFactory#`createNewIPNFT()`.

<br>

## Installation - Noir and Foundry

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


<br>

## ZK circuit - Test

```bash
cd circuits
sh circuit_test.sh
```

<br>

## Smart Contract - Compile
- Compile the smart contracts:
```bash
sh buildContract.sh
```

<br>

## Smart Contract - Script
- Install `npm` modules - if it's first time to run this script. (From the second time, this installation step can be skipped):
```bash
cd script/utils/poseidon2-hash-generator
npm i
```

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

## Smart Contract - Test
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
↓
- By running the script above, an `output.json` file like below would be exported and saved to the `script/utils/poseidon2-hash-generator/usages/async/output` directory:
```json
{
  "hash": "17581986279560538761428021143884026167649881764772625124550680138044361406562",
  "nullifier": "0x26df0d347e961cb94e1cc6d2ad8558696de8c1964b30e26f2ec8b926cbbbf862",
  "nftMetadataCidHash": "0x0c863c512eaa011ffa5d0f8b8cfe26c5dfa6c0e102a4594a3e40af8f68d86dd0",
  "merkleRoot": "0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629"
}
```
(NOTE: To generate a **Poseidon Hash** (`hash`), the [`@zkpassport/poseidon2`](https://github.com/zkpassport/poseidon2/tree/main) library would be used)

<br>

## References and Resources

- Noir:
  - Doc: https://noir-lang.org/docs/getting_started/quick_start

- `@zkpassport/poseidon2` library:  
  - Repo: https://github.com/zkpassport/poseidon2/tree/main


- EDU Chain: 
  - Block Explorer: https://edu-chain-testnet.blockscout.com
  - Doc (icl. RPC, Fancet, etc): https://devdocs.opencampus.xyz/build/ 

- Node.js:  
  - How to run a Typescript (Node.js) file in shell script: https://nodejs.org/en/learn/typescript/run#running-typescript-with-a-runner


- IP-NFT:  
  - Intro to IP-NFT: https://docs.molecule.to/documentation/ip-nfts/intro-to-ip-nft