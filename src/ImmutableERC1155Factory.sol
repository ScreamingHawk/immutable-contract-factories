// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ImmutableERC1155} from "@imtbl/contracts/contracts/token/erc1155/preset/ImmutableERC1155.sol";
import {IImmutableERC1155Factory} from "./interfaces/IImmutableERC1155Factory.sol";

contract ImmutableERC1155Factory is IImmutableERC1155Factory {
    function determineAddress(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) public view returns (address addr) {
        bytes32 salt =
            _computeSalt(owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_);
        bytes32 bytecodeHash = keccak256(
            _computeCreationCode(
                owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_
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
        return addr;
    }

    function deploy(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) public returns (address addr) {
        bytes32 salt =
            _computeSalt(owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_);
        bytes memory bytecode = _computeCreationCode(
            owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_
        );
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        emit ImmutableERC1155Deployed(addr);
        return addr;
    }

    function _computeCreationCode(
        address owner_,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(
            type(ImmutableERC1155).creationCode,
            abi.encode(owner_, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_)
        );
    }

    function _computeSalt(
        address owner_,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(owner_, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_)
        );
    }
}
