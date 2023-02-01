pragma solidity >=0.4.22 <=0.8.17;

contract EtherMath {
    int256[] challengerArray;
    int256 challengerTargetSum;
    uint256 challengerRewards;

    bool isChallengeSubmitted;
    bool isChallengeSolved;


    mapping(address => uint256) winnerRewards;
    mapping(address => bool) userAnswered;

    address owner;


    constructor(){
        owner = msg.sender;
    }


    function validate_challenge(int256[] memory userArray) public view returns(bool isSolved){
        int256 calcSum;
        for(uint idx; idx < userArray.length; idx++){
            bool isNumberUsable;
            for(uint chIdx; chIdx< challengerArray.length; chIdx++){
                if(userArray[idx] == challengerArray[idx]){
                    isNumberUsable = true;
                    break;
                }
            }
            if(isNumberUsable){
                calcSum+=userArray[idx];
            }else{
                return false;
            }
            
       }
       if(calcSum == challengerTargetSum){
        return true;
       }
       return false;
    }


    function submitChallenge(int256[] memory array, int256 targetSum)
        public
        payable
    {
        require(msg.sender == owner, "Only owner can set challenge");
        require(msg.value > 0 ether,"The reward cannot be less than 0 ether");
        challengerArray = array;
        challengerTargetSum = targetSum;
        challengerRewards = msg.value;
        isChallengeSubmitted = true;
    }

    function submitSolution(int256[] memory solution) public {

        require(isChallengeSubmitted,"Challenge has been submitted");
        require(userAnswered[msg.sender] == false, "User can submit only one solution");
        
        userAnswered[msg.sender] = true;
        if(validate_challenge(solution)){
            winnerRewards[msg.sender] += challengerRewards;
            isChallengeSubmitted = false;
            delete challengerArray;
            delete challengerTargetSum;
            delete challengerRewards;
        }
    }

    function claimRewards() public {
        // Write your code here
        (bool sent,) = payable(msg.sender).call{value: winnerRewards[msg.sender]}("");
        require(sent);
    }
}
