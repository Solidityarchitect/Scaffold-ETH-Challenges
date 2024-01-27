const { ethers } = require("hardhat");
require("dotenv").config()
const { verify } = require("../utils/verify")

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  
  await deploy("RiggedRoll", {
   from: deployer,
   args: [diceGame.address],
   log: true,
  });
  

  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);

  const ownershipTransaction = await riggedRoll.transferOwnership("0x7988Eff919A23bae1133e44FEAB5D9AD4F99d774");
  
  if (chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    await verify(riggedRoll.address, [diceGame.address])
}

};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
