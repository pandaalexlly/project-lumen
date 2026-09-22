# Initial Architecture

- `PlayerController`: Handles first-person movement and view control.
- `InteractionComponent`: Provides focused, reusable object interaction behavior.
- `ObservationManager`: Performs stateless direct-observation queries.
- `ObservableObject`: Owns per-object observation state and transitions.

The explicitly assigned primary `Camera3D` is the only authoritative camera.
Direct observation currently requires both frustum visibility and unobstructed
physics line of sight. Reflections and secondary cameras are intentionally not
supported yet. In prototype v0.1, each `ObservableObject` uses one
`ObservationAnchor`; `observation_started` and `observation_ended` represent
changes in its direct-observation state.
