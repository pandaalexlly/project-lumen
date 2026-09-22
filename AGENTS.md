# AGENTS.md

## Project

Project Lumen is a first-person 3D knowledge-based exploration game
built with Godot 4.7.2 and GDScript.

The current goal is a small playable prototype, not a production-ready game.

## Core Design Principle

Knowledge is progression.

The player should unlock possibilities primarily by understanding stable
world rules rather than by obtaining upgrades, keys, levels, or stats.

Do not introduce conventional progression systems unless explicitly requested.

## Engineering Principles

- Use Godot 4.7.2 APIs.
- Use GDScript unless explicitly instructed otherwise.
- Prefer simple, readable implementations over clever abstractions.
- Keep gameplay logic modular.
- Do not hard-code unrelated gameplay systems together.
- Prefer composition where appropriate.
- Avoid unnecessary dependencies or plugins.
- Do not introduce new systems outside the requested task.
- Do not perform large refactors unless explicitly requested.

## Project Structure

- scenes/: Godot scenes.
- scripts/player/: player controller code.
- scripts/interaction/: interaction system.
- scripts/observation/: observation-related gameplay systems.
- scripts/core/: only genuinely global systems.
- assets/placeholders/: temporary prototype assets.
- docs/: design and architecture documentation.

## Prototype Scope

The current prototype focuses only on:

1. First-person exploration.
2. Object interaction.
3. Detecting direct visual observation.
4. Objects whose state changes while unobserved.

Do not add:

- combat
- inventory
- quests
- dialogue systems
- save systems
- procedural generation
- multiplayer
- production UI

unless explicitly requested.

## Code Style

- Use snake_case for variables and functions.
- Use PascalCase for class_name declarations.
- Use typed GDScript where practical.
- Use exported variables for designer-tunable gameplay values.
- Avoid magic numbers when the value represents gameplay tuning.
- Keep scripts focused on one responsibility.
- Add comments only when they explain intent or non-obvious behavior.

## Validation

After modifying the project:

- Check for GDScript parser errors.
- Check for missing node paths or broken scene references.
- Run the relevant scene if possible.
- Report exactly what was changed.
- Report any behavior that still requires manual testing.

## Task Discipline

For each task:

1. Read the existing relevant files first.
2. Implement only the requested scope.
3. Do not silently redesign existing architecture.
4. Validate the implementation.
5. Summarize changed files and remaining risks.