// SPDX-License-Identifier: GPL-3.0  (License type of the contract)

pragma solidity >=0.7.0 <0.9.0;     

/// @title BurgerShop
/// @author Walobwa Dan
/*  A simple example of a smart contract that enables on to buy the burger of choice(normal or deluxe)
    the burger vendor can refund the eth paid for the burger by a refund function
    You can view the cost of a normal burger and a deluxe burger and also the balance of the contract in 
    eth
*/

contract BurgerShop{                
    // variable normalCost-> cost of normal burger
    // variable deluxeCost-> cost of deluxeBurger
    uint256 public normalCost = 0.2 ether;
    uint256 public deluxeCost = 0.4 ether;

    // event fired of when the buyBurger function is executed
    // param1 _form -> the address of the buyer
    // param2 _cost -> the cost of the burger intended to buy
    event bugerBought(address indexed _from, uint256 cost);

    // title modifier for some guard checks
    // param1 -> _cost ensured that the correct cost of the burger is inserted
    // require checks if the value of burger inserted is > or = to the cost of the available burgers
    modifier shouldPay(uint256 _cost){
        require(msg.value >= _cost, "Not enough Ether!");
        _;
    }

    // title allows the user to buy a normal Burger only
    // inherits the shouldPay modifier and takes the parameter of normalCost
    function buyBurger() payable public shouldPay(normalCost){
        emit bugerBought(msg.sender, normalCost);
    }

    // allows the user to buy the deluxe burger only
    // inherits the shouldPay modifier
    // @param1 only takes the price of a deluxe burger
    function buydeluxeBurger() payable public shouldPay(deluxeCost){
        emit bugerBought(msg.sender, deluxeCost);
    }

    // allows the shop to refund costs
    // @param1 takes the address of the person to be refunded
    // @param2 takes the amount of eth/wei to be refunded
    // @requirements, the refunded amount should be the price  a normal or deluxe burger

    function refundEth(address _to, uint256 _cost) payable public{
        require(_cost == normalCost || _cost == deluxeCost, "Refunding the wrong burger");
        uint256 balanceBeforeTransaction = address(this).balance;

        if(balanceBeforeTransaction >= _cost){
        (bool success,) = payable(_to).call{value: _cost}("");   
        require(success);         
        }else{
            revert("Invalid");
        }

        assert (address(this).balance == balanceBeforeTransaction - _cost);

    }

    // title checks the balance of the contract in wei.
    function checkBalance() public view returns(uint256){
        return address(this).balance;
    }
}