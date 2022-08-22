const { ethers } = require("hardhat");

async function main() {
  const TodoList = await ethers.getContractFactory("TodoList");
  const todoList = await TodoList.deploy();

  await todoList.deployed();

  console.log(`deployed to ${todoList.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
