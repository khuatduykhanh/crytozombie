// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;
import "./ownable.sol";
import "./safemath.sol";
contract ZombieFactory is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
 

    uint dnagigts = 16;
    uint dnaModulus = 10 ** dnagigts;
    uint cooldownTime = 1 days;
    struct zombie {
        uint dna;
        string name;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }
    mapping (uint=>address) public zombieToOwner;
    mapping (address=>uint) ownerZombieCount;
    event NewZombie (string name, uint zombieId, uint dna);
     
    zombie[] public Zombies;
    function _createZombie (string memory _name, uint _dna) internal {
       Zombies.push(zombie(_dna, _name,1,uint32(block.timestamp + cooldownTime),0,0));
       uint id = Zombies.length.sub(1); 
       zombieToOwner[id] = msg.sender;
       ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
       emit NewZombie(_name, id, _dna);
    }
    function _generateRandomDna (string memory _str) private view returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    function createRandomZombie (string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}  

   