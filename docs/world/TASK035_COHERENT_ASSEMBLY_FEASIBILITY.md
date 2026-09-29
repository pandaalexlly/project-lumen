# TASK-035 — Isolated Coherent Assembly Feasibility

Status: **GO TO FACILITY CONFIGURATION PLANNING** for technical feasibility only. Human mystery readability is **UNVALIDATED**. This task did not integrate an assembly into Awakening, the Hub, any wing, or a final escape.

## Implemented technical facts

- `CoherentAssembly` is a reusable `ObservableObject` subtype with its own candidate and support policy. It does not inherit the singleton `QuantumRelocator` previous-state restriction or alter Cube/Door rules. One root placement carries four explicitly authored children under `Members`: Cube, Bearer, Cradle (including `BearingBody`), and Collar. The local member transforms do not change. Configuration markers permit translation and yaw; invalid scaled or tilted markers are rejected. There is no dynamic membership inference, articulation, loose-cargo transport, or state unlock flag.
- Current observation is the OR of direct player visibility and existing artificial sources, over probe points on **every** member. Direct tests retain the shared guarded frustum, ray occlusion, and viewport margin. Cast shadows on independent architecture are not probes and have no observation authority. Beam observation uses the existing source geometry and occlusion test. The Beam's visual ray now treats assembly members as quantum geometry, as it already did singleton relocators; this is visual continuity, not a new Beam gameplay rule.
- Candidate queries place the **complete** authored member-probe set at each alternative root. The player ray omits only the departing assembly's collision bodies (and the existing camera/player collider), while independent fixed geometry and unrelated objects remain. Beam candidate queries use the existing `ignored_root` argument. Any observed prospective member excludes that entire alternative. All member collision shapes are checked at the proposed root against other world bodies. Source observation and candidate legality are rechecked just before commit.
- Release uses the shared approximate 0.05 s lead-in and 0.2 s hidden grace, with a pending candidate recheck. If none is legal, it waits and retries. A successful transition consumes that uninterrupted hidden opportunity; real reobservation of any current member, by player or Beam, rearms it. Every authored alternative except the current placement may be considered, including the previous placement.
- Passenger eligibility is measured from actual grounded player support. The player capsule footprint's center and eight rim points must ray-hit the authored cradle `BearingBody`, and an analytic box containment check must fit the whole footprint with a small edge tolerance. All sampled hits on explicitly authored fixed supports mean **off** the assembly. Mixed, missing, or unrelated cargo hits mean **unsafe**, so no move occurs. There is no attachment interaction, passenger flag, or observer exemption.
- A supported rider remains a normal camera observer. For each passenger candidate, the mapped capsule must fit without fixed-world overlap and the mapped camera must not directly expose an assembly member against the hypothetical fixed arrival world. Rigid root placement preserves `inverse(old_root) * old_player_transform`; relative velocity is yaw-rotated. The root and rider are assigned in one gameplay commit before the state-change signal. Fixed deck geometry preserves destination support; there is no post-arrival snap.

## Isolated fixture

`scenes/tests/coherent_assembly_feasibility.tscn` supplies three separated technical placements A/B/C, three existing Beam instances with power switches, a fixed-only circulation route, independent arrival landings and concealment hoods, and a small comparison screen at A. Its screen allows Cube-hidden/collar-visible inspection; nearby fixed-cover views hide the complete assembly without becoming a member. The floor, landings, and walkways remain fixed while the assembly moves. A/B/C here are test labels, **not** the approved final-world escape geometry.

The broad bearing deck is a deliberate support surface. The partial-support boundary is conservative: a player straddling deck and landing cannot depart, whether or not one sampled foot contact might still be on the deck. Loose cargo underfoot likewise does not recursively carry the player.

## Validation results

| Check | Result |
| --- | --- |
| Isolated suite `tests/world/coherent_assembly_validation.gd` | PASS: rigid member transforms, fixed route collision/support sampling, current Cube/collar/cradle visibility, fixed-only cover release, complete candidate exclusion, vacated-source query, Beam current/candidate observation, one move/rearm, no-candidate wait, previous-state return, A/B/C passenger and empty recovery. |
| Passenger and atomicity cases | PASS: full/off/partial/loose support, aboard observation, concealment cancellation, mapped rider pose, arrival concealment, member and rider collision rejection, late pending-candidate obstruction, state-change signal after both transforms. |
| Shared direct-geometry observation suite | PASS. |
| Shared quantum release suite | PASS, including existing Cube/Door and prototype release fixtures. |
| Awakening chamber suite | PASS. |
| Awakening Beam/plate suite | PASS. |
| Godot 4.7.2 headless editor/import | Exit 0; global classes and scenes parsed. |
| Headless scene launches | Exit 0: F5 main scene, isolated assembly fixture, Beam test, Observation Lab, Discovery, Destination, Combined, and Field Site. |

The sandbox prevents Godot from writing its ordinary `user://` logs, telemetry file, and editor settings, and reports that the Windows root certificate store cannot be read. These warnings were present during passing validation and are not assembly parser or gameplay failures. Headless launches do not establish visual readability or comfort.

## Remaining technical and human checks

- Member probes are a finite approximation to directly visible silhouettes. The A/B/C authored geometry passes the sampled cases, including small collar/cradle exposures, but arbitrary camera positions and future meshes need a rendered edge-coverage audit. A visible unsampled sliver would be an implementation or authoring defect, not a new observation rule.
- The isolated fixture uses simple same-yaw placements; the code accepts yaw-only markers, but rotated passenger arrival and hand-controlled traversal still warrant a dedicated integration test before using yaw in the final world.
- Collision, support, and arrival-camera gates pass the automated cases. Actual walking onto/off the deck, concealment comfort, viewpoint safety during a rendered transition, and Beam switch reachability remain manual technical checks. The automated fixed-route sweep verifies collision clearance and elevated fixed support, not a human-controlled traversal session.
- The hypothetical arrival camera veto is conservative. Future layouts should provide obvious fixed cover at every passenger berth; if the veto feels arbitrary, revise the spatial layout or contract rather than add an unexplained exemption.
- No shadow authority was added. Authored lighting and cast-shadow continuity for a final assembly are untested. No unbriefed human session occurred, so assembly identity, anti-elevator interpretation, and mystery revelation are **UNVALIDATED**.

## Future final-world design (not implemented)

Whether the facility's apparent architecture convincingly reads as one bounded object, whether the exterior placement is inferable, and whether the player understands supported travel require the planned spatial/human validation. This technical GO authorizes planning that work; it does not approve a final A/B/C puzzle or change the existing world progression.
