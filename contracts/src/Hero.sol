// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hero {
    //make mutable nft
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
        uint32 stunresistance;
        string[] resistances;             //element we resist
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
        string resistance;
    }
    struct Herodata{
        string playername;
        string playerID;  
        uint32 level;  
        string[] activeskills;       //maybe,here it should actually be an object of class skill which be defind in skillproposal(haven't decided actually)
        string[] passiveskills;     //ideation neede on this (making a skill tree)
        stats statstable;		// stats statstable; 
        race racestable;       // race of that character, in the game they are referred to as 'Race'.  	     
        string[] equippeditems;
        bool isbanned;         // if true the user cannot play with this player.
    }

    //primary stats which go on L1 are:
    //Secondary stats which go on L1 are:
}