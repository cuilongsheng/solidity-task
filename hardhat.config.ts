import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "hardhat-deploy";
import "@openzeppelin/hardhat-upgrades";
import dotenv from "dotenv";

dotenv.config();
if (!process.env.INFURA_API_KEY) {
  throw new Error("Please set your INFURA_API_KEY in a .env file");
}

if (!process.env.PRIVATE_KEY) {
  throw new Error("Please set your PRIVATE_KEY in a .env file");
}
const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.0", // 保留原始版本
      },
      {
        version: "0.8.20", // 添加支持 ^0.8.20 的版本
      },
      {
        version: "0.8.22", // 添加支持 ^0.8.22 的版本
      },
    ],
  },
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/" + process.env.INFURA_API_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  namedAccounts: {
    deployer: 0,
    user1: 1,
    user2: 2,
  },
};

export default config;
