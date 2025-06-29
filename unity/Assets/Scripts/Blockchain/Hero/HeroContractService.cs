using Nethereum.Contracts;
using Nethereum.Web3;
using Nethereum.Web3.Accounts;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Numerics;
using System.Threading.Tasks;
using UnityEngine;

public class HeroContractService : MonoBehaviour
{
    public static HeroContractService Instance { get; private set; }

    private Web3 web3;
    private Contract heroContract;
    private Account account;

    // Replace with your deployed contract address
    private string contractAddress = "0x63be0a777Ba0388dcbee945C6b766780b2952195";

    // Place your contract ABI JSON string here
    private string contractABI;
    //private string abiFilePath = Path.Combine(Application.dataPath, "Scripts", "Blockchain", "Hero", "ABI");

    // Fuji testnet RPC
    private string rpcUrl = "https://api.avax-test.network/ext/bc/C/rpc";

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
        LoadContractABI();
        InitializeContract();
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


    private void LoadContractABI()
    {
        try
        {
            string contractJson = null;

            contractJson = Resources.Load("ABI/HeroABI")?.ToString();

            if (string.IsNullOrEmpty(contractJson))
            {
                Debug.LogError("Contract JSON file not found in either Resources or StreamingAssets folder");
                return;
            }

            // Parse the contract JSON to extract ABI
            ExtractABIFromContractJson(contractJson);
        }
        catch (Exception e)
        {
            Debug.LogError($"Failed to load contract ABI: {e.Message}");
        }
    }


    public void InitializeContract()
    {
        try
        {
            string privateKey = Web3AuthManager.Instance.GetPrivateKey();

            if (string.IsNullOrEmpty(privateKey))
            {
                Debug.LogError("Private key not found. Please login first.");
                return;
            }

            account = new Account(privateKey);
            web3 = new Web3(account, rpcUrl);
            heroContract = web3.Eth.GetContract(contractABI, contractAddress);

            Debug.Log("Hero contract initialized successfully");
        }
        catch (Exception e)
        {
            Debug.LogError($"Contract initialization failed: {e.Message}");
        }
    }

    public async Task<string> MintHero(string playerName, string raceName, List<UInt32> resistances, string tokenURI)
    {
        try
        {
            if (heroContract == null)
            {
                Debug.LogError("Contract not initialized");
                return null;
            }

            string walletAddress = Web3AuthManager.Instance.GetWalletAddress();

            var mintFunction = heroContract.GetFunction("mintHero");

            Debug.Log("Sending mint transaction...");
            var receipt = await mintFunction.SendTransactionAndWaitForReceiptAsync(
                from: walletAddress,
                gas: new Nethereum.Hex.HexTypes.HexBigInteger(300000),
                value: null,
                functionInput: new object[]
                {
                    playerName,
                    walletAddress,            // _owner
                    walletAddress.ToString(), // _playerID
                    raceName,
                    resistances.ToArray(),
                    tokenURI
                });

            Debug.Log($"Hero minted successfully! Transaction hash: {receipt.TransactionHash}");
            return receipt.TransactionHash;
        }
        catch (Exception e)
        {
            Debug.LogError($"Mint failed: {e.Message}");
            return null;
        }
    }

    public async Task<HeroDataOutput> GetHeroData(uint tokenId)
    {
        try
        {
            if (heroContract == null)
            {
                Debug.LogError("Contract not initialized");
                return null;
            }

            var heroDataFunction = heroContract.GetFunction("heroData");
            var heroDataInput = new HeroDataFunction() { TokenId = tokenId };

            var result = await heroDataFunction.CallDeserializingToObjectAsync<HeroDataOutput>(heroDataInput);

            Debug.Log($"Retrieved hero data for token {tokenId}");
            return result;
        }
        catch (Exception e)
        {
            Debug.LogError($"Get hero data failed: {e.Message}");
            return null;
        }
    }

    public HeroData ConvertToUnityHeroData(HeroDataOutput contractData)
    {
        var heroData = ScriptableObject.CreateInstance<HeroData>();

        heroData.playerName = contractData.PlayerName;
        heroData.playerID = contractData.PlayerID;
        heroData.level = (int)contractData.Level;
        heroData.isBanned = contractData.IsBanned;
        heroData.raceName = contractData.RaceTable.Name;
        heroData.equippedItems = new List<string>(contractData.EquippedItems);

        // Convert stats
        heroData.offensiveStats = new OffensiveStats
        {
            damage = (int)contractData.StatsTable.OffStats.Damage,
            attackSpeed = (int)contractData.StatsTable.OffStats.AttackSpeed,
            criticalRate = (int)contractData.StatsTable.OffStats.CriticalRate,
            criticalDamage = (int)contractData.StatsTable.OffStats.CriticalDamage
        };

        heroData.defensiveStats = new DefensiveStats
        {
            maxHealth = (int)contractData.StatsTable.DefStats.MaxHealth,
            defense = (int)contractData.StatsTable.DefStats.Defense,
            healthRegeneration = (int)contractData.StatsTable.DefStats.HealthRegeneration,
            resistances = contractData.StatsTable.DefStats.Resistances.ConvertAll(x => (int)x)
        };

        heroData.specialStats = new SpecialStats
        {
            maxEnergy = (int)contractData.StatsTable.SpecStats.MaxEnergy,
            energyRegeneration = (int)contractData.StatsTable.SpecStats.EnergyRegeneration,
            maxMana = (int)contractData.StatsTable.SpecStats.MaxMana,
            manaRegeneration = (int)contractData.StatsTable.SpecStats.ManaRegeneration
        };

        return heroData;
    }
}