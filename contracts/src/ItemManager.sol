// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Weapon
// Armour
// Consumable
// Accessory

contract ItemManager{

    struct Weapon   //is a weapon, so affects the offensive stats of the hero       
    {
        string name;
        uint256 damage;
        uint256 attackSpeed;
        uint256 criticalRate;
        uint256 criticalDamage;
    }
    struct Armour   // is an armour, so affects the defensive stats of the hero
    {
        string name;
        uint256 maxHealth;
        uint256 defense;
        uint256 healthRegeneration;
        uint256[] resistances; // 0 - stun, 1 - fire, etc.
    }
    struct Consumable   // is a consumable item, so affects the stats of the hero temporarily
    {
        string name;
        uint256 healthAffected;
        uint256 manaAffected;
        uint256 energyAffected;     //example: a consumable that converts all energy to mana
        uint256 cooldown; // cooldown time in seconds
        uint256 duration; // duration of the effect in seconds
    }
    struct Accessory    // is an accessory, so affects the special stats of the hero
    {
        string name;
        uint256 bonusEnergy;
        uint256 bonusMana;
        uint256 bonusManaRegen;
        uint256 bonusEnergyRegen;
    }

}
