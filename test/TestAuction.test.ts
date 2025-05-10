// @ts-nocheck
import { ethers, deployments, upgrades } from "hardhat";
import { expect } from "chai";

describe("Test auction", async function () {
  it("Should be ok", async function () {
    await main();
  });
});

const zeroAddress = "0x0000000000000000000000000000000000000000";
const sepoliaUsdcAddress = "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238";

async function main() {
  await deployments.fixture(["depolyNftAuction"]);
  const nftAuctionProxy = await deployments.get("NftAuctionProxy");
  console.log("nftAuctionProxy address:", nftAuctionProxy.address);
  const nftAuction = await ethers.getContractAt(
    "NftAuction",
    nftAuctionProxy.address
  );
  // console.log("nftAuction address:", nftAuction);
  const token2Usd = [
    {
      token: zeroAddress,
      priceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    },
    {
      token: sepoliaUsdcAddress,
      priceFeed: "0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E",
    },
  ];

  for (let i = 0; i < token2Usd.length; i++) {
    const { token, priceFeed } = token2Usd[i];
    await nftAuction.setPriceFeed(token, priceFeed);
  }

  const [signer, buyer] = await ethers.getSigners();
  console.log("signer address:", signer.address);
  console.log("buyer address:", buyer.address);

  // 1. 部署 ERC721 合约
  // 假设 TestERC721 合约构造函数需要一个字符串类型参数，这里将数值转换为字符串
  // 1. 部署 ERC721 合约
  const TestERC721 = await ethers.getContractFactory("TestERC721");
  const testERC721 = await TestERC721.deploy();
  await testERC721.waitForDeployment();
  const testERC721Address = await testERC721.getAddress();
  console.log("testERC721Address::", testERC721Address);

  // mint 10 个 NFT
  for (let i = 0; i < 10; i++) {
    await testERC721.mint(signer.address, i + 1);
  }

  const tokenId = 1;

  // 给代理合约授权
  await testERC721
    .connect(signer)
    .setApprovalForAll(nftAuctionProxy.address, true);

  await nftAuction.createAuction(
    10,
    ethers.parseEther("0.01"),
    testERC721Address,
    tokenId
  );

  const auction = await nftAuction.auctions(0);

  console.log("创建拍卖成功：：", auction);

  // 3. 购买者参与拍卖
  // ETH参与竞价
  await nftAuction
    .connect(buyer)
    .placeBid(0, 0, zeroAddress, { value: ethers.parseEther("0.01") });
  // USDC参与竞价
  await nftAuction.connect(buyer).placeBid(0, 50, sepoliaUsdcAddress);

  // 4. 结束拍卖
  // 等待 10 s
  await new Promise((resolve) => setTimeout(resolve, 10 * 1000));

  await nftAuction.connect(signer).endAuction(0);

  // 验证结果
  const auctionResult = await nftAuction.auctions(0);
  console.log("结束拍卖后读取拍卖成功：：", auctionResult);
  // expect(auctionResult.highestBidder).to.equal(buyer.address);
  // expect(auctionResult.highestBid).to.equal(ethers.parseEther("0.01"));

  // 验证 NFT 所有权
  const owner = await testERC721.ownerOf(tokenId);
  console.log("owner::", owner);
  expect(owner).to.equal(buyer.address);
}

main();
