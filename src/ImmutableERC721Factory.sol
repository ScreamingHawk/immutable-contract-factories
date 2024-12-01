// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IImmutableERC721Factory} from "./interfaces/IImmutableERC721Factory.sol";
import {ImmutableERC721} from "@imtbl/contracts/contracts/token/erc721/preset/ImmutableERC721.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

contract ImmutableERC721Factory is IImmutableERC721Factory {
    function determineAddress(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) public view returns (address) {
        return Create2.computeAddress(
            _computeSalt(
                owner_,
                name_,
                symbol_,
                baseURI_,
                contractURI_,
                operatorAllowlist_,
                royaltyReceiver_,
                feeNumerator_,
                extraSalt_
            ),
            keccak256(
                _computeCreationCode(
                    owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
                )
            )
        );
    }

    function deploy(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) public returns (address) {
        bytes32 salt = _computeSalt(
            owner_,
            name_,
            symbol_,
            baseURI_,
            contractURI_,
            operatorAllowlist_,
            royaltyReceiver_,
            feeNumerator_,
            extraSalt_
        );
        address token = Create2.deploy(
            0,
            salt,
            _computeCreationCode(
                owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
            )
        );
        emit ImmutableERC721Deployed(token);
        return token;
    }

    function _computeCreationCode(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(
            type(ImmutableERC721).creationCode,
            abi.encode(
                owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
            )
        );
    }

    function _computeSalt(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                owner_,
                name_,
                symbol_,
                baseURI_,
                contractURI_,
                operatorAllowlist_,
                royaltyReceiver_,
                feeNumerator_,
                extraSalt_
            )
        );
    }
}
