using UnityEngine;
public class PlayerIdleState : PlayerState
{
    private Vector2 moveInput;

    public PlayerIdleState(Player player, StateMachine<Player> stateMachine)
        : base(player, stateMachine) { }

    public override void Enter()
    {   
        //Debug.Log("Player has entered idle state.");
        player.Animator.SetBool("walking", false);
        player.Animator.SetBool("walkingUp", false);
        player.Animator.SetBool("dashing", false);
        player.Enable_DisableInput(true);
        player.SetVelocity(Vector2.zero);
        Debug.Log("Player has entered idle state.");
    }

    public override void HandleInput()
    {   
        base.HandleInput();
        //Debug.Log("Player is idle, waiting for input...");
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
