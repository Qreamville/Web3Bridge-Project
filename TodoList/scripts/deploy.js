const { ethers } = require("hardhat");

async function main() {
  const TodoList = await ethers.getContractFactory("TodoList");
  console.log("Deploying contract | / | ");
  const todoList = await TodoList.deploy();

  await todoList.deployed();

  console.log(`deployed to ${todoList.address}`);

  await todoList.createTask("Wash plates");
  console.log(await todoList.getTask(0));

  await todoList.completedTask(0);
  console.log(await todoList.getTask(0));

  await todoList.editTask(0, "Wash plates and Park the cars");
  console.log(await todoList.getTask(0));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
