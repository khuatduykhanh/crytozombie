// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;
import "./zombiehepler.sol";
import "./safemath.sol";
contract ZombieAttack is ZombieHelper {
    
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
 
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function ranDom (uint _modulus) internal returns(uint) {
        randNonce =  randNonce.add(1);
        return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus;
    }

    function attack (uint _zombieId,uint _targetZombieId) external onlyOwnerOf(_zombieId) {
        zombie storage myZombie = Zombies[_zombieId];
        zombie storage enemyZombie = Zombies[_targetZombieId];
        uint rand = ranDom(100);
        if(rand < attackVictoryProbability){
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId,enemyZombie.dna,"zombie");
        } else {
            enemyZombie.winCount++;
            myZombie.lossCount++;
            _triggerCooldown(myZombie);
        }
        
    }

}