// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Daniel Beal <git@dbeal.dev>, Github: @dbeal-eth
/******************************************************************************/

import { IDiamond } from "./IDiamond.sol";

interface IDiamondWipeAndPave is IDiamond {    

    /// @notice Completely replaces the entire diamond with a new set of facets. For use with tooling that
		/// does not benefit from specific cutting or cannot know previous state effectively.
		/// will not pave immutable functions (ie, functions defined on the diamond itself).
    /// @param _diamondCut Contains the facet addresses and function selectors. All operations should be `Add`
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function diamondWipeAndPave(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;    
}
