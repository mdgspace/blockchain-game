using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ItemType 
{
    Weapon,
    Armour,
    Consumable,
    Accessory,
    Default
}

public enum ArmourSlot
{
    Helmet,
    Chest,
    Leggings,
    Boots
}

[CreateAssetMenu(fileName = "New Item", menuName = "Inventory System/Items/Item")]
public class ItemObject : ScriptableObject
{
    public Sprite uiDisplay;
    public bool stackable;
    public ItemType type;
    [TextArea(5, 10)]
    public string description;
    public Item data = new Item();
    public float itemCost;
    public int maxItemStock;

    // Only one of these will be used based on `type`
    public WeaponData weaponData;
    public ArmourData armourData;
    public ConsumableData consumableData;
    public AccessoryData accessoryData;

    public Item CreateItem()
    {
        return new Item(this);
    }
}

[System.Serializable]
public class Item
{
    public string Name;
    public int Id = -1;

    // Type-specific data
    public ItemType type;
    public WeaponData weaponData;
    public ArmourData armourData;
    public ConsumableData consumableData;
    public AccessoryData accessoryData;
    public DefaultData defaultData;

    public Item() { }

    public Item(ItemObject item)
    {
        Name = item.name;
        Id = item.data.Id; // or item.data.Id if you're managing Ids separately
        type = item.type;

        switch (type)
        {
            case ItemType.Weapon:
                weaponData = item.weaponData;
                break;
            case ItemType.Armour:
                armourData = item.armourData;
                break;
            case ItemType.Consumable:
                consumableData = item.consumableData;
                break;
            case ItemType.Accessory:
                accessoryData = item.accessoryData;
                break;
            case ItemType.Default:
                defaultData = new DefaultData
                {
                    name = item.name,
                    notes = item.description // Assuming description is used for notes
                };
                break;
        }
    }
}


// [System.Serializable]
// public class ItemBuff : IModifier
// {
//     public Attributes attribute;
//     public int value;
//     public int min;
//     public int max;
//     public ItemBuff(int _min, int _max)
//     {
//         min = _min;
//         max = _max;
//         GenerateValue();
//     }

//     public void AddValue(ref int baseValue)
//     {
//         baseValue += value;
//     }

//     public void GenerateValue()
//     {
//         value = UnityEngine.Random.Range(min, max);
//     }
// }