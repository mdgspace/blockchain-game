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

    function testOnlyOwnerCanMint() public {
        uint32[] memory resistances = new uint32[](1);
        resistances[0] = 10;

        vm.prank(player);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                player
            )
        );
        hero.mintHero(
            "Bob",
            player,
            "0xDEF",
            "Orc",
            resistances,
            "ipfs://QmXyz/1.json"
        );
    }

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
}
