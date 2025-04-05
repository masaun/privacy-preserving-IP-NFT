// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFTOwnershipVerifier } from "./circuit/IPNFTOwnershipVerifier.sol";
import { IPNFT } from "./IPNFT.sol";


/**
 * @title - IP NFT Factory contract
 */
contract IPNFTFactory {
    IPNFTOwnershipVerifier public ipNFTOwnershipVerifier;
    IPNFT public ipNFT;

    mapping(address => address) public ownerOfIPNFTs; /// @dev - Deployer of a IPNFT contract.

    constructor(IPNFTOwnershipVerifier _ipNFTOwnershipVerifier) {
        ipNFTOwnershipVerifier = _ipNFTOwnershipVerifier;
    }

    /**
     * @notice - Mint a new IP-NFT
     */
    function createNewIPNFT() public returns (IPNFT ipNFT) {
        IPNFT newIPNFT = new IPNFT(ipNFTOwnershipVerifier, msg.sender);
        ownerOfIPNFTs[msg.sender] = address(newIPNFT);
        return newIPNFT;
    }

}
