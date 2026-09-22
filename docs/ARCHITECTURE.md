# Initial Architecture

- `PlayerController`: Handles first-person movement and view control.
- `InteractionComponent`: Provides focused, reusable object interaction behavior.
- `ObservationManager`: Performs stateless direct-observation queries.
- `ObservableObject`: Owns per-object observation state and transitions.
- `QuantumCube`: Extends `ObservableObject` with two-position teleport behavior.

The explicitly assigned primary `Camera3D` is the only authoritative camera.
Direct observation currently requires both frustum visibility and unobstructed
physics line of sight. Reflections and secondary cameras are intentionally not
supported yet. In prototype v0.1, each `ObservableObject` uses one
`ObservationAnchor`; `observation_started` and `observation_ended` represent
changes in its direct-observation state.

`QuantumCube` reacts to observation transitions instead of performing its own
visibility query. An observed-to-unobserved transition starts a cancellable
delay; if it expires while the cube remains unobserved, the cube teleports
between fixed external PointA and PointB markers only after the destination is
also not directly visible. Its prototype Observation Envelope samples both the
cube body and its approximate shadow footprint, includes a camera-edge guard
band, and defines observation for both its current state and candidate
destination state. A destination must remain safely hidden for a short grace
period. The cube moves at most once during each uninterrupted unobserved period.
