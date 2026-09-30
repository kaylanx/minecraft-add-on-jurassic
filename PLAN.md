# Jurassic T-Rex Add-On Plan

## Goal

Create a Minecraft Bedrock Edition Add-On containing a custom T-Rex that:

- Spawns naturally in suitable biomes.
- Behaves as a dangerous predator while wild.
- Can be tamed with meat.
- Follows and defends its owner after taming.
- Can be ridden and controlled after taming.
- Has substantial health and melee damage.
- Uses a custom model, texture, animations, sounds, and spawn egg.

The project targets Minecraft Bedrock on iOS. It uses Behavior Packs and Resource
Packs, with the Bedrock Script API reserved for features that cannot be implemented
cleanly through entity JSON.

## Architecture

### Behavior Pack

The Behavior Pack owns server-side gameplay:

- The `jurassic:trex` entity definition.
- Health, damage, movement, collision, and navigation.
- Wild and tamed component groups.
- AI goals and target selection.
- Taming and state-transition events.
- Riding and rider-control components.
- Natural spawn rules.
- Test functions.
- Optional JavaScript only if a later requirement needs it.

### Resource Pack

The Resource Pack owns client-side presentation:

- Client entity definition.
- Geometry and texture.
- Animations and animation controllers.
- Render configuration.
- Sounds.
- Entity and spawn-egg names.
- Spawn-egg appearance.

### Compatibility Decisions

- Keep Behavior and Resource Packs separate in source.
- Use manifest format version 2.
- Keep conservative `1.21.0` minimum engine and entity formats because these load
  successfully on the target iOS client.
- Include a module-level `description` in each manifest.
- Keep the Behavior Pack dependency UUID and version aligned with the Resource Pack
  header.
- Preserve pack header and module UUIDs across releases. Increment manifest versions
  when publishing an update; change UUIDs only when intentionally creating separate
  packs.
- Provide separate `.mcpack` files for troubleshooting and a combined `.mcaddon` for
  normal distribution. The `.mcaddon` must contain the completed `.mcpack` archives,
  not the raw Behavior Pack and Resource Pack folders.
- Use the repository validation and packaging scripts for release archives.
- Do not use `minecraft:spawn_egg_interaction` unless the entity also supports
  offspring. The Creative spawn egg only requires `is_spawnable` and the client
  entity's `spawn_egg` definition.

## Declarative And Scripted Features

The following features can be implemented in entity and resource JSON:

| Feature | Bedrock mechanism |
| --- | --- |
| Custom entity | Behavior entity and client entity definitions |
| Health and damage | `minecraft:health`, `minecraft:attack` |
| Wild predator AI | Target-selection and attack behavior goals |
| Taming with meat | `minecraft:tameable` and entity events |
| Owner storage | Built-in taming ownership |
| Follow owner | `minecraft:behavior.follow_owner` |
| Defend owner | Owner target behavior goals |
| Ride after taming | Tamed component group and `minecraft:rideable` |
| Rider movement | `minecraft:input_ground_controlled` |
| Natural spawning | Spawn-rule JSON |
| Model and texture | Geometry JSON and PNG texture |
| Animations | Animation JSON, controllers, and Molang |
| Sounds | Resource Pack sound definitions |
| Spawn egg | `is_spawnable` and client `spawn_egg` |

Script API should only be considered for:

- Strict owner-only mounting if vanilla tamed-mount behavior is insufficient.
- A rider-triggered bite or roar action.
- Custom stamina, cooldown, input, or HUD systems.
- Behavior that cannot be represented reliably with components, filters, and events.

## Project Structure

```text
jurassic-mod/
├── behavior_pack/
│   ├── manifest.json
│   ├── entities/
│   │   └── trex.json
│   ├── functions/
│   │   ├── trex_spawn.mcfunction
│   │   ├── trex_prey.mcfunction
│   │   ├── trex_run.mcfunction
│   │   └── trex_attack.mcfunction
│   ├── spawn_rules/
│   │   └── trex.json
│   ├── loot_tables/
│   │   └── entities/
│   │       └── trex.json
│   └── scripts/
│       └── main.js
├── resource_pack/
│   ├── manifest.json
│   ├── entity/
│   │   └── trex.entity.json
│   ├── models/entity/
│   │   └── trex.geo.json
│   ├── textures/entity/
│   │   └── trex.png
│   ├── animations/
│   │   └── trex.animation.json
│   ├── animation_controllers/
│   │   └── trex.animation_controllers.json
│   ├── render_controllers/
│   │   └── trex.render_controllers.json
│   ├── sounds.json
│   ├── sounds/
│   │   ├── sound_definitions.json
│   │   └── entity/trex/
│   └── texts/
│       ├── languages.json
│       └── en_US.lang
├── art/
│   └── trex_texture.svg
├── scripts/
│   ├── validate.sh
│   └── package.sh
├── dist/
├── PLAN.md
└── README.md
```

Folders and files are added only when their milestone needs them.

## Milestone 1: Minimum Valid Entity

**Status:** Complete and verified on iOS.

### Build

- Create valid Behavior and Resource Pack manifests.
- Register `jurassic:trex` as spawnable and summonable.
- Add basic physics, movement, navigation, collision, health, and wandering.
- Initially use vanilla geometry and texture as placeholders.
- Add localized entity and spawn-egg names.

### Files

- `behavior_pack/manifest.json`
- `behavior_pack/entities/trex.json`
- `resource_pack/manifest.json`
- `resource_pack/entity/trex.entity.json`
- `resource_pack/texts/languages.json`
- `resource_pack/texts/en_US.lang`

### Test

- Import both packs on iOS.
- Activate both in a new world with cheats.
- Run `/summon jurassic:trex`.
- Verify movement, collision, display name, spawn egg, saving, and reloading.
- Check the Content Log for pack or entity errors.

### Findings

- Minimal manifests without module descriptions produced a generic pack warning.
- Conservative format versions and complete manifest module entries resolved it.
- `minecraft:spawn_egg_interaction` was unnecessary and invalid without
  `minecraft:offspring`.

## Milestone 2: Model, Texture, And Animations

**Status:** Complete and verified on iOS.

### Build

- Replace placeholder visuals with custom T-Rex geometry.
- Add an original 128x128 texture.
- Add idle, walk, run, and bite animations.
- Add a Molang movement animation controller.
- Increase the collision box to match the custom model more closely.
- Add short test functions for mobile command entry.

### Files

- `resource_pack/models/entity/trex.geo.json`
- `resource_pack/textures/entity/trex.png`
- `resource_pack/animations/trex.animation.json`
- `resource_pack/animation_controllers/trex.animation_controllers.json`
- `resource_pack/entity/trex.entity.json`
- `behavior_pack/functions/*.mcfunction`
- `behavior_pack/entities/trex.json`

### Test

- Run `/function trex_spawn`.
- Verify model orientation, scale, pivots, UV mapping, and collision.
- Verify idle and walk animation transitions.
- Use `/function trex_run` and `/function trex_attack` to inspect clips directly.
- Check for foot sliding, clipping, abrupt blends, and camera culling.

### Limitations

- The visual model is much longer than its simple Bedrock collision box.
- Run and bite animations were initially manual until combat AI was added.

## Milestone 3: Wild Predator AI And Combat

**Status:** Compatible baseline verified on iOS; gameplay balancing remains.

### Build

- Add a replaceable `jurassic:trex_wild` component group.
- Target players and common livestock.
- Retaliate when attacked, except against other dinosaurs.
- Pursue targets at increased speed.
- Deal 14 melee damage with 100 health and 60% knockback resistance.
- Start with `minecraft:behavior.melee_attack` for broad compatibility. Delayed
  attack synchronization will be reintroduced only after the baseline combat pack
  is verified on the target iOS client.
- Add `/function trex_prey` for safe Creative-mode testing.

### Files

- `behavior_pack/entities/trex.json`
- `behavior_pack/functions/trex_prey.mcfunction`
- `resource_pack/entity/trex.entity.json`
- `resource_pack/animation_controllers/trex.animation_controllers.json`

### Test

- In Creative mode, run `/function trex_spawn` and `/function trex_prey`.
- Confirm target acquisition, pursuit, attack range, and damage.
- In Survival mode, verify player targeting and practical damage.
- Attack the T-Rex and verify retaliation.
- Spawn two T-Rexes and verify they do not target each other by default.
- Test around trees, slopes, water, fences, and narrow gaps.

### Uncertainty

- Attack reach may need adjustment to match the model's long head.
- The large entity may struggle with pathfinding in forests and confined terrain.
- Target families may require refinement as more mobs are tested.

### Compatibility Finding

The initial Milestone 3 build used `minecraft:behavior.delayed_attack` together
with a client animation controller driven by `query.is_delayed_attacking`. On the
target iOS client, that pair caused the generic pack-loading warning without a
useful Content Log error. Reverting to `minecraft:behavior.melee_attack` and the
verified Milestone 2 resource controllers removed the warning. Keep standard melee
combat until delayed-attack support can be isolated and tested independently.

## Milestone 4: Taming And Owner Behavior

**Status:** Complete and verified on iOS through Milestone 4.3, including
two-player ownership and following.

### Build

- Add `minecraft:tameable` to the wild group.
- Accept one or more raw meat items with a tunable success probability.
- Add a tame event that removes the wild group and adds a tamed group.
- Add `minecraft:is_tamed`.
- Stop targeting players and livestock after taming.
- Follow the owner.
- Defend the owner and assist with the owner's targets.
- Allow meat to heal a tamed T-Rex.
- When the player crouches and clicks on a tamed T-Rex, it should sit down.

### Components

- `minecraft:tameable`
- `minecraft:is_tamed`
- `minecraft:healable`
- Synchronized `jurassic:is_sitting` entity property
- Owner- and crouch-filtered `minecraft:interact`
- `minecraft:behavior.follow_owner`
- `minecraft:behavior.owner_hurt_by_target`
- `minecraft:behavior.owner_hurt_target`
- Entity events and component-group add/remove operations

### Files

- Update `behavior_pack/entities/trex.json`.
- Optionally update client resources to distinguish wild and tamed states.
- Add mobile test functions if needed.

### Test

- Tame using the configured meat.
- Verify item consumption and tame probability.
- Confirm wild targeting stops immediately after taming.
- Confirm it can sit when tamed.
- Walk away and verify following behavior.
- Save and reload to verify owner persistence.
- Verify defense when the owner is attacked.
- Verify assistance when the owner attacks another mob.
- Test with two players to confirm correct ownership.

### Uncertainty

- AI priorities must prevent following, combat, and wandering from fighting each
  other.

### Implementation Notes

- Raw beef, porkchops, chicken, mutton, and rabbit tame with a 25% chance per item.
- Those raw meats restore between 6 and 10 health after taming.
- Owner defense and sitting have higher priorities than following and wandering.
- Owner teleporting is disabled to avoid visibly moving the large model through
  terrain.
- Native `minecraft:sittable` exposes its prompt even when the owner is not
  crouching. Milestone 4.1 instead uses a persistent custom property and filtered
  empty-hand interactions so Sit/Stand is offered only while the owner crouches.
- Sitting swaps out active movement and combat goals and drives a dedicated client
  animation through the synchronized property.

### Milestone 4.2 Sitting Pose

- Preserve the existing `left_leg` and `right_leg` bones while moving each foot into
  a new child bone.
- Lower the hips and tail while raising the chest and head.
- Fold the legs forward and counter-rotate the articulated feet so they remain
  planted instead of making the whole model appear to crouch.
- Verify the seated silhouette, foot placement, ground clipping, transitions, and
  normal idle, walk, and run animations on iOS.

### Milestone 4.3 Movement Restoration

- Milestone 4.2 set `minecraft:movement` to `0.0` in the sitting component group.
  On iOS, removing that group did not reliably restore movement, leaving the T-Rex
  unable to wander or follow after standing.
- Sitting now stops locomotion solely by removing the active movement-producing AI
  goals.
- Wild and active-tamed groups explicitly apply movement speed `0.25`, ensuring that
  the stand event recomposes both movement speed and owner behavior.
- Repeatedly sit and stand, then verify wandering, following, and owner defense.

### Verification

- Taming, healing, crouch-gated Sit/Stand interactions, and the articulated sitting
  pose are verified on iOS.
- Movement, wandering, following, and owner defense resume after repeated Sit/Stand
  cycles.
- Two-player testing confirmed that ownership, following, Sit/Stand control, owner
  defense, and owner attack assistance remain assigned to the correct player.
- Ownership and sitting state persist after saving and reopening the world.

## Milestone 5: Riding And Player Control

**Status:** Planned.

### Build

- Make only the tamed state rideable.
- Add one player seat and tune its model-relative position.
- Add ground input control.
- Add player-riding behavior for a tamed mount.
- Improve step height for a large ground entity.
- Tune third-person camera distance where supported.

### Components

- `minecraft:rideable`
- `minecraft:input_ground_controlled`
- `minecraft:behavior.player_ride_tamed`
- `minecraft:variable_max_auto_step`
- Optional rider-enter and rider-exit events

### Files

- Update `behavior_pack/entities/trex.json`.
- Update client animation logic for mounted movement if necessary.

### Test

- Confirm wild T-Rexes cannot be mounted.
- Tame, mount, steer, stop, and dismount.
- Test touch controls on iOS.
- Test slopes, steps, water, low ceilings, and collision.
- Tune rider position and camera distance.
- Test mounting with two players.
- Verify unmounted combat still works after riding is added.

### Limitations

- `minecraft:rideable.family_types` allows players by family and does not clearly
  enforce owner-only mounting.
- Strict owner-only riding may require Script API interaction handling.
- Standard riding does not provide a custom bite button.
- A rider-triggered attack may require scripting or a custom item interaction.

## Milestone 6: Sounds, Natural Spawning, Balance, And Polish

**Status:** Planned.

### Build

- Add ambient, hurt, death, attack, and footstep sounds.
- Add rare natural spawning in selected biomes.
- Tune health, damage, speed, detection range, attack reach, and spawn frequency.
- Finalize spawn-egg appearance.
- Optionally add a loot table and visual variants.
- Package a clean release `.mcaddon`.

### Components And Resources

- `minecraft:spawn_rules`
- `minecraft:spawns_on_surface`
- `minecraft:spawns_on_block_filter`
- `minecraft:brightness_filter`
- `minecraft:weight`
- `minecraft:herd`
- `minecraft:biome_filter`
- `sounds.json`
- `sounds/sound_definitions.json`
- Licensed `.ogg` sound files

### Files

- `behavior_pack/spawn_rules/trex.json`
- Optional `behavior_pack/loot_tables/entities/trex.json`
- `resource_pack/sounds.json`
- `resource_pack/sounds/sound_definitions.json`
- `resource_pack/sounds/entity/trex/*.ogg`
- Optional custom spawn-egg texture files

### Test

- Test every sound directly and during gameplay.
- Explore newly generated chunks in eligible and ineligible biomes.
- Verify spawn rarity and herd size.
- Confirm T-Rexes do not overwhelm animal or monster population pools.
- Run extended Survival tests for balance and unintended griefing.
- Re-test taming, owner defense, riding, saving, and multiplayer ownership.

### Uncertainty

- Spawn weight is relative to other entities and not a direct probability.
- Biome tags can be broader than exact biome identifiers.
- Audio must be properly licensed and exported in a supported format.

## Known Bedrock Limitations

1. Entity collision is a simple box and cannot match the snout and tail.
2. Large-mob navigation is unreliable in narrow or heavily wooded terrain.
3. Owner-only mounting is not represented cleanly by the rideable family filter.
4. Ground riding does not automatically provide a custom attack control.
5. Client animation and server damage are separate systems; delayed attack behavior
   is used to synchronize them as closely as possible.
6. Natural spawning depends on population pools, nearby entities, valid surfaces,
   biome tags, and difficulty.
7. Format versions affect schema validation. Newer versions may reject shorthand
   accepted by older files.
8. A spawn egg configured on the client entity is not a separate custom item.

## Official References

- [Creating New Entity Types](https://learn.microsoft.com/en-us/minecraft/creator/documents/introductiontoaddentity)
- [Entity Modeling and Animation](https://learn.microsoft.com/en-us/minecraft/creator/documents/entitymodelingandanimation)
- [Behavior Packs](https://learn.microsoft.com/en-us/minecraft/creator/documents/behaviorpack)
- [Resource Packs](https://learn.microsoft.com/en-us/minecraft/creator/documents/resourcepack)
- [`minecraft:tameable`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitycomponents/minecraftcomponent_tameable)
- [`minecraft:rideable`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitycomponents/minecraftcomponent_rideable)
- [`minecraft:input_ground_controlled`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitycomponents/minecraftcomponent_input_ground_controlled)
- [`minecraft:behavior.player_ride_tamed`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitygoals/minecraftbehavior_player_ride_tamed)
- [`minecraft:behavior.follow_owner`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitygoals/minecraftbehavior_follow_owner)
- [`minecraft:behavior.delayed_attack`](https://learn.microsoft.com/en-us/minecraft/creator/reference/content/entityreference/examples/entitygoals/minecraftbehavior_delayed_attack)
- [Custom Sounds](https://learn.microsoft.com/en-us/minecraft/creator/documents/addcustomsounds)
- [Official Bedrock Samples](https://github.com/Mojang/bedrock-samples)
- [Official Wolf Definition](https://github.com/Mojang/bedrock-samples/blob/main/behavior_pack/entities/wolf.json)
- [Official Horse Definition](https://github.com/Mojang/bedrock-samples/blob/main/behavior_pack/entities/horse.json)
- [Official Camel Definition](https://github.com/Mojang/bedrock-samples/blob/main/behavior_pack/entities/camel.json)
- [Official Ravager Definition](https://github.com/Mojang/bedrock-samples/blob/main/behavior_pack/entities/ravager.json)
