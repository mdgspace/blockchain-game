
using Newtonsoft.Json.Linq;
using System;
using UnityEngine;

public class ContractConfigFunctions : MonoBehaviour
{
    public static ContractConfigFunctions Instance { get; private set; }
    public string contractABI { get; private set; }



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
        string contractJson = Resources.Load("ABI/SimpleRandomABI")?.ToString();
        ExtractABIFromContractJson(contractJson);
    }


    private void ExtractABIFromContractJson(string contractJson)
    {
        try
        {
            JObject contractData = JObject.Parse(contractJson);

            // Check if it's a full Forge contract JSON (has both abi and bytecode)
            if (contractData["abi"] != null)
            {
                // Extract just the ABI part and convert back to JSON string
                contractABI = contractData["abi"].ToString();
                Debug.Log("ABI extracted from full Forge contract JSON");
            }
            else if (contractData["abi"] == null && contractData.First != null)
            {
                // It's likely a direct ABI array
                contractABI = contractJson;
                Debug.Log("Using JSON as direct ABI");
            }
            else
            {
                Debug.LogError("Could not find ABI in the provided JSON");
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"Failed to parse contract JSON: {e.Message}");
        }
    }
}
