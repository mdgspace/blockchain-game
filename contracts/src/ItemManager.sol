// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ItemManager is ERC1155, Ownable {
    enum ItemType {
        Weapon,
        Armour,
        Consumable,
        Accessory,
        Default
    }
    enum Rarity {
        Common,
        Uncommon,
        Rare,
        Epic,
        Legendary
    }
    enum ArmourSlot {
        Helmet,
        Chest,
        Leggings,
        Boots
    }

    struct WeaponData {
        uint256 damage;
        uint256 attackSpeed;
        uint256 criticalRate;
        uint256 criticalDamage;
    }

    struct ArmourData {
        ArmourSlot slot;
        uint256 maxHealth;
        uint256 defense;
        uint256 healthRegen;
        uint256[] resistances;
    }

    struct ConsumableData {
        uint256 healthAffected;
        uint256 manaAffected;
        uint256 energyAffected;
        uint256 cooldown;
        uint256 duration;
    }

    struct AccessoryData {
        uint256 bonusEnergy;
        uint256 bonusMana;
        uint256 bonusManaRegen;
        uint256 bonusEnergyRegen;
    }

    struct ItemMetadata {
        uint256 id;
        string name;
        string description;
        ItemType itemType;
        Rarity rarity;
        bool stackable;
        WeaponData weapon;
        ArmourData armour;
        ConsumableData consumable;
        AccessoryData accessory;
    }
    event ItemCreated(uint256 indexed itemId, string name, ItemType itemType);
    event ItemMinted(
        address indexed to,
        uint256 indexed itemId,
        uint256 amount
    );
    event ItemBatchMinted(
        address indexed to,
        uint256[] itemIds,
        uint256[] amounts
    );

    constructor(string memory baseURI) ERC1155(baseURI) Ownable(msg.sender) {}

    uint256 public nextItemId = 0;
    address public questManager;

    mapping(uint256 => ItemMetadata) public itemMetadata;
    uint256 public itemCounter;

    modifier onlyQuestManager() {
        require(msg.sender == questManager, "Not quest manager");
        _;
    }

    // 👑 ADMIN adds item to registry
    function registerItem(
        ItemMetadata memory meta
    ) external onlyOwner returns (uint256 itemId) {
        itemId = nextItemId++;
        itemMetadata[itemId] = meta;
    }

    // 🪙 Mint from QuestManager or Owner
    function mintReward(address to, uint256 itemId, uint256 amount) external {
        require(
            msg.sender == owner() || msg.sender == questManager,
            "Not authorized"
        );
        _mint(to, itemId, amount, "");
        emit ItemMinted(to, itemId, amount);
    }

    function mintBatchReward(
        address to,
        uint256[] memory itemIds,
        uint256[] memory amounts
    ) external {
        require(
            msg.sender == owner() || msg.sender == questManager,
            "Not authorized"
        );
        _mintBatch(to, itemIds, amounts, "");
        emit ItemBatchMinted(to, itemIds, amounts);
    }

    // ⚙️ Set QuestManager contract
    function setQuestManager(address _questManager) external onlyOwner {
        questManager = _questManager;
    }

    // 🧾 Get item info
    function getItemMetadata(
        uint256 itemId
    ) external view returns (ItemMetadata memory) {
        return itemMetadata[itemId];
    }

    function createWeaponItem(
        string memory name,
        string memory description,
        Rarity rarity,
        bool stackable,
        WeaponData memory weapon
    ) public onlyOwner returns (uint256) {
        ItemMetadata storage item = itemMetadata[nextItemId];

        item.description = description;
        item.itemType = ItemType.Weapon;
        item.name = name;
        item.id = nextItemId;
        item.rarity = rarity;
        item.stackable = stackable;
        item.weapon = weapon;
        emit ItemCreated(nextItemId, name, ItemType.Weapon);
        nextItemId++;

        return item.id;
    }

    function createArmourItem(
        string memory name,
        string memory description,
        Rarity rarity,
        bool stackable,
        ArmourData memory armour
    ) public onlyOwner returns (uint256) {
        ItemMetadata storage item = itemMetadata[nextItemId];

        item.description = description;
        item.itemType = ItemType.Armour;
        item.name = name;
        item.id = nextItemId;
        item.rarity = rarity;
        item.stackable = stackable;
        item.armour = armour;
        emit ItemCreated(nextItemId, name, ItemType.Armour);
        nextItemId++;

        return item.id;
    }

    function createConsumableItem(
        string memory name,
        string memory description,
        Rarity rarity,
        bool stackable,
        ConsumableData memory consumable
    ) public onlyOwner returns (uint256) {
        ItemMetadata storage item = itemMetadata[nextItemId];

        item.description = description;
        item.itemType = ItemType.Consumable;
        item.name = name;
        item.id = nextItemId;
        item.rarity = rarity;
        item.stackable = stackable;
        item.consumable = consumable;
        emit ItemCreated(nextItemId, name, ItemType.Consumable);
        nextItemId++;

        return item.id;
    }

    function createAccessoryItem(
        string memory name,
        string memory description,
        Rarity rarity,
        bool stackable,
        AccessoryData memory accessory
    ) public onlyOwner returns (uint256) {
        ItemMetadata storage item = itemMetadata[nextItemId];

        item.description = description;
        item.itemType = ItemType.Accessory;
        item.name = name;
        item.id = nextItemId;
        item.rarity = rarity;
        item.stackable = stackable;
        item.accessory = accessory;
        emit ItemCreated(nextItemId, name, ItemType.Accessory);
        nextItemId++;

        return item.id;
    }

    // Add similar functions for createArmourItem, createConsumableItem, createAccessoryItem as needed
}
