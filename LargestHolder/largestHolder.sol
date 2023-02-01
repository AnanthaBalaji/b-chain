pragma solidity >0.7.0;


contract LargestHolder{

uint256[] balances;
    address[] holders;

    address largestHolder;
    uint256 largestBalance;

    uint256 txnRequired;
    bool balanceSubmitted;

    uint256 processStartIndex;
    uint256 processEndIndex;


    function submitBalances(
        uint256[] memory _balances,
        address[] memory _holders
    ) public {
        // Write your code here
        require(!balanceSubmitted, "balances have already been submitted");
        holders = _holders;
        balances = _balances;

        balanceSubmitted  =true;

        txnRequired = holders.length / 10;
        if (txnRequired *10 < holders.length){
            txnRequired++ ;
        }
        processEndIndex = 10;
        if(processEndIndex > balances.length){
            processEndIndex = balances.length;
        }

    }

    function process() public {
        // Write your code here
        require(balanceSubmitted,"Balance should be submitted");
        require(txnRequired > 0, "BAlaces have been processed");

        for(uint256 idx = processStartIndex; idx < processEndIndex; idx++ ){
            if(balances[idx] > largestBalance){
                largestHolder = holders[idx];
                largestBalance = balances[idx];
            }
        }

        processStartIndex = processEndIndex;
        processEndIndex+=10;
        if(processEndIndex > balances.length){
            processEndIndex = balances.length;
        }
        txnRequired--;

    }

    function numberOfTxRequired() public view returns (uint256) {
        // Write your code here
        require(balanceSubmitted, "Balance is not submited.");
        return txnRequired;
    }

    function getLargestHolder() public view returns (address) {
        // Write your code here
        require(txnRequired ==0, "Largest holder is not yet determined.");
        return largestHolder;
    }
}