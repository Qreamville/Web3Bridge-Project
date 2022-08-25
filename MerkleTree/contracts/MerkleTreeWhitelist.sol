// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MerkleTreeWhitelist is ERC721 {
    using Counters for Counters.Counter;

    bytes32 public merkleRoot;
    Counters.Counter private _tokenIdCounter;
    uint256 constant MAX_SUPPLY = 10000;

    constructor(bytes32 _merkleRoot) ERC721("KOINE", "KNE") {
        merkleRoot = _merkleRoot;
    }

    function isWhitelisted(bytes32[] calldata proof, bytes32 leaf)
        public
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    function safeMint(bytes32[] calldata proof) public {
        require(
            isWhitelisted(proof, keccak256(abi.encodePacked(msg.sender))),
            "Not Whitelisted"
        );
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= MAX_SUPPLY, "Nft already minted");
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }
}
