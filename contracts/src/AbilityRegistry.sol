// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AbilityRegistry {
    uint256 public abilityId = 0;   //Used in get function

    struct Ability{
        uint256 id_ability;
        string name;            // name of the spell
        string effect;          // effect of the spell, e.g. Area of effect, single target, etc.
        uint256 manaCost;       // mana cost of the spell, used to determine if the player can cast it
        string description;


        uint256 basePower;      // base power of the spell, used to calculate damage or healing
        uint256 abilityType;           // use ints to describe the type of spell, attack, heal, buff, debuff etc.
        uint256 levelRequired;  // level required to cast the spell, used to determine if the player can cast it
        uint256 cooldown;       // cooldown of the spell, used to determine if the player can cast it again
        string element;         // the element of the spell, e.g. Fire, Water, Earth, Air, etc.
        string race;            // The race which can use the spell, e.g. Human, Elf, Orc, etc.
         
         // Additional fields can be added as needed, e.g.:
        // number of projectiles
        // directions
        // Area
        // range
        // type (circular, cone, line, multidirectional lines)
    }

    mapping(uint256 => Ability) public abilities;

    event AbilityRegistered(
        uint256 indexed id_ability,
        string name,
        string effect,
        uint256 basePower,
        uint256 abilityType,
        uint256 manaCost,
        uint256 levelRequired,
        string element,
        string race,
        uint256 cooldown
    );

    function registerAbility(
        string memory _name,
        string memory _effect,
        uint256 _manaCost,
        string memory _description,
        uint256 _basePower,
        uint256 _abilityType,
        uint256 _levelRequired,
        uint256 _cooldown,
        string memory _element,
        string memory _race
    ) external {
        abilityId++;
        abilities[abilityId] = Ability({
            id_ability: abilityId,
            name: _name,
            effect: _effect,
            manaCost: _manaCost,
            description: _description,
            basePower: _basePower,
            abilityType: _abilityType,
            levelRequired: _levelRequired,
            cooldown: _cooldown,
            element: _element,
            race: _race
        });

        emit AbilityRegistered(
            abilityId,
            _name,
            _effect,
            _basePower,
            _abilityType,
            _manaCost,
            _levelRequired,
            _element,
            _race,
            _cooldown
        );
    }

    function getAbility(uint256 _id) external view returns (Ability memory) {
        require(_id > 0 && _id <= abilityId, "Ability does not exist");
        return abilities[_id];
    }
}
