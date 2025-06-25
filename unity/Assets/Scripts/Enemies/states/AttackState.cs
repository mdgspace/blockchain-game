using System;
using UnityEngine;

public class AttackState : BaseEnemyState
{
    private float attackCooldown;
    private float attackTimer;
    private bool isAnimationTriggered = false;

    public AttackState(Enemy owner, StateMachine<Enemy> stateMachine)
        : base(owner, stateMachine) { }

    public override void Enter()
    {
        StopMoving();
        attackTimer = 100f;   
        attackCooldown = owner.AttackCooldown;
        isAnimationTriggered = false;
        //owner.animator.SetBool("isAttacking", true);
        owner.animator.SetBool("followPlayer", false);
        owner.animator.SetBool("freeRoam", false);
    }

    public override void Exit()
    {
        owner.animator.SetBool("isAttacking", false);
    }

    public override void LogicUpdate()
    {
        
        if (!owner.CanSeePlayer())
        {
            stateMachine.ChangeState(owner.FreeRoamingState);
            return;
        }

        float distanceToPlayer = Vector2.Distance(owner.transform.position, Player.position);
        if (distanceToPlayer > owner.AttackRange)
        {
            stateMachine.ChangeState(owner.FollowState);
            return;
        }
    }

    public override void PhysicsUpdate()
    {
        StopMoving();
        base.PhysicsUpdate();

        attackTimer += Time.fixedDeltaTime;
         Vector2 directionToPlayer = (Player.position - owner.transform.position).normalized;
        if (owner.IsFacingRight && directionToPlayer.x < 0 || !owner.IsFacingRight && directionToPlayer.x > 0)
        {
            owner.Flip();
        }

        if (attackTimer <= attackCooldown && attackTimer>owner.attackanimationtime) // Adjust the timing as needed
        {
            // Prepare the animation slightly before the attack executes
            owner.animator.SetBool("isAttacking", false);
            owner.animator.SetBool("followPlayer", false);
            owner.animator.SetBool("freeRoaming", false);
            isAnimationTriggered = true;
        }
        else if (attackTimer >= attackCooldown)
        {
            attackTimer = 0f;
            // Disable attack animation until next trigger
            owner.animator.SetBool("isAttacking", true);
            owner.animator.SetBool("freeRoaming", false);
            owner.animator.SetBool("followPlayer", false);
            isAnimationTriggered = false;
        }
    }
}

