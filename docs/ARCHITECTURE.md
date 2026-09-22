# Initial Architecture

- `PlayerController`: Handles first-person movement and view control.
- `InteractionComponent`: Provides focused, reusable object interaction behavior.
- `ObservationManager`: Performs stateless direct-observation queries.
- `ObservableObject`: Owns per-object observation state and transitions.
- `QuantumCube`: Extends `ObservableObject` with multi-destination teleport behavior.

The explicitly assigned primary `Camera3D` is the only authoritative camera.
Direct observation currently requires both frustum visibility and unobstructed
physics line of sight. Reflections and secondary cameras are intentionally not
supported yet. In prototype v0.1, each `ObservableObject` uses one
`ObservationAnchor`; `observation_started` and `observation_ended` represent
changes in its direct-observation state.

`QuantumCube` uses `ObservableObject` transitions to schedule movement.
An observed-to-unobserved transition starts a cancellable
delay; if it expires while the cube remains unobserved, the cube randomly selects
from currently safe, eligible fixed external destination markers.
Its prototype Observation Envelope samples both the cube body and its
approximate shadow footprint, includes a camera-edge guard
band, and defines observation for both its current state and candidate
destination state. A destination must remain safely hidden for a short grace
period. The cube moves at most once during each uninterrupted unobserved period.

`destination_paths` caches an arbitrary list of external `Node3D` markers;
indices retain their configured order. Invalid, internal, and duplicate paths
are skipped. An invalid `starting_destination_index` falls back to the first
valid destination; no valid destinations leave the cube in place.
Optional `first_move_excluded_paths` apply only until the first successful
teleport, and `minimum_move_distance` (default 0) filters nearby candidates.
A pending candidate stays selected throughout its hidden grace. Becoming unsafe
clears that candidate and grace; no safe choice keeps the move pending with
short rechecks, without repeating the full release delay.

The exported `unobserved_delay` defaults to **2.5 seconds**, a provisional
gameplay-testing value, not finalized lore. Its canonical world-rule value
will be determined by future narrative/world building.
