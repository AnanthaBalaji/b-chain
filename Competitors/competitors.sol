pragma solidity >0.7.0;

pragma solidity >=0.4.22 <=0.8.17;

contract Competitors {
    // Write your code here

    address maxDepositor = address(0);
    address depositor1 = address(0);
    address depositor2 = address(0);
    address owner = address(0);

    uint256 depositedAmount1 = 0 ether;
    uint256 depositedAmount2 = 0 ether;

    bool withdrew = false;


    constructor(){
        owner = msg.sender;
    }

    function deposit() external payable{
        require( msg.value == 1 ether, "Minimum 1 ether must be sent");
        require( depositedAmount1 + depositedAmount2 < 3 ether, "Max ether deposit reached");
        
        if(depositor1 == address(0)){
            depositor1 = msg.sender;
        }else if(depositor2 == address(0)){
            depositor2 = msg.sender;
        }


        if(msg.sender == depositor1){
            depositedAmount1 += msg.value;
        }else if(msg.sender == depositor2){
            depositedAmount2 += msg.value;
        }else{
            revert("You are not one of the depositors");
        }
    }



    function withdraw() external payable{
        require(depositedAmount1 + depositedAmount2 == 3 ether, "Max ether limit not reached");
        maxDepositor = depositedAmount1 > depositedAmount2? depositor1: depositor2;
        require(msg.sender == maxDepositor, "You are not the max depositor");
        (bool sent, ) = maxDepositor.call{
            value: depositedAmount1+depositedAmount2
        }("");
        require(sent, "Payment failed");
        withdrew = true;
    } 

    function destroy() external{
        require(msg.sender == owner," You are not the owner");
        require(withdrew, "Depositor hasn't withdrawn the amount");
        selfdestruct(payable(msg.sender));
    }

}