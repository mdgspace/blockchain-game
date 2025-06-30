// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Hero.sol";

contract HeroTest is Test {
    Hero hero;
    address admin = address(this);
    address player = address(0x1);

    function setUp() public {
        hero = new Hero();
    }

    function testMintHero() public {
        uint32[] memory resistances = new uint32[](2);
        resistances[0] = 10;
        resistances[1] = 20;

        hero.mintHero(
            "Alice",
            player,
            "0xABC",
            "Elf",
            resistances,
            "ipfs://QmTest/0.json"
        );

        assertEq(hero.ownerOf(0), player);
        Hero.HeroData memory data = hero.getHeroData(0);
        assertEq(data.playerName, "Alice");
        assertEq(data.level, 1);
    }

    // function testOnlyOwnerCanMint() public {
    //     uint32[] memory resistances = new uint32[](1);
    //     resistances[0] = 10;

    //     vm.prank(player);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             Ownable.OwnableUnauthorizedAccount.selector,
    //             player
    //         )
    //     );
    //     hero.mintHero(
    //         "Bob",
    //         player,
    //         "0xDEF",
    //         "Orc",
    //         resistances,
    //         "ipfs://QmXyz/1.json"
    //     );
    // }

    function testUpdateHeroStats() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 5;

        hero.mintHero(
            "Alice",
            player,
            "0xABC",
            "Elf",
            resistances,
            "ipfs://QmTest/0.json"
        );

        vm.prank(player);
        hero.updateHeroStats(
            0,
            10, // level
            20,
            100,
            30,
            150, // offensive
            500,
            50,
            10,
            resistances, // defensive
            200,
            10,
            300,
            15 // special
        );

        Hero.HeroData memory data = hero.getHeroData(0);
        assertEq(data.level, 10);
        assertEq(data.stats.offensiveStats.damage, 20);
        assertEq(data.stats.specialStats.maxMana, 300);
    }

    function testUpdateHeroMainStats() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 10;

        hero.mintHero(
            "Alice",
            player,
            "0xABC",
            "Elf",
            resistances,
            "ipfs://QmTest/0.json"
        );

        vm.prank(player);
        hero.updateHeroMainStats(0, 2, 3, 4, 5, 6, 7, 1);

        Hero.HeroData memory data = hero.getHeroData(0);
        assertEq(data.stats.statPointsAssigned.strength, 3);
        assertEq(data.stats.statPointsAssigned.agility, 7);
    }

    function testUpdateHeroItems() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 5;

        hero.mintHero(
            "Alice",
            player,
            "0xABC",
            "Elf",
            resistances,
            "ipfs://QmTest/0.json"
        );

        string[] memory items = new string[](2);
        items[0] = "Sword of Fire";
        items[1] = "Armor of Ice";

        vm.prank(player);
        hero.updateHeroItems(0, items);

        Hero.HeroData memory data = hero.getHeroData(0);
        assertEq(data.equippedItems[0], "Sword of Fire");
        assertEq(data.equippedItems[1], "Armor of Ice");
    }

    function testBanAndUnbanHero() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 0;

        hero.mintHero(
            "BanTest",
            player,
            "0xBANNED",
            "Human",
            resistances,
            "ipfs://QmBan/3.json"
        );

        hero.banHero(0);
        assertTrue(hero.getHeroData(0).isBanned);

        hero.unbanHero(0);
        assertFalse(hero.getHeroData(0).isBanned);
    }

    function testGetHeroData() public {
        uint32[] memory resistances = new uint32[](2);
        resistances[0] = 10;
        resistances[1] = 20;

        // Mint a hero to test
        hero.mintHero(
            "Alice",
            player,
            "0xABC",
            "Elf",
            resistances,
            "ipfs://QmTest/0.json"
        );

        // Fetch the hero data
        Hero.HeroData memory data = hero.getHeroData(0);

        // Assertions
        assertEq(data.playerName, "Alice");
        assertEq(data.playerID, "0xABC");
        assertEq(data.level, 1);
        assertEq(data.raceName, "Elf");
        assertEq(data.stats.defensiveStats.resistances[0], 10);
        assertEq(data.stats.defensiveStats.resistances[1], 20);
        assertEq(data.isBanned, false);
    }

    function testGetHeroesByOwner() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 10;

        hero.mintHero("A", player, "ID1", "Elf", resistances, "uri1");
        hero.mintHero("B", admin, "ID2", "Orc", resistances, "uri2");

        uint256[] memory adminHeroes = hero.getHeroesByOwner(admin);
        assertEq(adminHeroes.length, 1);
        assertEq(adminHeroes[0], 1);

        uint256 count = hero.getHeroCountByOwner(admin);
        assertEq(count, 1);
    }

    function testGetHeroBasicInfo() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 5;

        hero.mintHero("Zara", player, "IDZ", "Human", resistances, "uriZ");

        (
            string memory name,
            uint32 level,
            bool banned,
            string memory race
        ) = hero.getHeroBasicInfo(0);
        assertEq(name, "Zara");
        assertEq(level, 1);
        assertEq(banned, false);
        assertEq(race, "Human");
    }

    function testGetActiveHeroesByOwner() public {
        uint32[] memory resistances = new uint32[](2);
        resistances[0] = 10;

        hero.mintHero("A", player, "ID1", "Elf", resistances, "uri1");
        hero.mintHero("B", player, "ID2", "Orc", resistances, "uri2");

        // Ban one of them
        hero.banHero(1);

        vm.prank(player);
        uint256[] memory activeHeroes = hero.getActiveHeroesByOwner(player);
        assertEq(activeHeroes.length, 1);
        assertEq(activeHeroes[0], 0);
    }

    function testGetMultipleHeroesBasicInfo() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 1;

        hero.mintHero("Hero1", player, "ID1", "Race1", resistances, "uri1");
        hero.mintHero("Hero2", player, "ID2", "Race2", resistances, "uri2");

        uint256[] memory ids = new uint256[](2);
        ids[0] = 0;
        ids[1] = 1;

        (
            string[] memory names,
            uint32[] memory levels,
            bool[] memory bans,
            string[] memory races
        ) = hero.getMultipleHeroesBasicInfo(ids);

        assertEq(names[0], "Hero1");
        assertEq(races[1], "Race2");
        assertEq(bans[0], false);
        assertEq(levels[1], 1);
    }

    function testHeroExists() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 1;

        hero.mintHero("X", player, "IDX", "RaceX", resistances, "uriX");

        assertTrue(hero.heroExists(0));
        assertFalse(hero.heroExists(1)); // not minted
    }
}
