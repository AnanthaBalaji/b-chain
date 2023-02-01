pragma solidity >=0.4.22 <=0.8.17;

contract EtherElection {
    
    uint256 balance;
    uint256 noOfCandidates;

    mapping(address => int256) votes;
    mapping(address => bool) candidates;
    mapping(address => bool) userVoted;

    bool isWinnerSelected;
    bool isRewardRecieved;
    address winner;

    address owner;
    
    
    constructor(){
        owner = msg.sender;
    }
    
    function enroll() public payable {
        // Write your code here
        require(noOfCandidates !=3, "3 candiates have been selected");
        require(msg.value == 1 ether, "Candidate registeration amount is 1 ether");
        votes[msg.sender] = 0;
        candidates[msg.sender] = true;
        noOfCandidates++;
    }

    function vote(address candidate) public payable {
        // Write your code here
        require(noOfCandidates == 3, "Enrollment phase not complete");
        require(isWinnerSelected == false,"Winner is already selected");
        require(userVoted[msg.sender] == false, "User already voted");
        require(msg.value == 10000,"Voting cost is 10000 wei");
        require(candidates[candidate],"Candidate not available");
        votes[candidate]++;
        userVoted[msg.sender] = true;
        if(votes[candidate] == 5){
            winner = candidate;
            isWinnerSelected = true;
        }
    }

    function getWinner() public view returns (address) {
        // Write your code here
        require(isWinnerSelected, "Winner is not yet selected");
        return winner;
    }

    function claimReward() public {
        // Write your code here
        require(msg.sender == winner,"The sender is not the winner");
        require(isWinnerSelected,"Winner not yet selected");
        require(isRewardRecieved == false,"Reward already received by the winner");
        (bool sent,) = payable(winner).call{value:3 ether}("");
        isRewardRecieved = true;
        require(sent, "Reward claim failed");
    }

    function collectFees() public {
        // Write your code here
        require(msg.sender == owner,"Only owner can withdraw the fee");
        require(isRewardRecieved,"Winner has not collected the reward");
        selfdestruct(payable(owner));
    }
}
