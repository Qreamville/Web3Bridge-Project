// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error InvalidAddress();
error notSeller();
error WrongState();
error SellerCannotBid();
error AmountTooLow();
error AuctionHasNotEnded();
error NotTheBidWinner();
error TransferError();

contract Auction {
    enum AuctionState {
        STARTED,
        ENDED,
        CLOSED
    }

    struct Item {
        address payable owner;
        string name;
        uint256 price;
        uint256 soldFor;
    }

    /* State Variables */
    Item private item;
    address payable private immutable seller;
    AuctionState private auctionState;
    uint256 highestBid;

    mapping(address => uint256) public individualBid;
    mapping(uint256 => address) private autionWinner;

    /* Modifiers */
    modifier onlySeller() {
        if (msg.sender != seller) {
            revert notSeller();
        }
        _;
    }

    modifier _auctionState(AuctionState state) {
        if (auctionState != state) {
            revert WrongState();
        }
        _;
    }

    /* Constructor */
    constructor(string memory _name, uint256 _price) {
        if (msg.sender == address(0)) {
            revert InvalidAddress();
        }
        seller = payable(msg.sender);
        item.owner = payable(msg.sender);
        item.name = _name;
        item.price = _price;
        highestBid = item.price;
        auctionState = AuctionState.STARTED;
    }

    /* Functions */
    function bid(uint256 _amount) external _auctionState(AuctionState.STARTED) {
        if (msg.sender == seller) {
            revert SellerCannotBid();
        }

        require(_amount > highestBid, "Amount too low");

        individualBid[msg.sender] = _amount;
        autionWinner[_amount] = msg.sender;
        highestBid = _amount;
    }

    function endBidding() external _auctionState(AuctionState.STARTED) {
        auctionState = AuctionState.ENDED;
    }

    function paySeller() external payable _auctionState(AuctionState.ENDED) {
        if (msg.sender != autionWinner[highestBid]) {
            revert NotTheBidWinner();
        }

        if (msg.value < highestBid) {
            revert AmountTooLow();
        }
        (bool success, ) = seller.call{value: msg.value}("");

        if (!success) {
            revert TransferError();
        }

        auctionState = AuctionState.CLOSED;
    }

    /* View Functions */

    function getAutionWinner() external view returns (address) {
        if (auctionState != AuctionState.ENDED) {
            revert AuctionHasNotEnded();
        }
        return autionWinner[highestBid];
    }

    function getInitialPrice() external view returns (uint256) {
        return item.price;
    }

    function getHighestBid() external view returns (uint256) {
        return highestBid;
    }
}
