# Jurassic T-Rex Add-On

Milestone 3 adds wild predator AI and synchronized melee combat to the custom
T-Rex model and animations from Milestone 2.

## Install On iOS

1. Transfer `dist/jurassic_trex_milestone_3.mcaddon` to the iOS device.
2. In the Files app, open the file with Minecraft.
3. Wait for Minecraft to report that both packs imported successfully. Separate
   Milestone 3 `.mcpack` files are also provided if troubleshooting is needed.
4. Create a new world with cheats enabled.
5. Activate **Jurassic T-Rex Behavior Pack (Milestone 3)** under Behavior Packs.
6. Activate **Jurassic T-Rex Resource Pack (Milestone 3)** under Resource Packs.
7. Deactivate earlier Jurassic packs because they use the same entity identifier.

## Test

Use the short test functions:

```text
/function trex_spawn
/function trex_prey
/function trex_run
/function trex_attack
```

Verify that:

- The entity appears with the custom green T-Rex model and texture.
- It wanders, looks at nearby players, collides with blocks, and falls normally.
- It idles when stationary and walks using alternating leg and tail movement.
- In Survival, it targets players within range.
- It hunts nearby cows, pigs, sheep, chickens, and horses in any game mode.
- It runs while pursuing a target and bites when it reaches attack range.
- The bite deals 14 damage and lands during the closing-jaw animation.
- It retaliates when attacked, except against other dinosaurs.
- Its 100 health and 60% knockback resistance make it difficult to fight.
- It has the name `T-Rex` in command output and death messages.
- A green and dark spawn egg named `Spawn T-Rex` is available in Creative mode.
- Saving and reopening the world preserves the entity.

The equivalent full animation commands are:

```text
/playanimation @e[type=jurassic:trex,c=1] animation.trex.run
/playanimation @e[type=jurassic:trex,c=1] animation.trex.attack
```

For a safe visual test, stay in Creative mode, run `trex_spawn`, then run
`trex_prey`. Switch to Survival only when testing player targeting.

If importing or spawning fails, enable the Content Log in Minecraft settings and
check it for malformed JSON, missing dependencies, or missing client resources.
