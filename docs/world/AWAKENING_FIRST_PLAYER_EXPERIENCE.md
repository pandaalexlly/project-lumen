# Awakening Chamber: First Player Experience Pass

Current-layout note: the later discovery-pacing pass moved the service control to a guarded maintenance pocket and lowered the initial Cube mount. The subsequent Beam/load integration made its restoration local rather than the direct bulkhead trigger. The TASK-029 account below records the earlier handle placement and exit behavior; the shared interaction and quantum rules remain unchanged. See [the current discovery flow](AWAKENING_DISCOVERY_FLOW.md).

TASK-029 refines the existing opening-room presentation for a player with no prior knowledge. The chamber geometry, four Cube destinations, observation timing, relocation selection, service restoration, and surrounding workspaces remain the same.

## Arrival composition

The player now wakes slightly off the room's centerline, still facing the containment apparatus. This keeps the Cube inside the initial focus while exposing more of the maintenance bay and observation booth in the same view. The framing presents a place to inspect rather than a symmetrical puzzle lane.

The overhead inspection spot moved toward the player's side of the apparatus. Its practical angle now reveals the Cube's front and top surfaces. A chamber-only material override gives the object a dark ceramic-metal finish with readable edges. The shared Quantum Cube scene and its behavior are unchanged.

The strongest nearby contrasts remain functional: the working inspection fixture over the Cube, emergency light over abandoned recording equipment, and the observation booth's window and damaged consoles. Nothing flashes, points, or labels a destination.

## Discovery and relocation continuity

At TASK-029, the Cube retained the then-existing 2.5-second unobserved delay, visibility probes, random safe-destination choice, relocation pulse, and `AudioManager.cube_relocated` hook. The later shared timing pass reduced the release lead-in to 0.05 seconds while keeping the 0.2-second destination-hidden grace; TASK-029 did not force a first destination or schedule a scripted disappearance.

The containment transducer now listens to the existing relocation event. Each genuine relocation briefly moves its analogue needle and gives its dark instrument face a restrained amber response before returning to rest. The response repeats for later relocations, so it reads as equipment registering an event rather than a one-time tutorial cue. It does not observe, move, select, stabilize, or unlock the Cube.

The destination-local pulse remains the primary visual continuity cue. The existing audio event remains the authoring point for future sound integration; no placeholder or synthetic sound was added in this pass.

## Restoration control

The service control keeps the same collision, interaction script, placement beneath the initial Cube state, one-shot activation, and restoration signal. Its visual construction is now a recessed rotary mechanism with a central shaft, metal crossbar, worn grips, guard rails, and four fasteners. The lower-saturation grips distinguish a handled surface without reading as an illuminated game button.

The Cube still physically blocks interaction with the control from every reachable side. Relocation exposes it without changing a knowledge flag or enabling an invisible software condition. Operating it still drives the established local work lights, instruments, and ventilation.

## Validation

Run `godot --headless --path . --script res://tests/world/awakening_chamber_validation.gd`. In addition to the chamber's previous coverage, TASK-029 checks that the existing relocation event moves and settles the analogue sensor without creating an observer or UI element.

Rendered player-height views cover the revised spawn, the apparatus from an exploratory angle, the exposed rotary control, and the brief sensor response. Human playtesting must still answer:

Final TASK-029 verification passed in Godot 4.7.2. The automated chamber suite confirmed unchanged watched/unwatched relocation behavior, the first relocation, physical exposure and activation of the service control, restoration feedback, and later relocations across all four states. The presentation listener only animates its local needle, material, and light. Headless editor/import and main-scene launches also completed successfully. A 1280x720 rendered audit confirmed readable spawn, containment, exposed-control, and restored-facility states. Protected observation, interaction, restoration, prototype-scene, and project-configuration files matched their task-start hashes, and all temporary TASK-029 validation artifacts were removed.

- Does the player notice the Cube before assuming the bright ceiling fixture is the subject?
- Does the player notice the first absence, then deliberately test a shorter and longer look away?
- Does the repeated instrument twitch support the observation hypothesis without looking like a scripted objective cue?
- After the Cube leaves, does the player inspect the vacated apparatus and recognize the rotary control?
- Does restoring the facility feel like applying a discovered rule rather than completing a prompted sequence?
- How long do first-time players spend before their first deliberate observation experiment and restoration?
