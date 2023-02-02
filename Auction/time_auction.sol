pragma solidity >=0.4.22 <=0.8.17;

contract TimedAuction {
    
    uint256 startTime;
    address owner;

    uint256 currentHighestBid;
    uint256 totalWithdrawalBids;
    address currentWinner;
    mapping(address => uint256) previousBids;

    
    event Bid(address indexed sender, uint256 amount, uint256 timestamp);

    constructor(){
        owner = msg.sender;
        startTime = block.timestamp;
    }

    function bid() external payable {
        require(block.timestamp - startTime < 5 minutes, "Aution over");
        require(msg.value > currentHighestBid, "Bid amount is too low" );
        
        previousBids[currentWinner] += currentHighestBid ;
        totalWithdrawalBids += currentHighestBid;

        currentHighestBid = msg.value;
        currentWinner = msg.sender;   
        
        emit Bid(msg.sender, msg.value, block.timestamp); 
    }

    function withdraw() public {
        uint256 amount = previousBids[msg.sender];
        totalWithdrawalBids -= amount;
        
        previousBids[msg.sender] = 0;
        (bool sent,) = payable(msg.sender).call{value:amount}("");
        
        require(sent, "payment unsuccessful");
    }

    function claim() public {
        require(msg.sender == owner,"Only owner can claim the bids");
        require(block.timestamp - startTime >= 5 minutes, "Auction is not over yet");
        require(totalWithdrawalBids == 0, "Not all users have withdrawn the bids");
       
        selfdestruct(payable(msg.sender));


    }

    function getHighestBidder() public view returns (address) {
        return currentWinner;
    }
    function getTotalWithdrawlBids() public view returns (uint256) {
        return totalWithdrawalBids;
    }
}