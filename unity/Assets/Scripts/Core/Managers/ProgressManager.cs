using UnityEngine;

public class ProgressManager : MonoBehaviour
{
    [SerializeField] private HeroData heroData;
    public static ProgressManager Instance { get; private set; }
    public float PlayerExperience { get; private set; } = 0;

    public int statPointsAvailable { get; private set; } = 5;
    public int statPointsTotal { get; private set; } = 5;

    // Base stats
    public int constituionStats { get; private set; } = 1;
    public int strengthStats { get; private set; } = 1;
    public int dexterityStats { get; private set; } = 1;
    public int intelligenceStats { get; private set; } = 1;
    public int staminaStats { get; private set; } = 1;
    public int agilityStats { get; private set; } = 1;

    // Delta stats
    private int deltaConstitution = 0;
    private int deltaStrength = 0;
    private int deltaDexterity = 0;
    private int deltaIntelligence = 0;
    private int deltaStamina = 0;
    private int deltaAgility = 0;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void AddExperience(float amount)
    {
        PlayerExperience += amount;
        CheckLevelUp();
    }

    private void CheckLevelUp()
    {
        int experienceNeeded = heroData.level * 100;
        if (PlayerExperience >= experienceNeeded)
        {
            PlayerExperience -= experienceNeeded;
            heroData.level++;
            statPointsAvailable += 3;
            statPointsTotal += 3;
            Debug.Log($"Level Up! New Level: {heroData.level}");
        }
    }

    #region Stat Modification Methods

    private bool TrySpendStatPoint()
    {
        if (statPointsAvailable > 0)
        {
            statPointsAvailable--;
            return true;
        }
        Debug.LogWarning("No stat points available.");
        return false;
    }

    private void RefundStatPoint()
    {
        statPointsAvailable++;
    }

    public void IncreaseConstitution()
    {
        if (TrySpendStatPoint() && constituionStats + deltaConstitution + 1 >= 1)
        {
            deltaConstitution++;
            Debug.Log("Delta Constitution increased: " + deltaConstitution);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseConstitution()
    {
        if (constituionStats + deltaConstitution - 1 >= 1)
        {
            deltaConstitution--;
            RefundStatPoint();
            Debug.Log("Delta Constitution decreased: " + deltaConstitution);
        }
        else
        {
            Debug.LogWarning("Constitution cannot be decreased below 1.");
        }
    }

    public void IncreaseStrength()
    {
        if (TrySpendStatPoint() && strengthStats + deltaStrength + 1 >= 1)
        {
            deltaStrength++;
            Debug.Log("Delta Strength increased: " + deltaStrength);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseStrength()
    {
        if (strengthStats + deltaStrength - 1 >= 1)
        {
            deltaStrength--;
            RefundStatPoint();
            Debug.Log("Delta Strength decreased: " + deltaStrength);
        }
        else
        {
            Debug.LogWarning("Strength cannot be decreased below 1.");
        }
    }

    public void IncreaseDexterity()
    {
        if (TrySpendStatPoint() && dexterityStats + deltaDexterity + 1 >= 1)
        {
            deltaDexterity++;
            Debug.Log("Delta Dexterity increased: " + deltaDexterity);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseDexterity()
    {
        if (dexterityStats + deltaDexterity - 1 >= 1)
        {
            deltaDexterity--;
            RefundStatPoint();
            Debug.Log("Delta Dexterity decreased: " + deltaDexterity);
        }
        else
        {
            Debug.LogWarning("Dexterity cannot be decreased below 1.");
        }
    }

    public void IncreaseIntelligence()
    {
        if (TrySpendStatPoint() && intelligenceStats + deltaIntelligence + 1 >= 1)
        {
            deltaIntelligence++;
            Debug.Log("Delta Intelligence increased: " + deltaIntelligence);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseIntelligence()
    {
        if (intelligenceStats + deltaIntelligence - 1 >= 1)
        {
            deltaIntelligence--;
            RefundStatPoint();
            Debug.Log("Delta Intelligence decreased: " + deltaIntelligence);
        }
        else
        {
            Debug.LogWarning("Intelligence cannot be decreased below 1.");
        }
    }

    public void IncreaseStamina()
    {
        if (TrySpendStatPoint() && staminaStats + deltaStamina + 1 >= 1)
        {
            deltaStamina++;
            Debug.Log("Delta Stamina increased: " + deltaStamina);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseStamina()
    {
        if (staminaStats + deltaStamina - 1 >= 1)
        {
            deltaStamina--;
            RefundStatPoint();
            Debug.Log("Delta Stamina decreased: " + deltaStamina);
        }
        else
        {
            Debug.LogWarning("Stamina cannot be decreased below 1.");
        }
    }

    public void IncreaseAgility()
    {
        if (TrySpendStatPoint() && agilityStats + deltaAgility + 1 >= 1)
        {
            deltaAgility++;
            Debug.Log("Delta Agility increased: " + deltaAgility);
        }
        else
        {
            RefundStatPoint();
        }
    }

    public void DecreaseAgility()
    {
        if (agilityStats + deltaAgility - 1 >= 1)
        {
            deltaAgility--;
            RefundStatPoint();
            Debug.Log("Delta Agility decreased: " + deltaAgility);
        }
        else
        {
            Debug.LogWarning("Agility cannot be decreased below 1.");
        }
    }

    public void Confirm()
    {
        // Apply deltas to actual stats
        constituionStats += deltaConstitution;
        strengthStats += deltaStrength;
        dexterityStats += deltaDexterity;
        intelligenceStats += deltaIntelligence;
        staminaStats += deltaStamina;
        agilityStats += deltaAgility;

        // Apply effects to heroData (examples)
        heroData.offensiveStats.damage += deltaStrength;
        heroData.defensiveStats.maxHealth += deltaConstitution * 10;




        // Reset deltas
        deltaConstitution = 0;
        deltaStrength = 0;
        deltaDexterity = 0;
        deltaIntelligence = 0;
        deltaStamina = 0;
        deltaAgility = 0;

        Debug.Log("Stats confirmed.");
    }
    #endregion
}
