# Central Hub Foundation — TASK-030

## Playable boundary

F5 still launches Awakening. Its existing observation experiment and physical service handle lead into a continuously loaded Operations Atrium. The same restoration signal lifts the existing bulkhead after a brief motor startup and raises three circulation lights and their fixture faces. No extra interaction, knowledge flag, UI, transition, or puzzle rule is introduced. Returning to the chamber remains possible.

The atrium is a 24 m by 20 m hall with a 7 m ceiling. A 4 m vestibule preserves the chamber's intimate scale before the taller space opens around the player. The floor remains level. Wing names are development vocabulary only; no labels appear in the world.

## Layout and purpose

Coordinates below are local to `operations_atrium.tscn`; its root is at world `(0, 0, 6)`.

| Place | Local position | Environmental purpose |
| --- | --- | --- |
| Awakening connection | `(0, 0, 0)` | Existing bulkhead and short service vestibule; readable return route |
| Circulation plant | `(0, 0, 15)` | Large manifold, risers, analogue gauges and overhead pipework; central landmark with room to circle |
| Records approach | `(-12, 0, 10)`, facing west | Security grille with archive cabinets visible beyond; nearby operations desk implies records coordination |
| Power approach | `(12, 0, 10)`, facing east | Shielded gate, service track and paired exchanger vessels; reserve lighting remains warm |
| Containment approach | `(-6, 0, 24)` | Reinforced gate and a visible transfer cradle, suggesting heavier controlled equipment |
| Signal approach | `(6, 0, 24)` | Cable trunk and receiver racks behind a grille, suggesting remote instrumentation |
| Operations desk | west rear of hall | Dormant consoles, relay board and seat; facility coordination has stopped |
| Maintenance pocket | east rear of hall | Workbench, tool, cloth, removed cover and exposed relays; repair was interrupted |

The plant splits traversal into two connected routes. Side approaches become visible as the player clears the vestibule; the rear approaches invite walking around the machinery. An interrupted suspended cable tray connects the hall's damage to its infrastructure. Only a subset of services returns; dead consoles, unrepaired equipment and sealed wings retain the abandoned state.

## Composition and preservation

- Static scene geometry remains visible and editable in Godot; no runtime layout generator.
- Shared floor, wall and painted-alloy materials, consoles and workbench assets are reused unchanged.
- `sealed_wing_approach.tscn` contains floors, enclosure and a collision-backed gate. The four approaches end at visible physical seals; they contain no interaction scripts.
- `hub_restoration.gd` listens to the existing service control. Door trim is reparented while preserving its world transform so it travels with the bulkhead. The door's collision stays attached throughout motion.
- The Awakening scene only gains a hub instance and connection paths. Its chamber/restoration scripts, Cube destinations, observation manager, relocation rules and feedback remain intact.
- Prototype scenes, global systems, project main-scene configuration and interaction contracts are preserved.

## Validation and human questions

Run `godot --headless --path . --script res://tests/world/awakening_chamber_validation.gd`. This retains the opening regression and adds pre-restoration confinement, post-restoration access, circulation lighting, door trim, the complete hub loop with return, floor sampling, and four sealed wing approaches.

TASK-030 verification passed in Godot 4.7.2: the extended regression, main-scene launch and headless editor/import check completed successfully. Rendered 1280x720 views covered the opening, lifted bulkhead, atrium arrival, all four approaches and the return sightline. All 49 protected observation/interaction/prototype/configuration and opening-controller files matched their task-start hashes. Temporary capture files were removed. Sandbox runs reported external log/telemetry/settings and certificate-store access warnings; the rendered run reported no project errors. These checks establish access and presentation, not first-player comprehension or measured exploration duration.

For human playtesting, provide movement, mouse-look, E and Escape controls only. Observe whether the player notices the opening door, experiences the change in scale, explores both sides of the plant, infers different wing functions from equipment, and finds the return route without guidance. Ask what they think the facility did and which route they would investigate next. The four seals are the current content boundary; do not imply additional solutions are implemented.
