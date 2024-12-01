// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ImmutableERC1155} from "@imtbl/contracts/contracts/token/erc1155/preset/ImmutableERC1155.sol";
import {IImmutableERC1155Factory} from "./interfaces/IImmutableERC1155Factory.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

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
    ) public view returns (address) {
        return Create2.computeAddress(
            _computeSalt(owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_),
            keccak256(
                _computeCreationCode(
                    owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_
                )
            )
        );
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
    ) public returns (address) {
        bytes32 salt =
            _computeSalt(owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_);

        address token = Create2.deploy(
            0,
            salt,
            _computeCreationCode(
                owner, name_, baseURI_, contractURI_, _operatorAllowlist, _receiver, _feeNumerator, extraSalt_
            )
        );
        emit ImmutableERC1155Deployed(token);
        return token;
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
