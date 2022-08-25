import { ethers } from "hardhat";
import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";

async function main() {
  let whitelistAddresses = [
    "0xF0ccc8B440Bf013a37ef722530B1e4727a785CfA",
    "0x57ea20135f58c954145054561e9532BE79EB1A0d",
  ];

  const leafNodes = whitelistAddresses.map((address) => keccak256(address));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

  const rootHash = merkleTree.getHexRoot();
  console.log(rootHash);

  const MerkleTreeWhitelist = await ethers.getContractFactory(
    "MerkleTreeWhitelist"
  );
  const merkleTreeWhitelist = await MerkleTreeWhitelist.deploy(rootHash);
  await merkleTreeWhitelist.deployed();
  console.log(`deployed to ${merkleTreeWhitelist.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
