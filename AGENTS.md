# AGENTS.md

## Project

Minecraft Bedrock Edition T-Rex Add-On, developed on macOS and tested on iOS.

Read `PLAN.md` before implementing milestone work.

Structure:
- `behavior_pack/` — gameplay and entity behavior
- `resource_pack/` — models, textures and animations
- `art/` — source artwork
- `dist/` — generated packages

## Bedrock Rules

- Target stable Minecraft Bedrock APIs supported on iOS.
- Do not introduce experimental features unless explicitly requested.
- Prefer entity JSON, filters, events, properties and component groups over Script API.
- Do not invent Bedrock components or APIs.
- Preserve existing entity state/component-group design unless the current task requires changing it.
- Preserve existing bone names when changing geometry or animations.
- Treat Bedrock/Molang/AI changes as unverified until tested on iOS.

## Compatibility

- Manifest format: `2`
- `min_engine_version`: `[1, 21, 0]`
- Behavior entity format: `"1.21.0"`

Do not change these unless the task specifically requires it.

## Existing Design Decisions

- Wild behavior: `jurassic:trex_wild`
- Tamed behavior: `jurassic:trex_tamed*`
- Sitting uses `jurassic:is_sitting` and custom interactions/component groups.
- Do not replace custom sitting with `minecraft:sittable`.
- Owner teleporting is intentionally disabled.
- Do not use `minecraft:behavior.delayed_attack` without isolated iOS testing.
- Do not add Script API unless declarative Bedrock features are insufficient.

## Changes

- Make the smallest change required for the current task.
- Do not work ahead into later milestones.
- Do not modify unrelated files.
- Keep explanations concise unless asked for detail.
- Preserve pack UUIDs unless explicitly instructed otherwise.
- Increment pack versions when required for an updated test build.

## Validation

Before packaging:
- Validate changed JSON.
- Verify Behavior Pack → Resource Pack dependency UUID/version.
- Exclude `.DS_Store`.
- Validate generated archives.

Use the existing packaging/validation scripts rather than reproducing commands manually.

## Documentation

- `PLAN.md` is the source of truth for milestone status, implementation details,
  known limitations and iOS verification.
- `README.md` contains installation and manual testing instructions.