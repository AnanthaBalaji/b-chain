pragma solidity >=0.4.22 <=0.8.17;

contract MathUtils {
    function floor(int256 value) public pure returns (int256) {
        
        int256 remainder = value%10;
        return value - remainder; 
    }

    function ceil(int256 value) public pure returns (int256) {
        
        int256 remainder = value%10;
        if(remainder > 0){
            return value + (10 - remainder);
        }else if(value < 0){
            return value - (10-remainder);
        }
        return value;
    }

    function average(int256[] memory values, bool down)
        public
        pure
        returns (int256)
    {
        uint arrayLength = values.length;
        if(arrayLength == 0){
            return 0;
        }else{
            int256 total;
            for(uint idx; idx < arrayLength; idx++){
                total+=values[idx];
            }
            
            int256 avg = total/int256(arrayLength);
            return down ? floor(avg) : ceil(avg);
        }
    }
}
