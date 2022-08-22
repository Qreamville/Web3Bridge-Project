const { ethers } = require("hardhat");

async function main() {
  const TodoList = await ethers.getContractAt(
    "ITodoList",
    "0x8964726F83A4EF78326476dbb76eF4689165EFcd"
  );

  await (await TodoList.createTask("Wash plates")).wait(1);
  console.log(await TodoList.getTask(0));

  await (await TodoList.completedTask(0)).wait(1);
  console.log(await TodoList.getTask(0));

  await (await TodoList.editTask(0, "Wash plates and Park the cars")).wait(1);
  console.log(await TodoList.getTask(0));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
