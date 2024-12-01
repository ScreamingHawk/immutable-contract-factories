// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IImmutableERC721FactorySignals {
    event ImmutableERC721Deployed(address indexed tokenAddress);
}

interface IImmutableERC721FactoryFunctions {
    function determineAddress(
        address owner,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) external view returns (address);

    function deploy(
        address owner,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) external returns (address);
}

interface IImmutableERC721Factory is IImmutableERC721FactorySignals, IImmutableERC721FactoryFunctions {}
