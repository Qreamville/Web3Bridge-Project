// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TodoList {
    /* State Variables */
    struct Task {
        string text;
        bool isCompleted;
    }

    Task[] private tasks;

    /* Fuctions*/
    function createTask(string calldata _text) external {
        tasks.push(Task({text: _text, isCompleted: false}));
    }

    function editTask(uint _index, string calldata _text) external {
        tasks[_index].text = _text;
        tasks[_index].isCompleted = false;
    }

    function completedTask(uint _index) external {
        tasks[_index].isCompleted = true;
    }

    function getTask(uint _index) public view returns (string memory, bool) {
        return (tasks[_index].text, tasks[_index].isCompleted);
    }
}
