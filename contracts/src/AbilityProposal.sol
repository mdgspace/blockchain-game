// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./AbilityRegistry.sol";

contract AbilityProposal is AbilityRegistry {
    uint256 public proposalCount = 0;

    struct Proposal {
        uint256 id_proposal;
        address proposer;
        Ability abilityObj;
        uint256 startTime;

        // Additional fields can be added as needed, e.g.:
        // number of projectiles
        // directions
        // Area
        // range
        // type (circular, cone, line, multidirectional lines)
    }

    mapping(uint256 => Proposal) public proposals;

    event SpellProposed(
        uint256 indexed id_proposal,
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

        Ability memory newAbility = Ability({
            id_ability: proposalCount,
            name: _name,
            effect: _effect,
            manaCost: _manaCost,
            description: _description,
            basePower: _basePower,
            abilityType: _abilityType,
            levelRequired: _levelRequired,
            element: _element,
            race: _race,
            cooldown: _cooldown
        });

        proposals[proposalCount] = Proposal({
            id_proposal: proposalCount,
            proposer: msg.sender,
            abilityObj: newAbility,
            startTime: currentTime
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
