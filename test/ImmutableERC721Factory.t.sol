// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IImmutableERC721FactorySignals} from "../src/interfaces/IImmutableERC721Factory.sol";
import {ImmutableERC721Factory, ImmutableERC721} from "../src/ImmutableERC721Factory.sol";

import {OperatorAllowlistUpgradeable} from "@imtbl/contracts/contracts/allowlist/OperatorAllowlistUpgradeable.sol";

contract ImmutableERC721FactoryTest is Test, IImmutableERC721FactorySignals {
    ImmutableERC721Factory public factory;
    OperatorAllowlistUpgradeable public operatorAllowlist;

    function setUp() public {
        factory = new ImmutableERC721Factory();
        operatorAllowlist = new OperatorAllowlistUpgradeable();
    }

    function test_Deploy(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address royaltyReceiver_,
        uint96 feeNumerator_,
        bytes32 extraSalt_
    ) public {
        feeNumerator_ = uint96(bound(feeNumerator_, 0, 10000));

        address expectedAddress = factory.determineAddress(
            owner_,
            name_,
            symbol_,
            baseURI_,
            contractURI_,
            address(operatorAllowlist),
            royaltyReceiver_,
            feeNumerator_,
            extraSalt_
        );

        vm.expectEmit(address(factory));
        emit ImmutableERC721Deployed(expectedAddress);
        address tokenAddr = factory.deploy(
            owner_,
            name_,
            symbol_,
            baseURI_,
            contractURI_,
            address(operatorAllowlist),
            royaltyReceiver_,
            feeNumerator_,
            extraSalt_
        );
        assertEq(tokenAddr, expectedAddress);

        // Assert values set correctly
        ImmutableERC721 token = ImmutableERC721(tokenAddr);
        assertEq(token.hasRole(token.DEFAULT_ADMIN_ROLE(), owner_), true);
        assertEq(token.name(), name_);
        assertEq(token.symbol(), symbol_);
        assertEq(token.baseURI(), baseURI_);
        assertEq(token.contractURI(), contractURI_);
        (address receiver, uint256 amount) = token.royaltyInfo(0, 10000);
        assertEq(receiver, royaltyReceiver_);
        assertEq(amount, feeNumerator_);
        assertEq(address(token.operatorAllowlist()), address(operatorAllowlist));
    }
}
