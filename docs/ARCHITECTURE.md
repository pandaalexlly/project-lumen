# Initial Architecture

- `PlayerController`: Handles first-person movement and view control.
- `InteractionComponent`: Provides focused, reusable object interaction behavior.
- `ObservationManager`: Performs stateless direct-observation queries.
- `ArtificialObservationSource`: Registers a lightweight non-camera observation source.
- `StabilizationBeam`: Implements a box-volume artificial source with world occlusion.
- `ObservableObject`: Owns effective observation state and transitions.
- `QuantumRelocator`: Owns shared observation-driven relocation behavior.
- `QuantumCube` and `QuantumDoor`: Thin `QuantumRelocator` specializations.
- `ApplicationQuantumCube`: Adds the Application room's bounded-random policy.
- `PrototypeSessionController`: Owns restart, fall recovery, and completion state.

The explicitly assigned primary `Camera3D` is the only authority for direct
player observation. Direct observation requires both frustum visibility and
unobstructed physics line of sight; artificial sources do not impersonate that
camera. Artificial sources register through a scene-tree group and answer
geometric probe queries. Each query distinguishes a current target whose own
collider may confirm observation from an ignored current-world root that is
absent from a hypothetical state. `ObservableObject` combines direct player
and artificial observation with OR semantics, then emits `observation_started`
and `observation_ended` only when that single effective state changes. With no
artificial source in a scene, existing behavior is unchanged.

`QuantumRelocator` uses `ObservableObject` transitions to schedule movement.
An observed-to-unobserved transition starts a cancellable
delay; if it expires while the object remains unobserved, it randomly selects
from currently safe, eligible fixed external destination markers.
Its prototype Observation Envelope samples both the object body and its
approximate shadow footprint, includes a camera-edge guard
band, and defines observation for both its current state and candidate
destination state. The same body and shadow probes are offered to registered
artificial sources. A destination is unsafe if either the player camera can see
it or any enabled artificial source covers it, and it must remain safely hidden
for a short grace period. The object moves at most once during each uninterrupted
unobserved period.

The provisional `StabilizationBeam` checks probes against a directional
rectangular volume and raycasts from its emitter to each covered probe. Solid
physics bodies block the path; a hit on the current target's own collider still
counts as observation. Candidate queries model the relocator after it has left
its current position by excluding every `CollisionObject3D` RID under that
relocator, while unrelated walls remain occluders. Beam power changes feed the
ordinary effective-state transition, so they use the shared release and
cancellation behavior without a beam-specific timer.

The Beam's graybox volume uses its configured range as a maximum and shortens
to the first ordinary collider on its central ray. Quantum relocators are
skipped by this visual-only query so receiving the field does not make its
projection flicker or appear blocked; ordinary world geometry still truncates
the visible field.

`destination_paths` caches an arbitrary list of external `Node3D` markers;
indices retain their configured order. Invalid, internal, and duplicate paths
are skipped. An invalid `starting_destination_index` falls back to the first
valid destination; no valid destinations leave the cube in place.
Optional `first_move_excluded_paths` apply only until the first successful
teleport, and `minimum_move_distance` (default 0) filters nearby candidates.
When `avoid_immediate_return` is enabled, the last successfully occupied
destination is also excluded from the next move. This is generic destination
selection behavior; two-destination fixtures can disable it for A/B cycling.
A pending candidate stays selected throughout its hidden grace. Becoming unsafe
clears that candidate and grace; no safe choice keeps the move pending with
short rechecks, without repeating the full release delay.

Subclasses may add one focused destination-availability constraint without
duplicating selection. `QuantumDoor` uses this hook to require that its door
collision shape, transformed to the candidate doorway, does not overlap the
configured player.

After generic eligibility and Observation Envelope safety are evaluated,
subclasses may choose from the resulting safe destination indices.
`ApplicationQuantumCube` uses only this selection hook: it excludes the Plate
before a randomly chosen third or fourth successful relocation, requires the
Plate on that move, and waits if the Plate is unsafe. Later moves return to the
generic random policy.

The exported `unobserved_delay` defaults to **2.5 seconds**, a provisional
shared observation-release interval used by both prototype chambers. It is a
gameplay-testing value, not finalized lore. The separate destination-hidden
grace remains **0.2 seconds**.

The session controller is independent of anomaly logic. It reloads Observation
Lab on `R` or an invalid fall, and pauses the scene with a minimal completion
overlay only after the Player enters the exit trigger beyond the final door.
