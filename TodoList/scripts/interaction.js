const { ethers } = require("hardhat");

async function main() {
  const TodoList = await ethers.getContractAt(
    "ITodoList",
    "0xc700E78c4495d00bE2aB12a13FB9Fd2eeE97365E"
  );
  console.log(`Gotten from ${TodoList.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
