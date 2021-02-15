// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Allowance.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Allowance{
    
    //Events for balance changes
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyDeposited(address indexed from, uint _amount);
    
    function renounceOwnership() public override view onlyOwner {
        //Overriding function for renouncing ownership (function from Ownable contract)
        revert("Can't renounce ownership of this funds!");
    }
    
    receive() external payable {
        //Fallback receive function for anyone to deposit the funds.
        MoneyDeposited(msg.sender, msg.value);
    }
    
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(contractBalance() >= _amount, "There is not enough funds on the account!");
        if(!isOwner()){
            //For everyone who is given an allowance
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
}