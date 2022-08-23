import { ethers } from "hardhat";

async function main() {
  const Voting = await ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();

  await voting.deployed();

  console.log(`deployed to ${voting.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
