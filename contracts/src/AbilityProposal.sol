pragma solidity ^0.8.20;

contract AbilityProposal
{

    uint256 public proposalCount = 0;

    struct Proposal {
        uint256 id;
        address proposer;

        string name;            // name of the spell
        string effect;          // effect of the spell, e.g. Area of effect, single target, etc.
        uint256 manaCost;       // mana cost of the spell, used to determine if the player can cast it
        string description;

        uint256 startTime;
        uint256 endTime;

        bool executed;
        bool submitted;

        uint256 basePower;      // base power of the spell, used to calculate damage or healing
        uint256 abilityType;           // use ints to describe the type of spell, attack, heal, buff, debuff etc.
        uint256 levelRequired;  // level required to cast the spell, used to determine if the player can cast it
        uint256 cooldown;       // cooldown of the spell, used to determine if the player can cast it again


        // Additional fields can be added as needed, e.g.:
        // number of projectiles
        // directions
        // Area
        // range
        // type (circular, cone, line, multidirectional lines)

        string element;         // the element of the spell, e.g. Fire, Water, Earth, Air, etc.
        string race;            // The race which can use the spell, e.g. Human, Elf, Orc, etc.


    }

    mapping(uint256 => Proposal) public proposals;

    event SpellProposed(
        uint256 indexed id,
        address indexed proposer,
        string name,
        string effect,
        uint256 basePower,
        uint256 abilityType,
        uint256 manaCost,
        uint256 levelRequired,
        string element,
        string race,
        uint256 cooldown,

        string description,
        uint256 startTime
    );

    function submitProposal(
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
        proposalCount++;
        uint256 currentTime = block.timestamp;

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            name: _name,
            effect: _effect,
            manaCost: _manaCost, 
            description: _description,
            startTime: currentTime,
            endTime: currentTime + 1 days, // duration of 7 days
            executed: false,
            submitted: true,
            basePower: _basePower,
            abilityType: _abilityType,
            levelRequired: _levelRequired,
            element: _element,
            cooldown: _cooldown,
            race: _race
        });

        emit SpellProposed(
            proposalCount,
            msg.sender,
            _name,
            _effect,
            _basePower,
            _abilityType,
            _manaCost,
            _levelRequired,
            _element,
            _race,
            _cooldown,
            _description,
            currentTime
        );
    }


    function getProposal(uint256 _id) external view returns (Proposal memory) {
        require(_id > 0 && _id <= proposalCount, "Proposal does not exist");
        return proposals[_id];
    }
}