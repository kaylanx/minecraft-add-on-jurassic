# Jurassic T-Rex Add-On

Milestone 5 makes a standing, tamed T-Rex rideable and controllable while retaining
the taming, owner behavior, and custom sitting introduced in Milestone 4.

## Install On iOS

1. Transfer `dist/jurassic_trex_milestone_5.mcaddon` to the iOS device.
2. In the Files app, open the file with Minecraft.
3. Wait for Minecraft to report that both packs imported successfully. Separate
   Milestone 5 `.mcpack` files are also provided if troubleshooting is needed.
4. Create a new world with cheats enabled.
5. Activate **Jurassic T-Rex Behavior Pack (Milestone 5)** under Behavior Packs.
6. Verify **Jurassic T-Rex Resource Pack (Milestone 5)** is active.
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
- It pursues targets and attacks when it reaches melee range.
- Its melee attack deals 14 damage.
- It retaliates when attacked.
- Its 100 health and 60% knockback resistance make it difficult to fight.
- Raw beef, porkchops, chicken, mutton, and rabbit each have a 25% chance to tame it.
- Taming immediately stops wild player and livestock targeting.
- A tamed T-Rex follows its owner but does not teleport across long distances.
- It attacks mobs that hurt its owner and mobs attacked by its owner.
- The same raw meats heal a tamed T-Rex when it is injured.
- With an empty hand, crouching and interacting commands a tamed T-Rex to sit or
  stand. The Sit/Stand button is hidden while the owner is not crouching.
- Sitting lowers the hips, raises the chest, folds the legs, plants the articulated
  feet, and rests the tail behind the body.
- Sitting prevents following, combat, and wandering until it is told to stand.
- After standing, it resumes wandering and follows its owner again. Repeat the
  sit/stand cycle several times to verify movement is restored every time.
- A wild T-Rex cannot be mounted.
- A standing, tamed T-Rex offers the Ride action. Mount it, use touch movement to
  steer and stop, then dismount.
- A sitting T-Rex does not offer the Ride action. Stand it before mounting.
- The rider sits above the hips without obvious model clipping, and third-person
  visibility remains usable with the standard camera distance.
- While ridden, it can climb full blocks and reasonable slopes without jumping.
- After dismounting, following, owner defense, wandering, and melee combat still work.
- With two players, only one rider can mount at a time. The current declarative family
  filter does not guarantee owner-only mounting, so verify and record non-owner behavior.
- Ownership and sitting state persist after saving and reopening the world.
- It has the name `T-Rex` in command output and death messages.
- A green and dark spawn egg named `Spawn T-Rex` is available in Creative mode.
- Saving and reopening the world preserves the entity.

The equivalent full animation commands are:

```text
/playanimation @e[type=jurassic:trex,c=1] animation.trex.run
/playanimation @e[type=jurassic:trex,c=1] animation.trex.attack
```

For a safe taming test, stay in Creative mode, run `trex_spawn`, hold one of the raw
meats listed above, and interact until hearts appear. Switch to Survival only when
testing wild player targeting or owner-defense behavior.

If importing or spawning fails, enable the Content Log in Minecraft settings and
check it for malformed JSON, missing dependencies, or missing client resources.

## Build

Validate the source packs without creating archives:

```sh
./scripts/validate.sh
```

Create and validate both `.mcpack` files and the combined `.mcaddon`:

```sh
./scripts/package.sh milestone_5
```

The release name controls the generated filenames in `dist/`. Packaging preserves
the UUIDs in the manifests; increment manifest versions when preparing an update.
