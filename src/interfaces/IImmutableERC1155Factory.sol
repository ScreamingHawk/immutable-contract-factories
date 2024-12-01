// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IImmutableERC1155FactorySignals {
    event ImmutableERC1155Deployed(address indexed tokenAddress);
}

interface IImmutableERC1155FactoryFunctions {
    function determineAddress(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) external view returns (address);

    function deploy(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _operatorAllowlist,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) external returns (address);
}

interface IImmutableERC1155Factory is IImmutableERC1155FactorySignals, IImmutableERC1155FactoryFunctions {}
