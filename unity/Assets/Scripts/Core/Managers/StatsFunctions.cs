using TMPro;
using UnityEngine;

public class StatsFunctions : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI strengthText;
    [SerializeField] private TextMeshProUGUI dexterityText;
    [SerializeField] private TextMeshProUGUI constitutionText;
    [SerializeField] private TextMeshProUGUI intelligenceText;
    [SerializeField] private TextMeshProUGUI staminaText;
    [SerializeField] private TextMeshProUGUI agilityText;

    public void increaseStrength()
    {
        Debug.Log("Increasing Strength");
        ProgressManager.Instance.IncreaseStrength();
        strengthText.text = ProgressManager.Instance.strengthStats.ToString();
    }

    public void increaseDexterity()
    {
        ProgressManager.Instance.IncreaseDexterity();
        dexterityText.text = ProgressManager.Instance.dexterityStats.ToString();
    }

    public void increaseConstitution()
    {
        ProgressManager.Instance.IncreaseConstitution();
        constitutionText.text = ProgressManager.Instance.constituionStats.ToString();
    }

    public void increaseIntelligence()
    {
        ProgressManager.Instance.IncreaseIntelligence();
        intelligenceText.text = ProgressManager.Instance.intelligenceStats.ToString();
    }

    public void increaseStamina()
    {
        ProgressManager.Instance.IncreaseStamina();
        staminaText.text = ProgressManager.Instance.staminaStats.ToString();
    }

    public void increaseAgility()
    {
        ProgressManager.Instance.IncreaseAgility();
        agilityText.text = ProgressManager.Instance.agilityStats.ToString();
    }

    public void decreaseStrength()
    {
        ProgressManager.Instance.DecreaseStrength();
        strengthText.text = ProgressManager.Instance.strengthStats.ToString();
    }

    public void decreaseDexterity()
    {
        ProgressManager.Instance.DecreaseDexterity();
        dexterityText.text = ProgressManager.Instance.dexterityStats.ToString();
    }

    public void decreaseConstitution()
    {
        ProgressManager.Instance.DecreaseConstitution();
        constitutionText.text = ProgressManager.Instance.constituionStats.ToString();
    }

    public void decreaseIntelligence()
    {
        ProgressManager.Instance.DecreaseIntelligence();
        intelligenceText.text = ProgressManager.Instance.intelligenceStats.ToString();
    }

    public void decreaseStamina()
    {
        ProgressManager.Instance.DecreaseStamina();
        staminaText.text = ProgressManager.Instance.staminaStats.ToString();
    }

    public void decreaseAgility()
    {
        ProgressManager.Instance.DecreaseAgility();
        agilityText.text = ProgressManager.Instance.agilityStats.ToString();
    }

    public void confirm()
    {
        ProgressManager.Instance.Confirm();
        Debug.Log("Stats confirmed. Changes applied.");
    }
}
