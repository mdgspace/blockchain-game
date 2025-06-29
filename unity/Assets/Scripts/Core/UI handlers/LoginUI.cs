using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class LoginUI : MonoBehaviour
{
    [Header("UI Elements")]
    public Button loginButton;
    public TextMeshProUGUI statusText;
    public GameObject loadingIndicator;

    private bool isLoggingIn = false;

    private void Start()
    {
        InitializeUI();

        // Subscribe to Web3Auth events if needed
        if (Web3AuthManager.Instance != null)
        {
            // Add event listeners for login success/failure
        }
    }

    private void InitializeUI()
    {
        loginButton.onClick.AddListener(OnLoginClicked);
        statusText.text = "Welcome! Please login to continue.";

        if (loadingIndicator != null)
            loadingIndicator.SetActive(false);
    }

    private void OnLoginClicked()
    {
        if (isLoggingIn) return;

        StartLogin();
    }

    private void StartLogin()
    {
        isLoggingIn = true;
        loginButton.interactable = false;
        statusText.text = "Logging in...";

        if (loadingIndicator != null)
            loadingIndicator.SetActive(true);

        // Call Web3Auth login
        Web3AuthManager.Instance.Login();

        // Start checking for login success
        InvokeRepeating(nameof(CheckLoginStatus), 1f, 1f);
    }

    private void CheckLoginStatus()
    {
        // Check if we have a private key (indicating successful login)
        string privateKey = Web3AuthManager.Instance.GetPrivateKey();

        if (!string.IsNullOrEmpty(privateKey))
        {
            OnLoginSuccess();
        }
    }

    private void OnLoginSuccess()
    {
        CancelInvoke(nameof(CheckLoginStatus));

        isLoggingIn = false;
        statusText.text = "Login successful! Transitioning...";

        if (loadingIndicator != null)
            loadingIndicator.SetActive(false);

        // Transition to character scene
        Invoke(nameof(TransitionToCharacterScene), 1f);
    }

    private void TransitionToCharacterScene()
    {
        SceneTransitionManager.Instance.OnLoginSuccess();
    }

    private void OnLoginFailed()
    {
        CancelInvoke(nameof(CheckLoginStatus));

        isLoggingIn = false;
        loginButton.interactable = true;
        statusText.text = "Login failed. Please try again.";

        if (loadingIndicator != null)
            loadingIndicator.SetActive(false);
    }

    private void OnDestroy()
    {
        CancelInvoke();
    }
}