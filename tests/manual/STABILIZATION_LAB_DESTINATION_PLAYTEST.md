# Stabilization Lab Destination Playtest

Open `scenes/prototype/stabilization_lab_destination.tscn`. Use WASD and mouse;
press `E` to interact and `R` to restart.

## Developer smoke test

- Confirm the Beam starts enabled and aimed at the empty Plate/C position while
  the Cube starts at A.
- Confirm the narrow Beam matches the emitter face, remains elevated above the
  Plate, crosses the empty cube-height space at C, and ends on the east wall.
- Observe A, turn away for about three seconds, and confirm the Cube moves to B
  rather than C.
- Leave the Beam on C and repeat observation-loss cycles. Confirm the Cube can
  return B→A and A→B but never reaches C.
- With the Cube at B, use the aim switch to redirect the Beam from C to A.
- Confirm the redirected Beam continues through A to ordinary wall geometry
  rather than ending at the Cube.
- Confirm the switch itself does not move the Cube.
- Observe B, turn away for about three seconds, and confirm the Cube moves B→C.
- Confirm the PressurePlate activates, the SimpleDoor opens, and the completion
  space is reachable.
- Press `R` and confirm the room restarts with Cube A and Beam aimed at C.

Also test the early action: redirect the Beam to A before the first relocation,
turn away, and confirm the current Cube remains stabilized at A. Return the
Beam to C to continue.

## Blind playtest

Prerequisite: the tester should already understand the current-state Beam rule
from Stabilization Lab Discovery.

Tell them only:

> This continues the previous prototype. Try to find a way out.

Record:

- Whether they notice the Beam is aimed at empty C.
- Whether they interpret the first A→B relocation correctly.
- Whether repeated failure to reach C produces a useful hypothesis.
- Whether they infer that the Beam can exclude a future state.
- Whether they deliberately move the Beam away from desired C.
- Whether they use the Beam to constrain A instead.
- Whether the solution feels like controlling possibilities rather than random
  luck.
