# Prototype-to-World Migration Plan

## Preserve the testbed

Everything under `scenes/prototype/` remains available as a mechanism and regression testbed. The completed vertical-slice progression is not deleted, folded into the new world, or treated as final geography.

The new exploration layer lives under `scenes/world/`. This separation lets world spaces reuse stable mechanics without inheriting tutorial sequencing, solution-revealing labels, or room-specific controllers.

## Reuse unchanged

The opening chamber directly instances the existing:

- Player and interaction ray.
- ObservationManager.
- Quantum Cube and QuantumRelocator behavior.

Later world spaces may instance the existing Stabilization Beam and QuantumDoor. Their global semantics should remain unchanged. World-specific behavior belongs in local composition or focused controllers, not in branches added to the stable mechanism scripts.

## Do not migrate

- The prototype's linear `GameFlow` stage ordering.
- Room-title presentation or mechanic names.
- Completion overlays and solution-facing notifications.
- Teaching-room policies created for a single forced demonstration.
- Prototype-only controllers such as the Combined teaching/recovery sequence.

These remain valid inside the prototype testbed. The world will eventually need navigation and restoration state appropriate to a connected place, but that system is deliberately not designed or implemented in this milestone.

## Phases

1. **Opening chamber greybox:** validate density, curiosity, relocation discovery, and the absence of explicit instruction.
2. **Hub shell:** establish scale, landmarks, blocked routes, and a believable connection from the incident chamber.
3. **Area slices:** build one explorable slice per functional area, each containing evidence and cross-area questions rather than tutorial gates.
4. **Systemic integration:** introduce existing Beam and QuantumDoor scenes only where their established behavior serves the world.
5. **Presentation pass:** replace greybox modules, add authored environmental evidence, and integrate audio after external observation of player behavior.

At every phase, the prototype scenes remain launchable for behavioral regression checks.
