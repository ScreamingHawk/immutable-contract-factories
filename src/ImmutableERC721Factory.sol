// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IImmutableERC721Factory} from "./interfaces/IImmutableERC721Factory.sol";
import {ImmutableERC721} from "@imtbl/contracts/contracts/token/erc721/preset/ImmutableERC721.sol";

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
    ) public view returns (address addr) {
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
        bytes32 bytecodeHash = keccak256(
            _computeCreationCode(
                owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
            )
        );
        address deployer = address(this);

        // From OpenZeppelin's Create2.sol
        assembly {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x40), bytecodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, deployer)
            let start := add(ptr, 0x0b)
            mstore8(start, 0xff)
            addr := keccak256(start, 85)
        }
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
    ) public returns (address addr) {
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
        bytes memory bytecode = _computeCreationCode(
            owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_
        );
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        emit ImmutableERC721Deployed(addr);
        return addr;
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
