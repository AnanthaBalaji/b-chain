pragma solidity >0.7.0;

contract ConstructMatix{

    function construct2DIntMatrix(uint rows, uint cols, int256 value) public pure returns(int256[][] memory){

        int256[][] memory array = new int256[][](rows);
        for(uint row; row<rows; row++){
            int256[] memory subArray = new int256[](cols);
            for(uint col; col<cols; col++){
                subArray[col] = value;
            }
            array[row] = subArray;
        }
        return array;
    }

    function construct2DAddressMatrix(uint rows, uint cols) public view returns(address[][] memory){

        address[][] memory addresses = new address[][](rows);
        for(uint row; row<rows; row++){
            address[] memory subAddresses = new address[](cols);
            for(uint col; col<cols; col++){
                subAddresses[col] = msg.sender;
            }
            addresses[row] = subAddresses;
        }
        return addresses;

    }
}
