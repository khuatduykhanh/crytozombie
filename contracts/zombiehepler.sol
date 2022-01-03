// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    modifier aboveLevel (uint _level, uint _zombieId) {
        require(Zombies[_zombieId].level >= _level);
        _;
    }

    function withDraw () external onlyOwner {
        address payable owner = payable(owner());
        owner.transfer(address(this).balance);
    }

    function setUpLevelFee (uint _Fee) external onlyOwner {
        levelUpFee = _Fee;
    }

    function levelUp (uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        Zombies[_zombieId].level++;

    }

    function changeName(uint _zombieId, string memory _newName) external aboveLevel(2,_zombieId) onlyOwnerOf(_zombieId) {
        Zombies[_zombieId].name = _newName;
    }

     function changeDna(uint _zombieId, string memory _newDna) external aboveLevel(20,_zombieId) onlyOwnerOf(_zombieId) {
        Zombies[_zombieId].name = _newDna;
    }

    function getZombiesByOwner(address _owner) external view returns(uint[] memory){
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for(uint i = 0; i < Zombies.length;i++){
            if(zombieToOwner[i] == _owner){
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}