// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "c:/Users/aega2/Documents/proyectos/qolkrex/truffle-contracts/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "c:/Users/aega2/Documents/proyectos/qolkrex/truffle-contracts/node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721Enumerable, Ownable {
    uint256 public lastTokenId;
    string public baseTokenURI;
    string public staticUrl;
    bool public isStaticUrl;

    constructor(
        string memory name,
        string memory symbol,
        string memory _staticUrl
    ) ERC721(name, symbol) {
        lastTokenId = 0;
        baseTokenURI = "https://ipfs.io/ipfs/";
        isStaticUrl = true;
        staticUrl = _staticUrl;
    }

    function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function setStaticUrl(string memory _staticUrl) public onlyOwner {
        staticUrl = _staticUrl;
    }

    function setIsStaticUrl(bool _isStaticUrl) public onlyOwner {
        isStaticUrl = _isStaticUrl;
    }

    function _baseURI() internal view override returns (string memory) {
        if (isStaticUrl) {
            return staticUrl;
        } else {
            return super._baseURI();
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (isStaticUrl) {
            return staticUrl;
        } else {
            return super.tokenURI(tokenId);
        }
    }

    function mint(address to) public onlyOwner {
        uint256 newTokenId = lastTokenId + 1;
        _mint(to, newTokenId);
        lastTokenId = newTokenId;
    }
}
