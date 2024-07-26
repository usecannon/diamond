// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Daniel Beal <git@dbeal.dev>, Github: @dbeal-eth
/******************************************************************************/

import { IDiamondWipeAndPave } from "../interfaces/IDiamondWipeAndPave.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";

import "hardhat/console.sol";

contract DiamondWipeAndPaveFacet is IDiamondWipeAndPave {
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
    ) external override {
				LibDiamond.enforceIsContractOwner();
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
				for (uint256 i = 0;i < ds.selectors.length;) {
					bytes4 deleteSelector = ds.selectors[i];
					if (ds.facetAddressAndSelectorPosition[deleteSelector].facetAddress != address(this)) {
						ds.selectors[i] = ds.selectors[ds.selectors.length - 1];
						ds.facetAddressAndSelectorPosition[ds.selectors[i]].selectorPosition = uint16(i);
            ds.selectors.pop();
						delete ds.facetAddressAndSelectorPosition[deleteSelector];
					} else {
						console.log("cannot replace", i);
						i++;
					}
				}
        LibDiamond.diamondCut(_diamondCut, _init, _calldata);
    }
}
