# Quantum State Persistence — isolated greybox validation

**Status:** technical prototype implemented; unbriefed human readability **UNVALIDATED**. This tests the narrow K6 continuity contract in [Knowledge Architecture V2](PROJECT_LUMEN_KNOWLEDGE_ARCHITECTURE_V2.md) and [Quantum State Persistence Validation](PROJECT_LUMEN_QUANTUM_STATE_PERSISTENCE_VALIDATION.md). It does not add snapshot recall, a new global law, or final-facility content.

## Fixture and intended observation

Open `res://scenes/tests/state_persistence_probe.tscn` directly. F5 and the existing world progression are unchanged. The isolated fixture has one repaired service module, two fixed receiver beds (A left, B right), one reversible lever physically mounted on the module, a fixed contact and lamp at A, and a central sightline cover. There are no documents, mechanic labels, objective markers, or explanatory UI. The existing player, E interaction ray, and direct-visibility observation query are reused without modifying those systems.

The player initially sees the repaired module at A, its lever in the ON position, and A's lit lamp. Holding the module in view prevents movement. Looking away long enough while both current module and candidate are unobserved permits one move to B. The repair, lever, and rear contact prongs move with the module; A's contact, conduit, and lamp remain fixed. B has no lamp connection. To repeat a move, the player must see the module again, then release observation. The player cannot command a destination: the two-position fixture simply alternates when the other position is eligible.

| Comparison | Module location | Attached lever | Fixed A lamp | Meaning |
| --- | --- | --- | --- | --- |
| Initial | A | ON | Lit | A contact is connected to the present module. |
| First unseen move | B | ON | Dark | Identity and attached condition traveled; A's output did not. |
| Player changes lever at B | B | OFF | Dark | An ordinary action changed the current object. |
| Return after reobservation and release | A | OFF | Dark | The old location returned, **not** its earlier ON snapshot. |
| Player changes lever at A | A | ON | Lit | The same fixed contact responds to the current attached condition. |

The fourth row is the explicit counterexample to “A recalls how the object used to be.” A location-only return is insufficient evidence of persistence. The causal prediction is that the object's latest lever condition remains, while the fixed connection at A only produces light if the module is present and ON.

## Player experiment and competing readings

Let an unbriefed player inspect the repaired module and both beds before suggesting any interpretation. Ask neutrally at B, before the second release: “If this appears at the other place, what do you expect the lever and the lamp to look like? Why?” Record the prediction verbatim. Allow the player to change the lever, reobserve the module, hide it, and inspect A. A second prediction after changing the lever is more useful than a retrospective explanation.

Possible wrong readings are ordinary timer cycling, two copied modules, B turning the machine off, A storing an old ON setting, or time rewind. The watched hold discriminates observation from a timer; the integrated repair and same physical lever discriminate copies; the lever remains ON at B even though A's lamp is dark; and the B-OFF → A-OFF return directly falsifies old-state restoration. No event rewinds the fixed world. A player may still describe the two-place movement as “teleportation”; this fixture is not intended to validate large-scale spatial identity or destination-selection logic.

## Technical acceptance and results

Run:

```text
godot --headless --path . --editor --quit
godot --headless --path . --quit-after 120 res://scenes/tests/state_persistence_probe.tscn
godot --headless --path . --script res://tests/world/state_persistence_validation.gd
```

The automated test checks initial A/ON/lit state; observed hold; one unseen A→B move; module instance and repair continuity; attached ON retention at B; fixed A lamp going dark; rearm requirement; normal interaction-ray lever adjustment at B; B/OFF→A/OFF with the old A lamp still dark; fixed receiver and contact transforms; and relighting only after an ordinary lever adjustment at A. It also verifies the moving module is not replaced by a new instance. Current result: **pass** on Godot 4.7.2 headless. The direct scene launch and editor/import check load without script or scene errors. Local sandbox warnings about `user://` logs, telemetry log writing, root certificates, or editor settings are environment-related, not prototype test failures.

The implementation uses the existing direct-visibility query and guards against moving onto either occupied bed or into a directly observed candidate. It is deliberately scene-local. It does not change `ObservationManager`, `QuantumRelocator`, the existing Cube, Awakening, M/N exchange, or other prototype scenes.

## Remaining human-readability gate

No unbriefed player session has occurred; **do not claim the K6 Eureka is proven**. Observe whether players naturally notice (1) the repair as identity evidence, (2) the lever as attached to the moving object, (3) A's contacts and lamp as fixed, and (4) the distinction between lamp output and lever condition at B. Check whether they can predict A/OFF before the return rather than explaining it afterward. If the contact relationship is visually missed, adjust only its physical readability; do not add a “state saved” message or a new recall mechanic. Also verify in a rendered/manual session that looking away and back feels controllable and the broad cover does not demand an exact camera angle.
