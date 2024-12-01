// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ImmutableERC1155Factory, ImmutableERC1155} from "../src/ImmutableERC1155Factory.sol";
import {IImmutableERC1155FactorySignals} from "../src/interfaces/IImmutableERC1155Factory.sol";

import {OperatorAllowlistUpgradeable} from "@imtbl/contracts/contracts/allowlist/OperatorAllowlistUpgradeable.sol";

contract ImmutableERC1155FactoryTest is Test, IImmutableERC1155FactorySignals {
    ImmutableERC1155Factory public factory;
    OperatorAllowlistUpgradeable public operatorAllowlist;

    function setUp() public {
        factory = new ImmutableERC1155Factory();
        operatorAllowlist = new OperatorAllowlistUpgradeable();
    }

    function test_Deploy(
        address owner,
        string memory name_,
        string memory baseURI_,
        string memory contractURI_,
        address _receiver,
        uint96 _feeNumerator,
        bytes32 extraSalt_
    ) public {
        _feeNumerator = uint96(bound(_feeNumerator, 0, 10000));

        address expectedAddress = factory.determineAddress(
            owner, name_, baseURI_, contractURI_, address(operatorAllowlist), _receiver, _feeNumerator, extraSalt_
        );

        vm.expectEmit(address(factory));
        emit ImmutableERC1155Deployed(expectedAddress);
        address tokenAddr = factory.deploy(
            owner, name_, baseURI_, contractURI_, address(operatorAllowlist), _receiver, _feeNumerator, extraSalt_
        );
        assertEq(tokenAddr, expectedAddress);

        // Assert values set correctly
        ImmutableERC1155 token = ImmutableERC1155(tokenAddr);
        assertEq(token.hasRole(token.DEFAULT_ADMIN_ROLE(), owner), true);
        (, string memory name,,,,,) = token.eip712Domain();
        assertEq(name, name_);
        assertEq(token.baseURI(), baseURI_);
        assertEq(token.contractURI(), contractURI_);
        (address receiver, uint256 amount) = token.royaltyInfo(0, 10000);
        assertEq(receiver, _receiver);
        assertEq(amount, _feeNumerator);
        assertEq(address(token.operatorAllowlist()), address(operatorAllowlist));
    }
}
