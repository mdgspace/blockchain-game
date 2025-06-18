using System.Collections.Generic;

[System.Serializable]
public class WeaponData
{
    public string name;
    public int damage;
    public float attackSpeed;
    public float criticalRate;
    public float criticalDamage;
}

[System.Serializable]
public class ArmourData
{
    public string name;
    public ArmourSlot slot; // Helmet, Chest, etc.
    public int maxHealth;
    public int defense;
    public float healthRegeneration;
    public List<int> resistances = new List<int>();
}

[System.Serializable]
public class ConsumableData
{
    public string name;
    public int healthAffected;
    public int manaAffected;
    public int energyAffected;
    public float cooldown;
    public float duration;
}

[System.Serializable]
public class AccessoryData
{
    public string name;
    public int bonusEnergy;
    public int bonusMana;
    public float bonusManaRegen;
    public float bonusEnergyRegen;
}
[System.Serializable]
public class DefaultData
{
    public string name;
    public string notes; // Add generic metadata or purpose
}