// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Hero is ERC721, ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("Hero", "HERO") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    struct OffensiveStats {
        uint32 damage;
        uint32 attackSpeed;
        uint32 criticalRate;
        uint32 criticalDamage;
    }

    struct DefensiveStats {
        uint32 maxHealth;
        uint32 defense;
        uint32 healthRegeneration;
        uint32[] resistances;
    }

    struct SpecialStats {
        uint32 maxEnergy;
        uint32 energyRegeneration;
        uint32 maxMana;
        uint32 manaRegeneration;
    }

    struct StatPointsAssigned {
        uint32 constitution;
        uint32 strength;
        uint32 dexterity;
        uint32 intelligence;
        uint32 stamina;
        uint32 agility;
        uint32 remainingPoints;
    }

    struct Stats {
        OffensiveStats offensiveStats;
        DefensiveStats defensiveStats;
        SpecialStats specialStats;
        StatPointsAssigned statPointsAssigned;
    }

    struct HeroData {
        string playerName;
        string playerID;
        uint32 level;
        bool isBanned;
        string raceName;
        string[] equippedItems;
        Stats stats;
    }

    mapping(uint256 => HeroData) public heroData;

    // MINT FUNCTION (unchanged)
    function mintHero(
        string memory _playerName,
        address _owner,
        string memory _playerID,
        string memory _raceName,
        uint32[] memory _resistances,
        string memory _tokenURI
    ) public onlyOwner {
        string[] memory emptyItems;

        _safeMint(_owner, tokenCounter);
        _setTokenURI(tokenCounter, _tokenURI);

        heroData[tokenCounter] = HeroData({
            playerName: _playerName,
            playerID: _playerID,
            level: 1,
            isBanned: false,
            raceName: _raceName,
            equippedItems: emptyItems,
            stats: Stats({
                offensiveStats: OffensiveStats(5, 100, 10, 50),
                defensiveStats: DefensiveStats(100, 5, 1, _resistances),
                specialStats: SpecialStats(100, 5, 100, 5),
                statPointsAssigned: StatPointsAssigned(1, 1, 1, 1, 1, 1, 0)
            })
        });

        tokenCounter++;
    }

    // function _burn(
    //     uint256 tokenId
    // ) internal override(ERC721, ERC721URIStorage) {
    //     super._burn(tokenId);
    // }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function updateHeroMainStats(
        uint256 tokenId,
        uint32 constitution,
        uint32 strength,
        uint32 dexterity,
        uint32 intelligence,
        uint32 stamina,
        uint32 agility,
        uint32 remainingPoints
    ) public {
        require(ownerOf(tokenId) == msg.sender, "Only owner can update");
        StatPointsAssigned storage s = heroData[tokenId]
            .stats
            .statPointsAssigned;
        s.constitution = constitution;
        s.strength = strength;
        s.dexterity = dexterity;
        s.intelligence = intelligence;
        s.stamina = stamina;
        s.agility = agility;
        s.remainingPoints = remainingPoints;
    }

    // 🔁 UPDATE HERO CORE STATS EXCEPT MAIN STAT POINTS
    function updateHeroStats(
        uint256 tokenId,
        uint32 newLevel,
        uint32 damage,
        uint32 attackSpeed,
        uint32 criticalRate,
        uint32 criticalDamage,
        uint32 maxHealth,
        uint32 defense,
        uint32 healthRegen,
        uint32[] memory resistances,
        uint32 maxEnergy,
        uint32 energyRegen,
        uint32 maxMana,
        uint32 manaRegen
    ) public {
        require(ownerOf(tokenId) == msg.sender, "Only owner can update");

        HeroData storage h = heroData[tokenId];
        h.level = newLevel;

        h.stats.offensiveStats = OffensiveStats(
            damage,
            attackSpeed,
            criticalRate,
            criticalDamage
        );
        h.stats.defensiveStats = DefensiveStats(
            maxHealth,
            defense,
            healthRegen,
            resistances
        );
        h.stats.specialStats = SpecialStats(
            maxEnergy,
            energyRegen,
            maxMana,
            manaRegen
        );
    }

    // 🛡️ UPDATE HERO EQUIPPED ITEMS ONLY
    function updateHeroItems(
        uint256 tokenId,
        string[] memory newEquippedItems
    ) public {
        require(ownerOf(tokenId) == msg.sender, "Only owner can update");
        heroData[tokenId].equippedItems = newEquippedItems;
    }

    // 🔒 BAN HERO
    function banHero(uint256 tokenId) public onlyOwner {
        heroData[tokenId].isBanned = true;
    }

    // 🔓 UNBAN HERO
    function unbanHero(uint256 tokenId) public onlyOwner {
        heroData[tokenId].isBanned = false;
    }

    // 🏷️ GET HERO DATA
    function getHeroData(
        uint256 tokenId
    ) public view returns (HeroData memory) {
        return heroData[tokenId];
    }
}
