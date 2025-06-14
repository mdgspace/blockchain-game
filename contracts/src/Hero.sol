// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hero is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("Hero", "HERO") {
        tokenCounter = 0;
    }

    struct offensivestats{
        uint32 damage;
        uint32 attackspeed;
        uint32 criticalrate;
        uint32 criticaldamage;
    }
    struct defensivestats{
        uint32 maxhealth;
        uint32 defense;
        uint32 healthregeneration;
        uint32[] resistances;            //elements and stun resist
        // 0 - stun ,1-fire ...
    }
    struct specialstats{
        uint32 maxenergy;
        uint32 energyregeneration;
        uint32 maxmana;
        uint32 manaregeneration;
    }
    struct stats{
        // string name;
        offensivestats offstats; // offensive stat struct with the data above in that order.
        defensivestats defstats;
        specialstats specstats;
    }
    struct race{
        string name;
    }
    struct Herodata{
        string playername;
        string playerID;  
        uint32 level;    	// level of that character in the game they are referred to as 'Level'.       
        string[] equippeditem;
        stats statstable;		// stats statstable; 
        race racestable;       // race of that character, in the game they are referred to as 'Race'.
        bool isbanned;         // if true the user cannot play with this player.
    }   

    mapping(uint256 => Herodata) public heroData;
    
    function mintHero(
        string memory _playername,
        address _playerID,
        string memory _raceName,
        uint32[] memory _resistance,  //ispe ek baar discus kar lena humse
        string memory tokenURI
    ) public onlyOwner {

        string[] memory emptyArray;

        _safeMint(_playerID, tokenCounter);
        _setTokenURI(tokenCounter, tokenURI);

        heroData[tokenCounter] = Herodata({
            playername: _playername,
            playerID: _playerID,
            level: 1,
            equippeditem: emptyArray,
            statstable: stats({
                offstats: offensivestats(5, 100 , 10 , 50),
                defstats: defensivestats(100, 5, 1, _resistance),
                specstats: specialstats(100, 10, 100, 10)
            }),
            racestable: race(_raceName),
            isbanned: false
        });

        tokenCounter++;
    }

    function updateAttributes(
        uint256 tokenId,
        uint32 new_level,
        string[] new_equippeditem,
        stats new_statstable

    ) public {
        require(ERC721._ownerOf(tokenId) == msg.sender, "Token does not exist");

       Herodata storage data = heroData[tokenId];

        data.level = new_level;
        data.equippeditem = new_equippeditem;
        data.statstable = new_statstable;
    }
    //primary stats which go on L1 are:health,damage,defense,mana,energy
    //Secondary stats which go on L1 are:all others 
}
