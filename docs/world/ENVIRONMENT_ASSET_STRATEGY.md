# Reusable Environment Asset Strategy

## Greybox kit

The first world space uses a deliberately small modular kit under `scenes/world/environment/greybox/`:

- `facility_block.tscn`: a scalable structural unit with matching collision.
- `facility_door_frame.tscn`: a standard human-scale bulkhead opening assembled from structural units.
- `dead_console.tscn`: an unpowered workstation prop.
- `equipment_crate.tscn`: repeatable storage and obstruction dressing.
- `emergency_light.tscn`: a fixture with a restrained local light source.
- `inspection_camera.tscn`: passive, unpowered inspection equipment; it has no observation or stabilization behavior.
- `service_control.tscn`: a physical rotary handle using the existing interaction contract and emitting a local activation signal.
- `research_workbench.tscn`: a reusable drawer bench with collision, used in observation, maintenance, and facility control workspaces.

Rooms assemble these scenes on a consistent 0.25 m / 0.5 m grid. Structural collision remains inside reusable scenes so later visual replacements do not require puzzle scripts to change.

## Replacement boundaries

The environment is divided into layers:

1. **Shell:** floor, walls, ceiling, door openings, and major occluders.
2. **Facility modules:** frames, consoles, racks, lights, conduits, and reusable storage.
3. **Story dressing:** damaged or displaced instances that describe an incident without text.
4. **Gameplay objects:** existing reusable scenes such as Player, Quantum Cube, QuantumDoor, and Stabilization Beam.
5. **Lighting:** local fixtures and limited area lighting that clarify function and traversal.

Art production can replace a module's mesh and material inside its own scene while retaining its root transform and collision contract. Gameplay scenes should instance modules instead of baking one-off meshes whenever repetition makes physical sense.

## Visual language

- Base materials are desaturated metal, painted composite, and worn utility surfaces.
- Emissive color is reserved for real powered state or a diegetic light source; it is not a hidden tutorial marker.
- Occluders must look like functional equipment, storage, damage, or architecture.
- Environmental evidence uses three layers: what the room was for, what went wrong, and what has changed since.
- Unique hero assets should be delayed until a repeated module cannot carry the intended story.

The prototype's highly legible teaching colors remain useful in its regression scenes, but they are not automatically carried into the exploration world.

TASK-028 adds shared painted-alloy, floor-composite, and wall-finish materials under `scenes/world/environment/materials/`. These use subtle native material variation without new gameplay scripts or bitmap dependencies. `awakening_workspaces.tscn` composes repeated workbenches, equipment, and human traces within the existing chamber; see [the humanization pass](AWAKENING_HUMANIZATION.md).

The Awakening development pass groups room-specific incident evidence in `awakening_dressing.tscn`. Recorder equipment, displaced maintenance covers, gurney dressing, a broken duct, and bulkhead damage serve recognizable facility functions. Floor joints use a consistent structural grid; no repeated destination-pad graphics are used. The local restoration animation instances instrument materials so it cannot recolor shared prototype resources.
