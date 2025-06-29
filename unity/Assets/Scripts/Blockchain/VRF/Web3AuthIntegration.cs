using Nethereum.Web3;
using Nethereum.Web3.Accounts;
using System;
using UnityEngine;

public static class Web3AuthIntegration
{
    public static Web3 GetWeb3()
    {
        try
        {
            string privKey = Web3AuthManager.Instance.GetPrivateKey();
            if (string.IsNullOrEmpty(privKey))
            {
                Debug.LogError("Web3Auth: Private key not found. Make sure user is logged in.");
                return null;
            }

            var account = new Account(privKey, ContractConfig.CHAIN_ID);
            return new Web3(account, ContractConfig.RPC_URL);
        }
        catch (Exception e)
        {
            Debug.LogError("Error creating Web3 from Web3Auth: " + e.Message);
            return null;
        }
    }
}
