// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ImmutableERC721} from "@imtbl/contracts/contracts/token/erc721/preset/ImmutableERC721.sol";

contract ImmutableERC721Factory {
    function deploy(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_
    ) public returns (address) {
        ImmutableERC721 token = new ImmutableERC721(
            owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
        );
        return address(token);
    }
}
