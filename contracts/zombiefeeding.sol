// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./zombiefactory.sol"; // import file FactoryZombie.sol để kế thừa

interface KittyInterface {  //khai bao một interface để kết nốt với một hợp đồng khác không phải của mình 
    function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
);
}
contract ZombieFeeding is ZombieFactory { // hàm zombieFeeding kế thừa lại tất cả các hàm public trong ZombieFactory
    
    modifier onlyOwnerOf (uint _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        _;
    }

    KittyInterface kittyContract;

    function setKittyContractAddress (address _ckAddress) external onlyOwner {
        kittyContract = KittyInterface(_ckAddress);
    }


    function _triggerCooldown (zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);

    }

    function _isReady (zombie storage _zombie) internal view returns(bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    function feedAndMultiply (uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId) {
        zombie storage myzombie = Zombies[_zombieId];
        require(_isReady(myzombie) == true);
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (_targetDna + myzombie.dna)/2;
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName",newDna);
        _triggerCooldown(myzombie);
    }

    function feedOnKitty (uint _zombieId, uint _kittyId) public  {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna,"kitty");
    }
}