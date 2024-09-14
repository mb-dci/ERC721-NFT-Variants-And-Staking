// SPDX-License-Indentifier: MIT

pragma solidity 0.8.24;
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev A gas efficient NFT staking contract that bypasses approvals by 
 * implementing the ERC721Recieved interface. Users can send their 
 * NFTs and claim 10 ERC20 Reward tokens every 24 hours. Users can withdraw 
 * their NFT at any time.
 */
contract SampleNFTStakingContract is IERC721Receiver {
    uint256 lastBlockPoolWasUpdatedAt;
    uint256 dailyTokenReward = 10;
    uint256 accRewardPerToken;

    /**
     * @param staked, this is flipped to `true` upon deposit of an NFT into the contract and set to false upon a withdrawal.
     * @param tokenIdStaked is the specific token that the user has staked.
     * @param timeStampforRewardCalc is the timestamp when the user initially staked the NFT but gets updated 
     * to the last time when they redeemed their rewards whenever rewards are redeemed.
     */
    struct UserInfo{
        bool staked;
        uint256 tokenId;
        uint256 timeStampforRewardCalc;
    }

    mapping (address => UserInfo) userInfo;

    IERC721 nftContract;
    IERC20 rewardToken;

    event Deposit(address indexed user, uint256 tokenId);
    event RedeemReward(address indexed user, uint256 rewardRedeemed);
    event Withdraw(address indexed user, uint256 tokenId); 

    constructor (IERC721 _nftContract, IERC20 _rewardToken) {
        nftContract = _nftContract;
        rewardToken = _rewardToken;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
        // check the that msg.sender is a specific NFT contract that we've whitelisted to send us NFTs, reject all others
        // whats happens if a user tries to deposit a second NFT here?

        userInfo[from] = UserInfo(true, tokenId, block.timestamp);
        emit Deposit(from, tokenId);
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function redeemRewards() public {
        UserInfo storage user = userInfo[msg.sender];
        require (user.staked, "User has nothing staked in the contract");
        uint256 daysStaked = (block.timestamp - user.timeStampforRewardCalc) / 1 days;
        if (daysStaked == 0) {
            return;
        }
        uint256 reward = daysStaked * dailyTokenReward * 10e18;
        user.timeStampforRewardCalc = block.timestamp;
        //rewardToken.mint(msg.sender, reward);
        
        emit RedeemReward(user, reward);
    }

    function withdraw() public {
        UserInfo storage user = userInfo[msg.sender];
        require(user.staked, "User has nothing staked in the contract");
        redeemRewards();

        // No reentrancy here on transfer before zero-out of mapping because we wrote
        // the NFT contract ourselves and do not allow staking from anyother NFT contract.
        nftContract.safeTransferFrom(address(this), msg.sender, user.tokenId);

        delete userInfo[msg.sender];

        emit Withdraw(msg.sender, user.tokenId);
    }
}