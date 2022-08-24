import { ethers } from "hardhat";

async function main() {
  const itemAmount = ethers.utils.parseEther("1");

  const Auction = await ethers.getContractFactory("Auction");
  const auction = await Auction.deploy("Estate", itemAmount);

  await auction.deployed();

  console.log(`deployed to ${auction.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
