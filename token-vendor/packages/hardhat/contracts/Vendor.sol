pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 theAmount, uint256 amountOfETH);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100; 
  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfEth = msg.value; 
    uint256 amountOfTokens = tokensPerEth * amountOfEth;
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, amountOfEth, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool success,) = owner().call{value: address(this).balance}("");
    require(success, "withdraw failed!");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    uint256 theAmount = _amount;
    uint256 amountOfETH = _amount / tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), theAmount);
    payable(msg.sender).transfer(amountOfETH);
    emit SellTokens(msg.sender, theAmount, amountOfETH);
  }

}
