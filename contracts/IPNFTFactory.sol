// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPNFT } from "./IPNFT.sol";

/**
 * @title - IP NFT Factory contract
 */
contract IPNFTFactory {
    IPNFT public ipNFT;

    mapping(address => address) public ownerOfIPNFTs; /// @dev - Deployer of a IPNFT contract.

    constructor() {}

    /**
     * @notice - Mint a new IP-NFT
     */
    function createNewIPNFT() public {
        IPNFT newIPNFT = new IPNFT(msg.sender);
        ownerOfIPNFTs[msg.sender] = address(newIPNFT);
    }

}
