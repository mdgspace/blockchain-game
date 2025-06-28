// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/OurToken.sol";


contract OurTokenTest is Test {
    OurToken private token;

    function setUp() public {
        token = new OurToken("TestToken", "TTK");
        token.mint(address(this), 1000 * 10 ** 18);
    }
    function testMint() public {
        uint256 initialBalance = token.balanceOf(address(this));
        token.mint(address(this), 500 * 10 ** 18); // Mint 500 more tokens
        uint256 newBalance = token.balanceOf(address(this));
        assertEq(newBalance, initialBalance + 500 * 10 ** 18);
    }
    function testBurn() public {
        uint256 initialBalance = token.balanceOf(address(this));
        token.burn(200 * 10 ** 18); // Burn 200 tokens
        uint256 newBalance = token.balanceOf(address(this));
        assertEq(newBalance, initialBalance - 200 * 10 ** 18);
    }
    function testNameAndSymbol() public {
        assertEq(token.name(), "TestToken");
        assertEq(token.symbol(), "TTK");
    }
    function testOwner() public {
        assertEq(token.owner(), address(this));
    }
    // function testMintingByNonOwner() public {
    //     address nonOwner = address(0x123);
    //     vm.startPrank(nonOwner);
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     token.mint(nonOwner, 100 * 10 ** 18); // Non-owner tries to mint tokens
    //     vm.stopPrank();
    // }
    // function testBurningByNonOwner() public {
    //     address nonOwner = address(0x123);
    //     vm.startPrank(nonOwner);
    //     vm.expectRevert("ERC20: burn amount exceeds balance");
    //     token.burn(100 * 10 ** 18); // Non-owner tries to burn tokens
    //     vm.stopPrank();
    // }
    // function testMintingToZeroAddress() public {
    //     vm.expectRevert("ERC20: mint to the zero address");
    //     token.mint(address(0), 100 * 10 ** 18); // Minting to zero address should revert
    // }
    // function testBurningMoreThanBalance() public {
    //     uint256 initialBalance = token.balanceOf(address(this));
    //     vm.expectRevert("ERC20: burn amount exceeds balance");
    //     token.burn(initialBalance + 100 * 10 ** 18); // Trying to burn more than balance should revert
    // }
    // function testTransfer() public {
    //     address recipient = address(0x456);
    //     uint256 initialBalance = token.balanceOf(address(this));
    //     token.transfer(recipient, 300 * 10 ** 18); // Transfer 300 tokens
    //     uint256 newBalance = token.balanceOf(address(this));
    //     assertEq(newBalance, initialBalance - 300 * 10 ** 18);
    //     assertEq(token.balanceOf(recipient), 300 * 10 ** 18);
    // }
    // function testTransferToZeroAddress() public {
    //     vm.expectRevert("ERC20: transfer to the zero address");
    //     token.transfer(address(0), 100 * 10 ** 18); // Transfer to zero address should revert
    // }
    // function testTransferMoreThanBalance() public {
    //     address recipient = address(0x456);
    //     uint256 initialBalance = token.balanceOf(address(this));
    //     vm.expectRevert("ERC20: transfer amount exceeds balance");
    //     token.transfer(recipient, initialBalance + 100 * 10 ** 18); // Trying to transfer more than balance should revert
    // }
    // function testApproveAndTransferFrom() public {
    //     address spender = address(0x789);
    //     uint256 amount = 200 * 10 ** 18;
    //     token.approve(spender, amount); // Approve spender to spend tokens
    //     uint256 initialBalance = token.balanceOf(address(this));
    //     token.transferFrom(address(this), spender, amount); // Transfer tokens from this contract to spender
    //     assertEq(token.balanceOf(address(this)), initialBalance - amount);
    //     assertEq(token.balanceOf(spender), amount);
    // }
    // function testApproveToZeroAddress() public {
    //     vm.expectRevert("ERC20: approve to the zero address");
    //     token.approve(address(0), 100 * 10 ** 18); // Approving zero address should revert
    // }
    // function testTransferFromWithoutApproval() public {
    //     address spender = address(0x789);
    //     vm.expectRevert("ERC20: transfer amount exceeds allowance");
    //     token.transferFrom(address(this), spender, 100 * 10 ** 18); // Trying to transfer without approval should revert
    // }
}