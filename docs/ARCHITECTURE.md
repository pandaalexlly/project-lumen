# Initial Architecture

- `PlayerController`: Handles first-person movement and view control.
- `InteractionComponent`: Provides focused, reusable object interaction behavior.
- `ObservationManager`: Owns direct-observation queries.

The explicitly assigned primary `Camera3D` is the only authoritative camera.
Direct observation currently requires both frustum visibility and unobstructed
physics line of sight. Reflections and secondary cameras are intentionally not
supported yet.
