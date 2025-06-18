using UnityEngine;
public class PlayerIdleState : PlayerState
{
    private Vector2 moveInput;

    public PlayerIdleState(Player player, StateMachine<Player> stateMachine)
        : base(player, stateMachine) { }

    public override void Enter()
    {   
        player.Enable_DisableInput(true);
        player.SetVelocity(Vector2.zero);
        player.PlayAnimation("Idle");   
    }

    public override void HandleInput()
    {   
        base.HandleInput();
        Debug.Log("Player is idle, waiting for input...");
        moveInput = InputManager.Instance.MoveDirection;

        if (moveInput != Vector2.zero)
        {
            stateMachine.ChangeState(player.moveState);
        }
        if (InputManager.Instance.DashPressed && player.canDash && player.currentEnergy >= player.dashEnergyCost)
        {
            stateMachine.ChangeState(player.dashState);
            return;
        }

    }
}
