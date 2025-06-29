using Org.BouncyCastle.Security;
using TMPro;
using UnityEngine;

public class potionSystem : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    [SerializeField] private GameObject slot1;
    [SerializeField] private GameObject slot2;
    [SerializeField] private GameObject slot3;

    [SerializeField] private InventoryObject potionInventory;
    [SerializeField] private Player player; // Reference to the Player script
    private Item[] potionItems; // Array to hold potion items
    private InventorySlot slot;
    private Item potion;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (InputManager.Instance.Potion1Pressed)
        {
            UsePotion(1); // Use potion from slot 1
        }
        else if (InputManager.Instance.Potion2Pressed)
        {
            UsePotion(2); // Use potion from slot 2
        }
        else if (InputManager.Instance.Potion3Pressed)
        {
            UsePotion(3); // Use potion from slot 3
        }
    }

    private TextMeshProUGUI potioncount;
    private int potionCountValue = 0; // Initialize potion count value
    public void UsePotion(int slotNumber)
    {
        switch (slotNumber)
        {
            case 1:
                // Logic for using potion in slot 1
                Debug.Log("Using potion from slot 1");
                useItem(0); // Assuming slot 1 corresponds to index 0 in the potion inventory
                //updatePotionText();
                break;
            case 2:
                // Logic for using potion in slot 2
                Debug.Log("Using potion from slot 2");
                useItem(1); // Assuming slot 2 corresponds to index 1 in the potion inventory
                //updatePotionText();
                break;
            case 3:
                // Logic for using potion in slot 3
                Debug.Log("Using potion from slot 3");
                useItem(2); // Assuming slot 3 corresponds to index 2 in the potion inventory
                //updatePotionText();
                break;
            default:
                Debug.LogWarning("Invalid slot number: " + slotNumber);
                break;
        }
    }

    private void updatePotionText()
    {
        potioncount = slot1.GetComponentInChildren<TextMeshProUGUI>();
        Debug.Log(potioncount.text.ToString());
        if(potioncount.text.ToString() == "")
        {
            potionCountValue = 1;
        }else
        {
            potionCountValue = int.Parse(potioncount.text.ToString().Substring(1)); // Assuming the text is a valid integer
        }
        potionCountValue--; // Decrease potion count
        potioncount.text = potionCountValue.ToString(); // Update the text to reflect the new count
    }

    private void useItem(int slotNum)
    {
        slot = potionInventory.GetSlots[slotNum];
        potion = slot.item;

        if (potion != null && potion.Id >= 0)
        {
            // Logic to use the potion
            
            player.currentHealth += potion.consumableData.healthAffected; // Example of applying potion effect
            player.currentMana += potion.consumableData.manaAffected; // Example of applying potion effect
            player.currentEnergy += potion.consumableData.energyAffected; // Example of applying potion effect


            // Here you can add the logic to apply the potion's effects

            // Decrease the potion count in the UI
            updatePotionText();
        }
        else
        {
            Debug.Log("No valid potion found in the selected slot.");
        }

    }
}
