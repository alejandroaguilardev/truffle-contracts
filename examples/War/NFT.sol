// SPDX-License-Identifier: OSL-3.0
pragma solidity >=0.8.11;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

interface IAdministrators {
	function getPermission(address _address) external view returns (bool);

	function getBlock(address _address) external view returns (bool);

	function getContracts(string memory _contract) external view returns (address);
}

interface IRegisteringEntities {
	function getPermission(address _address) external view returns (bool);
}

interface IUsersSystem {
	function getAccess(
		address _address,
		uint8 _module,
		uint8 _value
	) external view returns (bool);
}

interface ICost {
	function transferCost(
		uint256 _amountOut,
		uint256 _amountInMax,
		uint256 _cost
	) external;
}

contract NFT is ERC721Enumerable {
	using Address for address;

	address private Administrators;
	string private baseURIextended;
	uint256 public counter;
	uint256 public price;

	constructor() ERC721('Firulaix', 'Dogs') {
		counter = 0;
		baseURIextended = 'https://ipfs.io/ipfs/';
		Administrators = 0x0000000000000000000000000000000000000000;
		price = 1000000000000000000;
	}

	function mint(
		address _to,
		uint256 _amountOut,
		uint256 _amountInMax
	) external returns (uint256) {
		require(!IAdministrators(Administrators).getBlock(msg.sender), 'Admin is Block');
		require(IRegisteringEntities(IAdministrators(Administrators).getContracts('RegisteringEntities')).getPermission(msg.sender), "ER isn't active");
		require(IUsersSystem(IAdministrators(Administrators).getContracts('User')).getAccess(msg.sender, 1, 1), 'No Permit');

		ICost(IAdministrators(Administrators).getContracts('Cost')).transferCost(_amountOut, _amountInMax, price);
		counter++;
		_safeMint(msg.sender, counter);
		transferFrom(msg.sender, _to, counter);
		return counter;
	}

	function tokensOfOwner(address _address) public view returns (uint256[] memory) {
		uint256 tokenCount = balanceOf(_address);
		uint256[] memory tokensId = new uint256[](tokenCount);
		for (uint256 i; i < tokenCount; i++) {
			tokensId[i] = tokenOfOwnerByIndex(_address, i);
		}
		return tokensId;
	}

	function _baseURI() internal view virtual override returns (string memory) {
		return baseURIextended;
	}

	function setBaseURI(string memory _baseURIextended) external {
		require(IAdministrators(Administrators).getPermission(msg.sender), "Admin isn't active");
		require(!IAdministrators(Administrators).getBlock(msg.sender), 'Admin is Block');
		baseURIextended = _baseURIextended;
	}

	function setAdministrators(address _address) external {
		require(IAdministrators(Administrators).getPermission(msg.sender), "Admin isn't active");
		require(!IAdministrators(Administrators).getBlock(msg.sender), 'Admin is Block');
		Administrators = _address;
	}

	function setPrice(uint256 _price) external {
		require(IAdministrators(Administrators).getPermission(msg.sender), "Admin isn't active");
		require(!IAdministrators(Administrators).getBlock(msg.sender), 'Admin is Block');
		price = _price;
	}
}
