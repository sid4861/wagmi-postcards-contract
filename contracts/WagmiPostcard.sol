//SPDX-license-identifier: MIT

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WagmiPostcard is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public _price = 0.013 ether;

    string _baseTokenURI;

    constructor(string memory baseURI)
        ERC721("wagmi-postcards", "WAGMIPOSTCARDS")
    {
        _baseTokenURI = baseURI;
    }

    /**
    @dev mints a wagmi postcard nft
     */
    function mintWagmiPostcard(
        // string memory _tokenURI,
        address payable _artistEthAddress,
        address recipientEthAddress
    ) public payable {
        require(
            msg.value >= _price,
            "Each Wagmi postcard NFT costs 0.013 ether"
        );
        (bool sentToArtist, ) = _artistEthAddress.call{value: 0.0065 ether}("");
        require(sentToArtist, "failed to send ether to artist");

        uint256 newTokenId = _tokenIds.current();
        _safeMint(recipientEthAddress, newTokenId);
        // _setTokenURI(newTokenId, _tokenURI);
        _tokenIds.increment();
    }

    /**
    @dev returns the count of wagmi postcards minted
     */

    function getMintedCount() public view returns (uint256) {
        return _tokenIds.current();
    }

    /**
        @dev overrides erc721 implementation
         */

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
    @dev sends ether from contract to owner's account
     */
    function withdrawEther() public onlyOwner {
        address owner = owner();
        uint256 contractBalance = address(this).balance;
        (bool sent, ) = owner.call{value: contractBalance}("");
        require(sent, "failed to withdraw");
    }

    receive() external payable {}

    fallback() external payable {}
}
