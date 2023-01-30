pragma solidity >0.7.0;


contract Auction{
    address owner = address(0);
    mapping(address=>uint256) participantOldBids;
    uint256 highestBid = 0;
    address highestBidder = address(0);


    event Bid(address indexed sender, uint amount); 

    event AuctionClosed(address indexed owner, uint amount);

    constructor(){
        owner = msg.sender;
    }


    function auction() external payable{
        require(msg.sender != owner,"Owner cannot bid");
        require(msg.value >= 1 ether, "Minimum bid amount is 1 ether");
        require(msg.value > highestBid,"Bid amount is too low");
        
        participantOldBids[highestBidder] = highestBid; 
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external payable {
        require(msg.sender != owner,"Owner cannot withdraw");
        uint256 value = participantOldBids[msg.sender];
        (bool sent,) = payable(msg.sender).call{
            value:value
            }("");
        require(sent, "Paymant failed");
    }

    function closeAuction() external payable{
        require( msg.sender == owner,"Only owner can close auction");
        emit AuctionClosed(highestBidder, highestBid);
        selfdestruct(payable(owner));

    }
}