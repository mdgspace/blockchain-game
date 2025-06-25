using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class ProjectileData
{
    public enum ProjectilePath { Straight, ZigZag, Random, Arc, Homing, Circular }
    [Header("Staggered Launching")]
    public float delayBetweenProjectiles = 0f;

    [Header("Spawn Position Offsets")]
    public List<Vector2> spawnOffsets = new List<Vector2>();
    public float staggeredLaunchAngle = 0f; // Angle offset for staggered launches, in degrees
    [Header("Projectile Settings")]
    public int numberOfProjectiles = 1;
    public float destroyTime = 3.5f;
    public float projectileSpeed = 15f;
    public int damage = 25;
    public List<Vector2> directions = new List<Vector2> { Vector2.right }; // default forward
    public ProjectilePath movementPath = ProjectilePath.Straight;
}