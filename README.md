WIP: Implement Merkle tree bitmap & foundry test cases.

## ERC721 NFT Royalties and Staking

This repo contains a set of Solidity smart contracts that make implement NFT royalties and staking. They are intended to be gas efficient implementations and safegaurd against known smart contract anti-patterns. 
- [ ]  **Solidity contract 1:** ERC721 NFT contract with ERC 2918 and Merkle tree discount. The contract is configured have a reward rate of 2.5% for any NFT in the collection and addresses in a merkle tree can mint NFTs at a discount using the bitmap methodology.
- [ ]  **Solidity contract 2:** A Staking contract that implements the IERC721Reciever interface. Users can send their NFTs and withdraw 10 ERC20 tokens every 24 hours.The user can withdraw the NFT at any time.
- [ ]  **Solidity contract 3:** An ERC20 contract that will be used to reward staking. 

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```
