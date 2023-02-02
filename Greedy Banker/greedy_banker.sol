pragma solidity >=0.4.22 <=0.8.17;

contract GreedyBanker {
 uint fee;
    address owner;
    mapping(address => bool) isDeposited;
    mapping(address => uint) balances;


    constructor(){
        owner = msg.sender;
    }

    receive() external payable {

        if(isDeposited[msg.sender] == false){
            balances[msg.sender] += msg.value;
            isDeposited[msg.sender] = true;
        }else if(msg.value < 1000 wei){
            revert("Minimum deposit fee is 1000 wei");
        }else{
            balances[msg.sender] += msg.value - 1000 wei;
            fee +=1000 wei;
        }
    }

    fallback() external payable {
        fee+= msg.value;
    }

    function withdraw(uint256 amount) external {
        require(amount <= balances[msg.sender],"Insufficient balance");
        balances[msg.sender] -= amount;
        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require(sent, "Amount withdrawal unsuccessful");
    }

    function collectFees() external {
        require(msg.sender == owner, "Only owner can collect the fee");
        (bool sent,) = payable(owner).call{value: fee}("");
        fee = 0;
        require(sent, "Fee withdrawal unsuccessful");
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
