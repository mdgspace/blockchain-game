// Scripts/VRF/VRFResultRouter.cs
using System;
using UnityEngine;

public class VRFResultRouter : MonoBehaviour
{
    public static VRFResultRouter Instance;

    public event Action<uint> OnVRFResult;

    private void Awake()
    {
        if (Instance == null) Instance = this;
        else Destroy(gameObject);
    }

    public void TriggerResult(uint exp)
    {
        OnVRFResult?.Invoke(exp);
    }
}
