
const { ethers } = require("hardhat");
require("dotenv").config()
const { verify } = require("../utils/verify")

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  await deploy("DiceGame", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    value: ethers.utils.parseEther(".05"),
    log: true,
  });

  // Getting a previously deployed contract
  const DiceGame = await ethers.getContract("DiceGame", deployer);

  if (chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    await verify(DiceGame.address, [])
}

};
module.exports.tags = ["DiceGame"];
