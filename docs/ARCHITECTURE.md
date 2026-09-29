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
- `CombinedTeachingCube`: Adds the final teaching room's local C-first policy.
- `CombinedTrialController`: Owns Combined shutters, recovery, and its local
  powered-down emitter-face presentation.
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
Its geometric samples approximate direct visibility of the participating body:
the center and near-corners of the Cube or Door. Camera queries include a
small edge guard band. These same body samples define current observation and
prospective destination exclusion for both player sight and registered
artificial sources. A cast shadow on independent architecture is indirect
evidence, not a gameplay observer; authored lighting should separately avoid
conspicuous watched shadow discontinuities. A destination must remain safely
hidden for a short grace period. The object moves at most once during each
uninterrupted unobserved period.

The reusable Cube and Door scenes retain their `BodyVisibilityProbes` center
and eight near-corner samples. These approximate visible surface, lower edge,
and silhouette geometry rather than literal pixel coverage. Their former five
`ShadowVisibilityProbes` each were floor/offset footprint estimates outside
the respective participating mesh, not Cube/Door members. They have been
removed from current-state, prospective-candidate, and Beam sample queries.
The same correction applies to all scenes instancing these reusable objects;
there is no Awakening or finale override.

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

The Combined chamber uses the existing Beam power API without changing Beam
semantics. Its room controller swaps only that room's emitter-face material
when power changes; Beam observation and visible-volume behavior remain owned
by `StabilizationBeam`.

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

After generic eligibility and direct-geometry safety are evaluated,
subclasses may choose from the resulting safe destination indices.
`ApplicationQuantumCube` uses only this selection hook: it excludes the Plate
before a randomly chosen third or fourth successful relocation, requires the
Plate on that move, and waits if the Plate is unsafe. Later moves return to the
generic random policy.

`CombinedTeachingCube` also uses only the post-safety selection hook, and only
in the Combined teaching chamber. It prefers the orange failure destination
when that destination is already safe, otherwise selects the safe green goal,
and otherwise waits. It cannot make an observed or Beam-covered destination
available and is not a general Quantum rule. Ordinary and Field Site cubes
continue to use `QuantumCube`'s systemic random selection.

The exported `unobserved_delay` defaults to **0.05 seconds** for every
`QuantumRelocator`, including `QuantumDoor`. The separate **0.2-second**
destination-hidden grace still filters fleeting occlusion and rechecks
visibility before a move. This shared timing is provisional gameplay tuning,
not finalized lore or an Awakening-only exception.

The session controller is independent of anomaly logic. It reloads the current
scene on `R` or an invalid fall. An exit either advances to its configured next
scene or, when no next scene is configured, pauses with a minimal completion
overlay. Scene transitions always instantiate fresh local puzzle state.

Presentation remains scene-local. Teaching-room environment settings,
non-colliding facility detail meshes, practical lights, and the small feedback
components under `scripts/presentation/` do not participate in observation,
Beam, relocation, or session logic. The feedback components listen to existing
state signals or visible transform changes and animate only meshes and lights.

## Presentation Services

- `GameFlow` is a small autoload that owns only the ordered vertical-slice
  scene list, room display names, menu return, stage revisit, and ending
  transition. `PrototypeSessionController` remains responsible for detecting a
  room's successful exit and falls back to its configured `next_scene_path`
  when a scene is not managed by the presentation flow.
- `PresentationUI` is a persistent CanvasLayer. It derives interaction prompts
  from the existing player interaction ray and shows transient room and event
  labels. It does not decide whether an interaction or puzzle action succeeds.
- `AudioManager` is a silent foundation with separate SFX and Ambient players.
  Interaction, relocation, Beam power, Beam redirect, plate state, door open,
  and completion boundaries emit audio hook signals; assigning actual audio
  remains a later content task.
- `PlaytestTelemetry` is a silent autoload used only for external-test evidence.
  It listens at existing room-flow, restart, interaction, and explicit Combined
  failure boundaries and writes flushed JSONL events under `user://playtest`.
  It does not sample input, camera movement, observation queries, or gameplay
  state, and it has no player-facing UI.
