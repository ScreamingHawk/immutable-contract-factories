// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ImmutableERC1155} from "@imtbl/contracts/contracts/token/erc1155/preset/ImmutableERC1155.sol";

contract ImmutableERC1155Factory {
    function deploy(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator
    ) public returns (address) {
        ImmutableERC1155 token =
            new ImmutableERC1155(owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator);
        return address(token);
    }
}
