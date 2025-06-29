using System;
using Nethereum.Signer;
using Nethereum.Util;
using System.Collections.Generic;
using UnityEngine;
using static Web3Auth;

public class Web3AuthManager : MonoBehaviour
{
    public static Web3AuthManager Instance { get; private set; }

    private Web3Auth web3Auth;

    private string clientIdString = "BCFrdDlSvOrcYUU4iGDkF_nrj-dxwNjgA_C-xgvyf7QWHt45UKBfJ7WOcuD04ROjVwSYUxl224CUffKBB9e7BhE";

    private void Awake()
    {
        // Ensure only one instance exists
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // Keep this object across scenes
        }
        else if (Instance != this)
        {
            Destroy(gameObject); // Destroy duplicate instances
        }
    }

    void Start()
    {
        // Get the Web3Auth component
        web3Auth = GetComponent<Web3Auth>();

        // Subscribe to events
        web3Auth.onLogin += OnLogin;
        web3Auth.onLogout += OnLogout;

        // Set options - this should be called before any login attempts
        var options = new Web3AuthOptions()
        {
            clientId = clientIdString, // Replace with your actual client ID
            redirectUrl = new System.Uri("unity://auth"), // Convert string to Uri
            network = Web3Auth.Network.SAPPHIRE_DEVNET, // Note: TESTNET (uppercase)
            chainNamespace = Web3Auth.ChainNamespace.EIP155, // Note: EIP155 (uppercase)
            buildEnv = Web3Auth.BuildEnv.PRODUCTION,
            
            // Optional: Add chain config if needed
            // This goes in the login params, not here
        };

        web3Auth.setOptions(options);
    }

    public void Login()
    {
        // Create login parameters
        var loginParams = new LoginParams()
        {
            loginProvider = Provider.GOOGLE, // Use Provider enum
            // Optional: Add extra login params
            // mfaLevel = MfaLevel.DEFAULT,
            // curve = Curve.SECP256K1
        };

        // Call login with parameters
        web3Auth.login(loginParams);
    }

    public void Logout()
    {
        // You can pass a redirect URL and app state if needed
        web3Auth.logout(new System.Uri("unity://auth"), "logout_state");

        // Or use the parameterless version
        // web3Auth.logout();
    }

    // Event handlers
    private void OnLogin(Web3AuthResponse response)
    {
        Debug.Log("Login successful!");
        Debug.Log("Private Key: " + web3Auth.getPrivKey());
        Debug.Log("wallet address: " + GetWalletAddress());
        Debug.Log("User Info: " + response.userInfo.email);
        Debug.Log("User ID: " + response.userInfo.verifierId);

        //Debug.Log("userInfo object:" + response.userInfo);
        // You can access other user info properties:
        // response.userInfo.name
        // response.userInfo.profileImage
        // response.userInfo.aggregateVerifier
        // response.userInfo.dappShare
        // etc.
    }

    private void OnLogout()
    {
        Debug.Log("User logged out");
    }

    // Helper method to get user info after login
    public UserInfo GetUserInfo()
    {
        try
        {
            return web3Auth.getUserInfo();
        }
        catch (System.Exception e)
        {
            Debug.LogError("No user found: " + e.Message);
            return null;
        }
    }

    // Helper method to get private key
    public string GetPrivateKey()
    {
        return web3Auth.getPrivKey();
    }

    // Helper method to get Ed25519 private key (for Solana)
    public string GetEd25519PrivateKey()
    {
        return web3Auth.getEd25519PrivKey();
    }

    // Method to launch wallet services
    public void LaunchWallet()
    {
        try
        {
            var chainConfig = new ChainConfig()
            {
                chainNamespace = ChainNamespace.EIP155,
                chainId = "0xa869", // Fuji Testnet Chain ID
                rpcTarget = "https://api.web3auth.io/infura-service/v1/0xa869/BCFrdDlSvOrcYUU4iGDkF_nrj-dxwNjgA_C-xgvyf7QWHt45UKBfJ7WOcuD04ROjVwSYUxl224CUffKBB9e7BhE", // Correct Fuji RPC
                displayName = "Avalanche Fuji",
                ticker = "AVAX",
                tickerName = "Avalanche"
            };


            Debug.Log("Launching wallet services...");
            web3Auth.launchWalletServices(chainConfig);
            Debug.Log("LaunchWallet called.");
        }
        catch (Exception e)
        {
            Debug.LogError("Wallet launch failed: " + e.Message);
        }
    }


    // Method to enable MFA
    public void EnableMFA()
    {
        var loginParams = new LoginParams()
        {
            loginProvider = Provider.GOOGLE
        };

        web3Auth.enableMFA(loginParams);
    }

    void OnDestroy()
    {
        // Unsubscribe from events to prevent memory leaks
        if (web3Auth != null)
        {
            web3Auth.onLogin -= OnLogin;
            web3Auth.onLogout -= OnLogout;
        }
    }

    private void OnApplicationQuit()
    {
        Logout();
    }

    public string GetWalletAddress()
    {
        string privateKey = GetPrivateKey();

        var key = new EthECKey(privateKey);
        string address = key.GetPublicAddress();

        return address;
    }
}