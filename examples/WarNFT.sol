// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WarNFT is ERC721Enumerable, Ownable {
    using Address for address;

    // counter Id
    uint256 public counter = 0;

    // Price of each token
    uint256 public initPrice = 0;
    uint256 public price;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // mapping CodPets
    mapping(string => uint256
    ) private _codPets;


    // Base URI
    string private _baseURIextended = "https://ipfs.io/ipfs/";

    // List of addresses Registering entity
    mapping(address => bool) public entityRegistering;

    constructor() ERC721("Firulaix", "PETS") {
        price = initPrice;
    }

    // Standard mint function
    function mintToken(string memory _uri, string memory _cod) public {
        bool _status = entityRegistering[msg.sender];
        uint exist_cod = _codPets[_cod];
        require(_status, "entityRegistering isn't active");
        require(exist_cod > 0, "codigo exists");
        // require( _amount == price, "Wrong amount" );
        counter += 1;
        _safeMint(msg.sender, counter);
        _setTokenURI(counter, _uri);
        _setCodPets(counter, _cod);
    }

    // See which address owns which tokens
    function tokensOfOwner(address _address)
        public
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_address);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_address, i);
        }
        return tokensId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(abi.encodePacked(_baseURIextended, _tokenURIs[tokenId]));
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        virtual
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setCodPets(uint256 tokenId, string memory cod) internal virtual {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        
        _codPets[cod] = tokenId;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    // create/edit entityRegistering
    function editEntityRegistering(address _address)
        public
        onlyOwner
    {
        entityRegistering[_address] = !entityRegistering[_address];
    }

    // Set a different price
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function getPeats(string memory _search) public view returns (uint256) {
        return _codPets[_search];
    }
}
