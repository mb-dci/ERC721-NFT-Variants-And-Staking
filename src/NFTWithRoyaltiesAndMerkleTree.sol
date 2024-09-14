// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
/**
 * @dev An ERC-721 contract that implements the ERC-2981 NFT royalty
 * standard and which makes use of merkle trees to allow certain 
 * address to mint NFTs at a discount.
 */
contract SampleNFTArtist is ERC721("SampleNFTCollection", "NFTSMPLE"), ERC2981 {

    /**
     * Equates to a 2.5% royalty fee when the default _feeDenominator of 10_000 
     * is used in the OZ implementation of ERC2981.
     */
    uint96 erc2981FeeNumerator = 250;  // (250/10_000) * 100 = 2.5%

    /**
     * @dev Override ERC165-supportsInterface.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    constructor() {
        _setDefaultRoyalty(address(this), 250);
    }
}