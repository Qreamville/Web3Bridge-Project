// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error notCommitee();
error votingEnded();

contract Voting {
    enum VotingState {
        NO_CONTESTANTS,
        VOTING_BEGIN,
        VOTING_ENDED
    }

    struct Contenstant {
        uint256 id;
        string name;
        string gender;
        uint256 votesCount;
    }

    /* State Variables */
    uint256 private Id = 0;
    string winner;
    address private immutable commitee;
    Contenstant[] private contenstants;
    VotingState private votingState;

    /* Mappings */
    mapping(string => bool) private alreadyContenstant;
    mapping(address => bool) private alreadyVoted;
    mapping(uint256 => string) private selection; // mapping votes to name for the selection ofn winners

    /* Constructor */
    constructor() {
        commitee = msg.sender;
        votingState = VotingState.NO_CONTESTANTS;
    }

    /* Modifier */
    modifier onlyCommitee() {
        if (msg.sender != commitee) {
            revert notCommitee();
        }
        _;
    }

    modifier _votingState(VotingState state) {
        if (votingState != state) {
            revert votingEnded();
        }
        _;
    }

    /* Functions */
    function addContestant(string memory _name, string memory _gender)
        external
        onlyCommitee
        _votingState(VotingState.NO_CONTESTANTS)
    {
        require(!alreadyContenstant[_name], "No double Entry");
        contenstants.push(
            Contenstant({id: Id, name: _name, gender: _gender, votesCount: 0})
        );
        alreadyContenstant[contenstants[Id].name] = true;
        Id++;
        votingState = VotingState.VOTING_BEGIN;
    }

    function vote(uint256 _index)
        external
        _votingState(VotingState.VOTING_BEGIN)
    {
        require(msg.sender != commitee, "Commitee is not allowed to vote");
        require(!alreadyVoted[msg.sender], "Error, no double voting");
        alreadyVoted[msg.sender] = true;
        contenstants[_index].votesCount++;
        selection[contenstants[_index].votesCount] = contenstants[_index].name;
    }

    function declearWinner() external onlyCommitee returns (string memory) {
        require(contenstants.length > 0, "No constestant has been added");
        uint256 maxNumber;

        for (uint256 i = 0; i < contenstants.length; i++) {
            if (contenstants[i].votesCount > maxNumber) {
                maxNumber = contenstants[i].votesCount;
            }
        }
        winner = selection[maxNumber];
        votingState = VotingState.VOTING_ENDED;
        return selection[maxNumber];
    }

    /* View and Pure Functions */
    function numberOfParcitipants() external view returns (uint256) {
        return contenstants.length;
    }

    function getContestantInfo(uint256 _index)
        external
        view
        returns (
            string memory,
            string memory,
            uint256
        )
    {
        return (
            contenstants[_index].name,
            contenstants[_index].gender,
            contenstants[_index].votesCount
        );
    }

    function getWinner() external view returns (string memory) {
        return winner;
    }
}
