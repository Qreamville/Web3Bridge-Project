// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ITodoList {
    function createTask(string calldata _text) external;

    // function editTask(uint _index, string calldata _text) external;

    // function completedTask(uint _index) external;

    function getTask(uint _index) external returns (string memory, bool);
}
