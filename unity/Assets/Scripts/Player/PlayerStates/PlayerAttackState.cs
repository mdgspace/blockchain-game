
using UnityEngine;

public class PlayerAttackState : PlayerState
{
    
    private bool attackComplete = false;

    public PlayerAttackState(Player player, StateMachine<Player> stateMachine)
        : base(player, stateMachine) { }

    public override void Enter()
    {
        attackComplete = false;
        player.Animator.SetBool("attacking", true);
        player.Animator.SetBool("walking", false);
        player.Animator.SetBool("walkingUp", false);
        player.Animator.SetBool("walkingDown", false);
        player.Animator.SetBool("dashing", false);

        player.EnableHitboxDef(false); // Ensure it's off before starting
    }

    public override void LogicUpdate()
    {
        if (attackComplete)
        {
            if (InputManager.Instance.MoveDirection != Vector2.zero)
                stateMachine.ChangeState(player.moveState);
            else
                stateMachine.ChangeState(player.idleState);
        }
    }

    public void OnAttackAnimationComplete() => attackComplete = true;

    public override void Exit()
    {
        player.Animator.SetBool("attacking", false);
        player.EnableHitboxDef(false);
        player.ClearHitEnemies();
    }
}
