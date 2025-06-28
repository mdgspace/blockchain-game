// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ItemManager.sol";

contract ItemManagerTest is Test {
    ItemManager manager;
    address owner = address(this);
    address player = address(0x1);

    function setUp() public {
        manager = new ItemManager("ipfs://base/");
    }

    function testCreateWeaponItem() public {
        ItemManager.WeaponData memory weapon = ItemManager.WeaponData({
            damage: 100,
            attackSpeed: 80,
            criticalRate: 20,
            criticalDamage: 150
        });

        uint256 itemid = manager.createWeaponItem(
            "Sword",
            "A sharp blade",
            ItemManager.Rarity.Rare,
            false,
            weapon
        );

        ItemManager.ItemMetadata memory meta = manager.getItemMetadata(itemid);
        assertEq(meta.name, "Sword");
        assertEq(uint(meta.itemType), uint(ItemManager.ItemType.Weapon));
        assertEq(meta.weapon.damage, 100);
    }

    function testCreateArmourItem() public {
        ItemManager.ArmourData memory armour = ItemManager.ArmourData({
            slot: ItemManager.ArmourSlot.Chest,
            maxHealth: 200,
            defense: 50,
            healthRegen: 5,
            resistances: new uint256[](0) // No resistances for this test
        });

        uint256 itemId = manager.createArmourItem(
            "Plate Armour",
            "Heavy protection",
            ItemManager.Rarity.Legendary,
            true,
            armour
        );

        ItemManager.ItemMetadata memory meta = manager.getItemMetadata(itemId);
        assertEq(meta.name, "Plate Armour");
        assertEq(uint(meta.itemType), uint(ItemManager.ItemType.Armour));
        assertEq(uint(meta.armour.slot), uint(ItemManager.ArmourSlot.Chest));
    }

    function testCreateAccessoryItem() public {
        ItemManager.AccessoryData memory accessory = ItemManager.AccessoryData({
            bonusEnergy: 10,
            bonusMana: 20,
            bonusManaRegen: 5,
            bonusEnergyRegen: 7
        });

        uint256 id = manager.createAccessoryItem(
            "Amulet of Wisdom",
            "Boosts intellect",
            ItemManager.Rarity.Epic,
            false,
            accessory
        );

        ItemManager.ItemMetadata memory meta = manager.getItemMetadata(id);
        assertEq(meta.name, "Amulet of Wisdom");
        assertEq(uint(meta.itemType), uint(ItemManager.ItemType.Accessory));
        assertEq(meta.accessory.bonusMana, 20);
    }

    function testMintReward() public {
        // create an item
        ItemManager.WeaponData memory weapon = ItemManager.WeaponData(
            100,
            80,
            20,
            150
        );
        uint256 itemid = manager.createWeaponItem(
            "Bow",
            "Ranged weapon",
            ItemManager.Rarity.Uncommon,
            true,
            weapon
        );

        // mint the item to player
        manager.mintReward(player, itemid, 1);

        assertEq(manager.balanceOf(player, itemid), 1);
    }

    function testMintBatchReward() public {
        ItemManager.WeaponData memory weapon = ItemManager.WeaponData(
            100,
            80,
            20,
            150
        );
        uint256 id1=manager.createWeaponItem(
            "Axe",
            "Heavy weapon",
            ItemManager.Rarity.Epic,
            false,
            weapon
        );
        uint256 id2 =manager.createWeaponItem(
            "Dagger",
            "Quick weapon",
            ItemManager.Rarity.Common,
            true,
            weapon
        );

        uint256[] memory ids = new uint256[](2);
        ids[0] = id1;
        ids[1] = id2;

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 2;
        amounts[1] = 3;

        manager.mintBatchReward(player, ids, amounts);

        assertEq(manager.balanceOf(player, id1), 2);
        assertEq(manager.balanceOf(player, id2), 3);
    }
}
