// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com>, Twitter/Github: @mudgen
* Author: Daniel Beal <git@dbeal.dev>, Github: @dbeal-eth
* EIP-2535 Diamonds
/******************************************************************************/

import { LibDiamond } from "../libraries/LibDiamond.sol";

contract OwnershipFacet {
    function transferDiamondOwnership(address _newOwner) external {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.setContractOwner(_newOwner);
    }

    function diamondOwner() external view returns (address owner_) {
        owner_ = LibDiamond.contractOwner();
    }
}
