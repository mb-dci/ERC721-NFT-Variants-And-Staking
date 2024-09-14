// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev An ERC20 contract to be used to mint reward tokens for an 
 * NFT staking contract.
 */
contract SampleERC20StackingRewardsToken is ERC20("SampleRewardToken", "SRT") {
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}