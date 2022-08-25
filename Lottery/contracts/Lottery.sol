// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error notEnoughFee();
error notAnAdmin();
error alreadyPickedWinner();
error TransferError();

contract Lottery {
    /* Open: means anyone can enter, Calculating: means noone can enter since the winner is getting picked */
    enum LotteryState {
        OPEN,
        CALCULATING,
        ENDED,
        COMPLETED
    }

    /* State Variables */
    uint256 private constant ENTRANCE_FEE = 10; // 10 wei
    address payable[] private players;
    address payable private winner;
    address private admin;
    LotteryState private lotteryState;

    mapping(address => bool) private alreadyPlayer;

    /* Constructor */
    constructor() {
        admin = msg.sender;
        lotteryState = LotteryState.OPEN;
    }

    modifier onlyAdmin() {
        if (msg.sender != admin) {
            revert notAnAdmin();
        }
        _;
    }

    modifier _lotteryState(LotteryState state) {
        if (lotteryState != state) {
            revert alreadyPickedWinner();
        }
        _;
    }

    /* Functions */
    receive() external payable {}

    function enterLottery() public payable _lotteryState(LotteryState.OPEN) {
        require(msg.sender != admin, "Admin is not allowed to enter");
        require(!alreadyPlayer[msg.sender], "Error, no double entry");
        if (msg.value < ENTRANCE_FEE) {
            revert notEnoughFee();
        }
        players.push(payable(msg.sender));
        alreadyPlayer[msg.sender] = true;
    }

    function randomNumber() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWinner() external onlyAdmin {
        lotteryState = LotteryState.CALCULATING;
        require(players.length > 2, "Not enough players");
        winner = players[randomNumber() % players.length];
        players = new address payable[](0);
        (bool success, ) = winner.call{
            value: (address(this).balance - (address(this).balance * 20) / 100)
        }("");

        if (!success) {
            revert TransferError();
        }
        lotteryState = LotteryState.ENDED;
    }

    function adminShare() external onlyAdmin _lotteryState(LotteryState.ENDED) {
        (bool success, ) = admin.call{value: address(this).balance}("");

        if (!success) {
            revert TransferError();
        }
        lotteryState = LotteryState.COMPLETED;
    }

    function restartLottery()
        external
        onlyAdmin
        _lotteryState(LotteryState.COMPLETED)
    {
        lotteryState = LotteryState.CALCULATING;
        winner = payable(address(0));
    }

    /* View and Pure Functions */
    function getTotalPlayers() external view returns (uint256) {
        return players.length;
    }

    function getEntranceFee() external pure returns (uint256) {
        return ENTRANCE_FEE;
    }

    function getLotteryBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getWinner() external view returns (address) {
        return winner;
    }
}
