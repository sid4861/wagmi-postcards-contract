const { METADATA_URL } = require("../constants");

const main = async () => {
    const wagmiPostcardContractFactory = await hre.ethers.getContractFactory("WagmiPostcard");
    const wagmiPostcardContract = await wagmiPostcardContractFactory.deploy(METADATA_URL);
    await wagmiPostcardContract.deployed();
    console.log(wagmiPostcardContract.address);
}

const runMain = async () => {
    try {
        await main();
        process.exit(1);
    } catch (error) {
        console.log(error);
        process.exit(0);
    }
}

runMain();