// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FirutowerNFT is ERC721 {
    uint256 public MAX_TOKEN = 40;
    uint256 public PRICE = 0.005 ether;
    address public CREATOR = 0xbadFd50C08501e641D692A17B4aD1195D88bB564;
    uint256 public token_count;

    constructor() ERC721("FIRUTOWER NFTs", "FTNFT") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmcVcnNDB5MU7gihXrcqfvAmb21ZpU1DowoPGVdMGx4kAL/";
    }

    function mintNFT(address to) public payable
    {
        require(token_count < MAX_TOKEN, "Sold out");
        require(msg.value >= PRICE, "Must pay price");
        _mint(to, token_count);
        token_count  += 1;
    }

    function withdrawAll() public
    {
        (bool success, ) = CREATOR.call{value:address(this).balance}("");
        require(success, "Transfer failed.");
    }
}