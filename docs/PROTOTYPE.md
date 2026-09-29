# Prototype Goal

The prototype introduces one central rule: anomalous objects may change state while they are not directly observed.

The player explores a small first-person environment, interacts with objects, and learns through observation that looking away can permit an anomaly to change. Progress comes from understanding and applying this rule rather than collecting upgrades or keys.

## Observation Lab v1.0

Discovery exposes the observation-driven anomaly around one central blocker,
supporting deliberate line-of-sight experiments with both the cube and the
anomalous relocating door. Matching connector doorways now give that door a
consistent fit at the Discovery exit and Application entrance. Understanding
the shared observation rule is necessary to move it through both positions;
this is the prototype's first case where knowledge directly grants access to a
new space.

Application uses five irregular cube positions. The Plate is excluded from the
first moves, then safely guaranteed on either the third or fourth successful
relocation; this preserves uncertainty without permitting an endless random
grind. Moving the cube away later still releases the Plate and closes the final
door. Both anomalous object types use the same provisional 0.05-second
release lead-in followed by the 0.2-second destination-hidden grace.

Walking through the opened final door advances to the next knowledge-arc room.
`R` restarts the current stage, and falling out of a graybox also reloads it.

## Stabilization Beam technical prototype

An isolated graybox scene tests a provisional second observation source. A
directional Stabilization Beam can lock the current Quantum Cube while the
player looks away, or make a covered candidate destination unavailable. Power
and aim switches expose both cases without adding the Beam to Observation Lab
or changing the shared observation law. The current shared release lead-in is
0.05 seconds, followed by 0.2 seconds of destination-hidden grace.
Player and Quantum bodies do not block Beam propagation; ordinary solid world
geometry still blocks both its observation effect and visible path.

## Stabilization Lab Discovery

The first isolated gameplay room for the second knowledge layer places an
enabled Stabilization Beam on a familiar Quantum Cube. The player's usual
look-away experiment initially fails because effective observation can also
come from the environment. Disabling the Beam removes that second observer;
the unchanged player-observation rule can then move the Cube onto the exit
Plate.

## Stabilization Lab Destination Exclusion

A second isolated room extends artificial observation from current states to
future candidates. Its Beam initially covers the empty goal state, forcing the
Cube to move between the other available positions. Redirecting the Beam away
from the desired goal lets the player deliberately constrain the remaining
possibilities and move the Cube onto the exit Plate.

## Stabilization Lab Combined Constraints

The arc finale is a three-state facility experiment. The Beam initially holds
the Cube at Start; powering it down removes the artificial observer and its
visible field, while the player's gaze determines whether the Cube may enter the
orange shutter-control state on the right or the green exit-control state on
the left. Reaching orange closes the observation shutters. A diegetic recovery
console reopens them and restores Start without reloading the scene, preserving
the Beam's OFF state so the retry focuses on correcting the player's observation
constraint. This chamber alone prefers orange whenever it remains safe, so
green is earned only by directly observing and excluding orange. That
deterministic tie-break is level-specific teaching behavior, not a new world
rule; observation safety is still authoritative.

## Current Knowledge Arc

The F5 experience advances from Observation Lab through Stabilization
Discovery, Stabilization Destination, Stabilization Combined, and the Field
Observation Site before reaching the ending. The lessons progress from direct
observation controlling current state, through artificial observation
stabilizing current state and excluding future states, to the player's own
direct sight excluding a future state. Each exit loads the next stage with
fresh local state. The sequence is mechanically validated and awaits human
pacing and knowledge-transfer confirmation.

The teaching sequence shares a restrained facility language: neutral
structural shells, cyan research equipment and Beam infrastructure, orange
warning or failure controls, and green goal or exit guidance. Structural ribs,
equipment rails, mountings, and floor conduits appear only where they help
explain a chamber's function. Lighting becomes slightly more focused across
the sequence while preserving clear sight lines and the existing layouts.

## Field Integration Prototype

`field_observation_site.tscn` is an isolated abandoned observation facility.
Its entry wing, ruined operations hall, Beam control annex, containment hall,
observation mezzanine, restoration relay, and service exit give existing
QuantumDoor, direct-observation, and Stabilization Beam mechanics environmental
roles. It is the first test of these systems as a game location rather than a
teaching chamber. It now follows the four teaching rooms in the F5 chain and
leads to the dedicated ending; human navigation and level-feel testing remain
part of the external playtest.

## Audio Polish Insertion Points

The silent `AudioManager` exposes event points for interaction, Beam power,
Beam redirect, successful Quantum relocation, pressure-plate state, door
opening, and completion. No placeholder music or sound assets are included.
Quantum relocation fires only at the successful move boundary rather than
during its cancellable observation-release timer.

## Vertical Slice Presentation Layer

F5 now opens a minimal Project Lumen main menu. Starting calibration enters the
same Observation Lab puzzle and a lightweight flow controller advances through
the four teaching stages, the isolated Field Observation Site, and a dedicated
ending screen. Puzzle scenes retain their local session controllers and all
existing anomaly logic; the flow controller only selects the next scene after
an existing exit succeeds.

Each gameplay stage briefly displays a facility-style room identifier. A small
context prompt appears only while the player's interaction ray is focused on an
`Interactable`, and short notices acknowledge Beam changes, opened access, and
Combined recovery. Successful anomaly relocation, Beam power changes, plate
activation, and door movement also receive brief world-space light or scale
pulses. These displays are presentation feedback rather than new gameplay
state; relocation no longer repeats a diagnostic-style HUD announcement.

The ending reports that the observation network is restored and offers either
a Field Site revisit (also available with `R`) or a return to the main menu.
The new `AudioManager` contains silent SFX and Ambient players plus event hooks;
no music, sound effects, or placeholder audio assets are included yet.

## External Playtest Build

The project uses a 1280x720 reference viewport with `canvas_items` stretch and
keeps its aspect ratio. Anchored menus, room labels, prompts, and notices scale
with the window rather than becoming gameplay state. A Windows Desktop release
preset is included at `build/project-lumen.exe`; creating the executable still
requires the matching Godot 4.7.2 export templates on the build machine.

External-test runs create an anonymous local JSONL event log under
`user://playtest`. The log records room order and timing, restarts,
interactions, and the Combined room's explicit failure state. It deliberately
does not record continuous input, camera movement, free text, or identifying
information. The structured protocol and report template live under
`tests/manual/`.
