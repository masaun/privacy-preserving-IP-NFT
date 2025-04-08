pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { UltraVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol"; /// @dev - Deployed-Verifier SC, which was generated based on the main.nr
import { IPNFTOwnershipVerifier } from "../../../contracts/circuit/IPNFTOwnershipVerifier.sol";
import { IPNFTFactory } from "../../../contracts/IPNFTFactory.sol";

//import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


/**
 * @notice - Deployment script to deploy all SCs at once - on Sonic Blaze Testnet
 * @dev - [CLI]: Using the CLI, which is written in the bottom of this file, to deploy all SCs
 */
contract DeploymentAllContracts is Script {
    //using SafeERC20 for MockRewardToken;
    UltraVerifier public verifier;
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    IPNFTFactory public ipNFTFactory;

    function setUp() public {}

    function run() public {
        //vm.createSelectFork("educhain-testnet"); // [NOTE]: Commmentout due to the error of the "Multi chain deployment does not support library linking at the moment"

        uint256 deployerPrivateKey = vm.envUint("EDU_CHAIN_TESTNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        verifier = new UltraVerifier();
        ipNFTOwnershipVerifier = new IPNFTOwnershipVerifier(verifier);
        ipNFTFactory = new IPNFTFactory(ipNFTOwnershipVerifier);

        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on EDU Chain Testnet
        console.logString("Logs of the deployed-contracts on EDU Chain Testnet");
        console.logString("\n");
        console.log("%s: %s", "UltraVerifier SC", address(verifier));
        console.logString("\n");
        console.log("%s: %s", "IPNFTOwnershipVerifier SC", address(ipNFTOwnershipVerifier));
        console.logString("\n");
        console.log("%s: %s", "IPNFTFactory SC", address(ipNFTFactory));
    }
}



/////////////////////////////////////////
/// CLI (icl. SC sources) - New version
//////////////////////////////////////

// forge script script/DeploymentAllContracts.s.sol --broadcast --private-key ${EDU_CHAIN_TESTNET_PRIVATE_KEY} \
//     ./circuits/target/contract.sol:UltraVerifier \
//     ./Starter.sol:Starter --skip-simulation
