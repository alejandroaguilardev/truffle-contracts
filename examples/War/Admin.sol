// SPDX-License-Identifier: OSL-3.0
pragma solidity >=0.8.11;

import '@openzeppelin/contracts/access/Ownable.sol';

contract Administrators is Ownable {
	struct Admin {
		bool permission;
		string data;
	}

	mapping(address => Admin) public admin;
	mapping(address => bool) public blockAdress;
	mapping(string => address) public contracts;

	function getPermission(address _address) external view returns (bool) {
		return admin[_address].permission;
	}

	function getBlock(address _address) external view returns (bool) {
		return blockAdress[_address];
	}

	function getContracts(string memory _contract) external view returns (address) {
		return contracts[_contract];
	}

	function setAdmin(
		address _address,
		bool _permission,
		string memory _data
	) public onlyOwner {
		admin[_address] = Admin(_permission, _data);
	}

	function setPermition(address _address) public onlyOwner {
		admin[_address].permission = !admin[_address].permission;
	}

	function setContracts(string memory _contract, address _address) public onlyOwner {
		contracts[_contract] = _address;
	}
}
