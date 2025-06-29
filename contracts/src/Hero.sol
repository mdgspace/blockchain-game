// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Hero is ERC721, ERC721URIStorage, Ownable {
    uint64 public tokenCounter;

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

    // MINT FUNCTION - Removed onlyOwner modifier
    function mintHero(
        string memory _playerName,
        address _owner,
        string memory _playerID,
        string memory _raceName,
        uint32[] memory _resistances,
        string memory _tokenURI
    ) public {
        string[] memory emptyItems;

        _mint(_owner, tokenCounter);
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

        emit HeroMinted(tokenCounter, _owner, _playerName);
        tokenCounter++;
    }

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
        
        emit HeroStatsUpdated(tokenId, heroData[tokenId].level);
    }

    //  UPDATE HERO CORE STATS EXCEPT MAIN STAT POINTS
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
        
        emit HeroStatsUpdated(tokenId, newLevel);
    }

    //  UPDATE HERO EQUIPPED ITEMS ONLY
    function updateHeroItems(
        uint256 tokenId,
        string[] memory newEquippedItems
    ) public {
        require(ownerOf(tokenId) == msg.sender, "Only owner can update");
        heroData[tokenId].equippedItems = newEquippedItems;
        
        emit HeroItemsUpdated(tokenId);
    }

    // BAN HERO
    function banHero(uint256 tokenId) public onlyOwner {
        heroData[tokenId].isBanned = true;
        emit HeroBanned(tokenId);
    }

    // UNBAN HERO
    function unbanHero(uint256 tokenId) public onlyOwner {
        heroData[tokenId].isBanned = false;
        emit HeroUnbanned(tokenId);
    }

    // 🏷️ GET HERO DATA
    function getHeroData(
        uint256 tokenId
    ) public view returns (HeroData memory) {
        return heroData[tokenId];
    }

    // GET ALL HEROES OWNED BY AN ADDRESS
    function getHeroesByOwner(address owner) public view returns (uint256[] memory) {
        //require(owner != address(0), "Invalid owner address");
        
        uint256 ownerBalance = balanceOf(owner);
        if (ownerBalance == 0) {
            return new uint256[](0);
        }

        uint256[] memory ownedTokens = new uint256[](ownerBalance);
        uint256 foundTokens = 0;
        
        // Iterate through all tokens and collect owned ones
        for (uint256 tokenId = 0; tokenId < tokenCounter && foundTokens < ownerBalance; tokenId++) {
            // Check if token exists and is owned by the specified address
            if (_ownerOf(tokenId) == owner) {
                ownedTokens[foundTokens] = tokenId;
                foundTokens++;
            }
        }
        return ownedTokens;
    }

    // GET HERO COUNT BY OWNER
    // Additional utility function to quickly check hero count
    function getHeroCountByOwner(address owner) public view returns (uint256) {
        return balanceOf(owner);
    }

    // GET ACTIVE HEROES BY OWNER (non-banned only)
    // Enhanced function to get only active (non-banned) heroes
    function getActiveHeroesByOwner(address owner) public view returns (uint256[] memory) {
        require(owner != address(0), "Invalid owner address");
        
        uint256 ownerBalance = balanceOf(owner);
        if (ownerBalance == 0) {
            return new uint256[](0);
        }

        // First pass: count active heroes
        uint256 activeCount = 0;
        for (uint256 tokenId = 0; tokenId < tokenCounter; tokenId++) {
            if (_ownerOf(tokenId) == owner && !heroData[tokenId].isBanned) {
                activeCount++;
            }
        }

        // Second pass: collect active heroes
        uint256[] memory activeTokens = new uint256[](activeCount);
        uint256 currentIndex = 0;
        
        for (uint256 tokenId = 0; tokenId < tokenCounter && currentIndex < activeCount; tokenId++) {
            if (_ownerOf(tokenId) == owner && !heroData[tokenId].isBanned) {
                activeTokens[currentIndex] = tokenId;
                currentIndex++;
            }
        }
        
        return activeTokens;
    }
    //Small utility function 
    
    // Get hero basic info (lightweight for UI display)
    function getHeroBasicInfo(uint256 tokenId) public view returns (
        string memory playerName,
        uint32 level,
        bool isBanned,
        string memory raceName
    ) {
        HeroData memory hero = heroData[tokenId];
        return (hero.playerName, hero.level, hero.isBanned, hero.raceName);
    }

    // Get hero stats separately to avoid large struct serialization issues
    function getHeroOffensiveStats(uint256 tokenId) public view returns (
        uint32 damage,
        uint32 attackSpeed,
        uint32 criticalRate,
        uint32 criticalDamage
    ) {
        OffensiveStats memory stats = heroData[tokenId].stats.offensiveStats;
        return (stats.damage, stats.attackSpeed, stats.criticalRate, stats.criticalDamage);
    }

    function getHeroDefensiveStats(uint256 tokenId) public view returns (
        uint32 maxHealth,
        uint32 defense,
        uint32 healthRegeneration,
        uint32[] memory resistances
    ) {
        DefensiveStats memory stats = heroData[tokenId].stats.defensiveStats;
        return (stats.maxHealth, stats.defense, stats.healthRegeneration, stats.resistances);
    }

    function getHeroSpecialStats(uint256 tokenId) public view returns (
        uint32 maxEnergy,
        uint32 energyRegeneration,
        uint32 maxMana,
        uint32 manaRegeneration
    ) {
        SpecialStats memory stats = heroData[tokenId].stats.specialStats;
        return (stats.maxEnergy, stats.energyRegeneration, stats.maxMana, stats.manaRegeneration);
    }

    function getHeroStatPoints(uint256 tokenId) public view returns (
        uint32 constitution,
        uint32 strength,
        uint32 dexterity,
        uint32 intelligence,
        uint32 stamina,
        uint32 agility,
        uint32 remainingPoints
    ) {
        StatPointsAssigned memory stats = heroData[tokenId].stats.statPointsAssigned;
        return (
            stats.constitution,
            stats.strength,
            stats.dexterity,
            stats.intelligence,
            stats.stamina,
            stats.agility,
            stats.remainingPoints
        );
    }

    // Get equipped items (can be heavy, separate function)
    function getHeroEquippedItems(uint256 tokenId) public view returns (string[] memory) {
        return heroData[tokenId].equippedItems;
    }

    // Check if hero exists (useful for error handling in Unity)
    function heroExists(uint256 tokenId) public view returns (bool) {
        return tokenId < tokenCounter && _ownerOf(tokenId) != address(0);
    }

    // Batch function to get multiple heroes' basic info (Unity-friendly)
    function getMultipleHeroesBasicInfo(uint256[] memory tokenIds) public view returns (
        string[] memory playerNames,
        uint32[] memory levels,
        bool[] memory bannedStatus,
        string[] memory raceNames
    ) {
        uint256 length = tokenIds.length;
        playerNames = new string[](length);
        levels = new uint32[](length);
        bannedStatus = new bool[](length);
        raceNames = new string[](length);

        for (uint256 i = 0; i < length; i++) {
            HeroData memory hero = heroData[tokenIds[i]];
            playerNames[i] = hero.playerName;
            levels[i] = hero.level;
            bannedStatus[i] = hero.isBanned;
            raceNames[i] = hero.raceName;
        }

        return (playerNames, levels, bannedStatus, raceNames);
    }

    // Events for Unity to listen to (important for real-time updates)
    event HeroMinted(uint256 indexed tokenId, address indexed owner, string playerName);
    event HeroStatsUpdated(uint256 indexed tokenId, uint32 newLevel);
    event HeroItemsUpdated(uint256 indexed tokenId);
    event HeroBanned(uint256 indexed tokenId);
    event HeroUnbanned(uint256 indexed tokenId);
}