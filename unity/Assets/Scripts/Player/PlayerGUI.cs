using UnityEngine;
using UnityEngine.UI;

public class PlayerGUI : MonoBehaviour
{
    public GameObject Player;
    public Slider HealthSlider;
    public Slider StaminaSlider;
    public Slider ManaSlider;
    public Text HealthText;
    public Text EnergyText;
    public Text ManaText;
    public float maxHealth, maxEnergy, maxMana;
    private Player player;
    // Update is called once per frame
    void Start()
    {
        player = Player.GetComponent<Player>();
        maxHealth = player.heroData.defensiveStats.maxHealth;
        maxEnergy = player.heroData.specialStats.maxEnergy;
        maxMana = player.heroData.specialStats.maxMana;
    }
    void Update()
    {
        HealthSlider.value = player.currentHealth / maxHealth;
        StaminaSlider.value = player.currentEnergy / maxEnergy;
        ManaSlider.value = player.currentMana / maxMana;
    }
}
