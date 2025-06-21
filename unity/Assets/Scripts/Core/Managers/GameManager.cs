using DialogueEditor;
using UnityEngine;


public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    private StateMachine<GameManager> gameStateMachine;

    #region GameManagerReferences
    [SerializeField] private GameObject pauseUI;
    private GameObject inventoryUI;
    #endregion

    void Awake()
    {
        // Enforce singleton
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject); // Prevent duplicates
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject); // Persist across scenes

        gameStateMachine = new StateMachine<GameManager>();
        inventoryUI = GameObject.FindGameObjectWithTag("InventoryCanvas");
    }

    void Start()
    {
        gameStateMachine.Initialize(new InGameState(this, gameStateMachine));
    }

    void Update()
    {
        gameStateMachine.HandleInput();
        gameStateMachine.LogicUpdate();
    }

    void FixedUpdate()
    {
        gameStateMachine.PhysicsUpdate();
    }

    public void ShowGameplayUI()
    {
        Debug.Log("Showing gameplay UI");
        // e.g., HUD.SetActive(true);
    }

    public void ShowInventoryUI()
    {
        if(inventoryUI == null)
        {
            Debug.LogError("Inventory UI not found! Make sure it has the tag 'InventoryCanvas'.");
            return;
        }
        inventoryUI.GetComponent<Canvas>().enabled = true;
        Debug.Log("Showing inventory UI");
        // e.g., InventoryUI.SetActive(true);
    }

    public void HideInventoryUI()
    {
        if(inventoryUI == null)
        {
            Debug.LogError("Inventory UI not found! Make sure it has the tag 'InventoryCanvas'.");
            return;
        }
        inventoryUI.GetComponent<Canvas>().enabled = false;
        Debug.Log("Hiding inventory UI");
    }

    public void ShowPauseMenu()
    {
        Debug.Log("Showing pause menu");
        // e.g., PauseMenu.SetActive(true);
    }

    public void HidePauseMenu()
    {
        Debug.Log("Hiding pause menu");
        // e.g., PauseMenu.SetActive(false);
    }
}
