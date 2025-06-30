using UnityEngine;

public class authHandlers : MonoBehaviour
{
    public void loginFunc()
    {
        Web3AuthManager.Instance.Login();
    }

    public void launchWalletFunc()
    {
        Web3AuthManager.Instance.LaunchWallet();
    }

    public void logoutFunc()
    {
        Web3AuthManager.Instance.Logout();
    }
}
