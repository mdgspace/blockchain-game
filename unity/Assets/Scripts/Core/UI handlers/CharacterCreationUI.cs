using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;
using System.Collections;
using System;

public class CharacterCreationUI : MonoBehaviour
{
    [Header("UI Elements")]
    public GameObject loadingPanel;
    public GameObject createCharacterPanel;
    public GameObject characterListPanel;

    [Header("Create Character Form")]
    public TMP_InputField playerNameInput;
    public TMP_Dropdown raceDropdown;
    public Button createButton;

    [Header("Character List")]
    public Transform characterListParent;
    public Button characterItemPrefab;

    [Header("Status")]
    public TextMeshProUGUI statusText;

    private bool isCreatingCharacter = false;

    private void Start()
    {
        InitializeUI();
        StartCoroutine(LoadExistingCharacters());
    }

    private void InitializeUI()
    {
        // Initialize contract service
        //HeroContractService.Instance.InitializeContract();

        // Setup UI
        ShowLoadingState();

        // Setup create button
        createButton.onClick.AddListener(OnCreateCharacterClicked);

        // Setup race dropdown (add your races here)
        raceDropdown.options.Clear();
        raceDropdown.options.Add(new TMP_Dropdown.OptionData("Human"));
        raceDropdown.options.Add(new TMP_Dropdown.OptionData("Elf"));
        raceDropdown.options.Add(new TMP_Dropdown.OptionData("Orc"));
        raceDropdown.RefreshShownValue();
    }

    private IEnumerator LoadExistingCharacters()
    {
        statusText.text = "Loading existing characters...";

        // Wait a moment for contract initialization
        yield return new WaitForSeconds(1f);

        // For now, we'll just show the create character option
        // Later you can implement character loading here

        ShowCreateCharacterState();
        statusText.text = "Ready to create character";
    }

    private void ShowLoadingState()
    {
        loadingPanel.SetActive(true);
        createCharacterPanel.SetActive(false);
        characterListPanel.SetActive(false);
    }

    private void ShowCreateCharacterState()
    {
        loadingPanel.SetActive(false);
        createCharacterPanel.SetActive(true);
        characterListPanel.SetActive(false);
    }

    private void OnCreateCharacterClicked()
    {
        if (isCreatingCharacter) return;

        string playerName = playerNameInput.text.Trim();
        if (string.IsNullOrEmpty(playerName))
        {
            statusText.text = "Please enter a player name";
            return;
        }

        string selectedRace = raceDropdown.options[raceDropdown.value].text;
        StartCoroutine(CreateCharacter(playerName, selectedRace));
    }

    private IEnumerator CreateCharacter(string playerName, string raceName)
    {
        isCreatingCharacter = true;
        createButton.interactable = false;
        statusText.text = "Creating character on blockchain...";

        // Create resistance array (you can customize this)
        List<uint> resistances = new List<UInt32> { 10, 5, 15, 8 }; // Example resistances

        // Create a simple token URI (you can make this more sophisticated)
        string tokenURI = $"https://example.com/hero/{playerName}";

        // Call mint function
        string txHash = null;
        yield return StartCoroutine(CallMintHero(playerName, raceName, resistances, tokenURI,
            (result) => txHash = result));

        if (!string.IsNullOrEmpty(txHash))
        {
            statusText.text = "Character created successfully!";
            yield return new WaitForSeconds(2f);

            // Test retrieving the data (assuming token ID 0 for first mint)
            yield return StartCoroutine(TestRetrieveHeroData(0));

            // Transition to game scene
            SceneTransitionManager.Instance.OnCharacterSelected();
        }
        else
        {
            statusText.text = "Character creation failed. Please try again.";
            createButton.interactable = true;
        }

        isCreatingCharacter = false;
    }

    private IEnumerator CallMintHero(string playerName, string raceName, List<UInt32> resistances, string tokenURI, System.Action<string> callback)
    {
        var mintTask = HeroContractService.Instance.MintHero(playerName, raceName.ToLower(), resistances, tokenURI);

        while (!mintTask.IsCompleted)
        {
            yield return null;
        }

        if (mintTask.Exception != null)
        {
            Debug.LogError($"Mint failed: {mintTask.Exception.Message}");
            callback?.Invoke(null);
        }
        else
        {
            callback?.Invoke(mintTask.Result);
        }
    }

    private IEnumerator TestRetrieveHeroData(uint tokenId)
    {
        statusText.text = "Testing data retrieval...";

        var getDataTask = HeroContractService.Instance.GetHeroData(tokenId);

        while (!getDataTask.IsCompleted)
        {
            yield return null;
        }

        if (getDataTask.Exception != null)
        {
            Debug.LogError($"Data retrieval failed: {getDataTask.Exception.Message}");
            statusText.text = "Data retrieval test failed";
        }
        else if (getDataTask.Result != null)
        {
            var heroData = HeroContractService.Instance.ConvertToUnityHeroData(getDataTask.Result);
            Debug.Log($"Successfully retrieved hero: {heroData.playerName}, Race: {heroData.raceName}");
            statusText.text = "Data retrieval test successful!";
        }
        else
        {
            statusText.text = "No data found";
        }
    }
}