// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  // Type Declarations
  ExampleExternalContract public exampleExternalContract;

  // State variables
  mapping (address => uint256) public balances;
  uint256 public deadline = block.timestamp + 72 hours;
  uint256 public constant s_threshold = 1 ether;
  bool openForWithdraw = false;

  // Events
  event Stake(address, uint256);

  // Modifiers
  modifier notCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "executed");
    _;
  }

  // Constructor
  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Public Function
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  function execute() public notCompleted {
    require(block.timestamp > deadline, "Time is not pass");
    if(address(this).balance >= s_threshold){
          exampleExternalContract.complete{value: address(this).balance}();
          openForWithdraw = false;
    } else {
      openForWithdraw = true;
    }
  }


   function withdraw() public payable notCompleted {
    require(openForWithdraw = true);
    (bool success,) = msg.sender.call{value: balances[msg.sender]}("");
    balances[msg.sender] = 0;
    require(success, "Transaction is Failed");
  }


    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

  // Receive
    receive() external payable {
        stake();
  } 
}