// Scripts/VRF/SimpleRandomContract.cs
using Nethereum.Contracts;
using Nethereum.Hex.HexTypes;
using Nethereum.Web3;
using System.Numerics;
using System.Threading.Tasks;

public class SimpleRandomContract
{
    private Contract contract;
    private Web3 web3;

    public SimpleRandomContract()
    {
        web3 = Web3AuthIntegration.GetWeb3();
        contract = web3.Eth.GetContract(ContractConfigFunctions.Instance.contractABI, ContractConfig.CONTRACT_ADDRESS);
    }

    public async Task<string> RequestRandom(uint min, uint max)
    {
        var function = contract.GetFunction("requestRandom");
        var txn = await function.SendTransactionAsync(web3.TransactionManager.Account.Address, new HexBigInteger(300000), null, min, max);
        return txn;
    }

    public async Task<string> TestFulfillRandom(BigInteger requestId, BigInteger[] words)
    {
        var function = contract.GetFunction("testFulfillRandom");
        var txn = await function.SendTransactionAsync(web3.TransactionManager.Account.Address, new HexBigInteger(300000), null, requestId, words);
        return txn;
    }
}
