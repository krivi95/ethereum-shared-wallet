// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract Allowance is Ownable{
    
    using SafeMath for uint;
    
    mapping(address => uint) public allowance;
    
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);
    
    modifier ownerOrAllowed(uint _amount){
        //Only owner or person who is given allowance (and has positive balance) can withdraw the money
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed to withdraw the money!");
        _;
    }
    
    function isOwner() public view returns(bool) {
        //Checking is account interacting with SC is owner of the account.
        return msg.sender == owner();
    }
    
    function contractBalance() public view returns(uint) {
        //Returns balace of ether on this contract in Wei.
        return address(this).balance;
    }
    
    function addAllowance(address _to, uint _amount) public onlyOwner {
        //Adding allowance to address (only owner can do that)
        emit AllowanceChanged(_to, msg.sender, allowance[_to], _amount);
        allowance[_to] = _amount;
    }
    
    function reduceAllowance(address _from, uint _amount) internal {
        emit AllowanceChanged(_from, msg.sender, allowance[_from], allowance[_from].sub(_amount));
        allowance[_from] = allowance[_from].sub(_amount);
    }
}