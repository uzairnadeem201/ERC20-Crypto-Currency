//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        vm.prank(alice);
        uint256 transferAmount = 500;
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
