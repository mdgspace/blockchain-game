using Nethereum.ABI.FunctionEncoding.Attributes;
using Nethereum.Contracts;
using Nethereum.Hex.HexTypes;
using Nethereum.JsonRpc.Client;
using Nethereum.RPC.Eth.DTOs;
using Nethereum.Web3;
using System.Numerics;
using System.Threading.Tasks;
using UnityEngine;

public class VRFEventListener : MonoBehaviour
{
    private Event<RandomGeneratedEventDTO> randomEvent;
    private Web3 web3;
    private HexBigInteger lastBlock;
    private int MAX_BLOCK_RANGE = 500; // Reduced range for more frequent checks
    private bool isChecking = false;

    [Event("RandomGenerated")]
    public class RandomGeneratedEventDTO : IEventDTO
    {
        [Parameter("uint32", "result", 1, false)] // Changed from true to false - not indexed
        public uint Result { get; set; }
    }

    async void Start()
    {
        web3 = Web3AuthIntegration.GetWeb3();

        if (web3 == null)
        {
            Debug.LogError("Failed to initialize Web3");
            return;
        }

        var contract = web3.Eth.GetContract(
            ContractConfigFunctions.Instance.contractABI,
            ContractConfig.CONTRACT_ADDRESS
        );

        randomEvent = contract.GetEvent<RandomGeneratedEventDTO>();

        // Start from a few blocks back to ensure we don't miss recent events
        try
        {
            var currentBlock = await web3.Eth.Blocks.GetBlockNumber.SendRequestAsync();
            lastBlock = new HexBigInteger(BigInteger.Max(0, currentBlock.Value - 10)); // Start 10 blocks back
            Debug.Log($"VRF Listener starting from block: {lastBlock.Value}");
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Failed to get current block: {e.Message}");
            lastBlock = new HexBigInteger(0);
        }

        // Start polling every 5 seconds instead of 10
        InvokeRepeating(nameof(CheckForEvent), 1f, 5f);
    }

    async void CheckForEvent()
    {
        if (isChecking) return; // Prevent overlapping calls
        isChecking = true;

        try
        {
            var latestBlock = await web3.Eth.Blocks.GetBlockNumber.SendRequestAsync();

            BigInteger from = lastBlock.Value;
            BigInteger to = BigInteger.Min(from + MAX_BLOCK_RANGE - 1, latestBlock.Value);

            if (to < from)
            {
                isChecking = false;
                return; // No new blocks yet
            }

            //Debug.Log($"Checking for events from block {from} to {to}");

            var filter = randomEvent.CreateFilterInput(
                new BlockParameter(new HexBigInteger(from)),
                new BlockParameter(new HexBigInteger(to))
            );

            var logs = await randomEvent.GetAllChangesAsync(filter);

            Debug.Log($"Found {logs.Count} RandomGenerated events");

            foreach (var log in logs)
            {
                Debug.Log($"?? RandomGenerated Event: {log.Event.Result} (Block: {log.Log.BlockNumber})");
                VRFResultRouter.Instance.TriggerResult(log.Event.Result);
            }

            // Update lastBlock to continue from the next block
            lastBlock = new HexBigInteger(to + 1);
        }
        catch (RpcResponseException e)
        {
            Debug.LogWarning($"?? VRFEventListener RPC error: {e.Message}");
            if (e.Message.Contains("query returned more than"))
            {
                // Reduce block range if we're querying too many blocks
                MAX_BLOCK_RANGE = Mathf.Max(100, MAX_BLOCK_RANGE / 2);
                Debug.Log($"Reduced MAX_BLOCK_RANGE to {MAX_BLOCK_RANGE}");
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError($"?? Unexpected error in VRF listener: {e}");
        }
        finally
        {
            isChecking = false;
        }
    }

    // Method to manually check for events from a specific transaction
    public async Task CheckSpecificTransaction(string txHash)
    {
        try
        {
            var receipt = await web3.Eth.Transactions.GetTransactionReceipt.SendRequestAsync(txHash);
            if (receipt != null)
            {
                Debug.Log($"Checking transaction {txHash} in block {receipt.BlockNumber}");

                var filter = randomEvent.CreateFilterInput(
                    new BlockParameter(receipt.BlockNumber),
                    new BlockParameter(receipt.BlockNumber)
                );

                var logs = await randomEvent.GetAllChangesAsync(filter);
                Debug.Log($"Found {logs.Count} events in transaction block");

                foreach (var log in logs)
                {
                    Debug.Log($"?? Event from specific tx: {log.Event.Result}");
                    VRFResultRouter.Instance.TriggerResult(log.Event.Result);
                }
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Error checking specific transaction: {e}");
        }
    }
}