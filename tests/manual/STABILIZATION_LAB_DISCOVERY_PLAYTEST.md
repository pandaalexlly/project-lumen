# Stabilization Lab Discovery Playtest

Open `scenes/prototype/stabilization_lab_discovery.tscn`. Use WASD and mouse;
press `E` to interact and `R` to restart.

## Developer smoke test

- Confirm the Beam starts on, the Cube starts at A, and the exit door is closed.
- Confirm the switch is concealed from the spawn view and does not become a
  dominant focal point after a small leftward camera drift.
- Observe the Cube, turn fully away for about three seconds, and confirm it
  remains at A.
- Return to the Cube and confirm the Beam visibly covers it without crossing
  the Plate at B.
- Explore beside the emitter, confirm the switch is readable and reachable in
  the left-wall alcove, then switch the Beam off and confirm the switch itself
  does not move the Cube.
- Turn away for about three seconds and confirm the Cube relocates from A to B.
- Confirm the PressurePlate activates and opens the SimpleDoor.
- Before exiting, press `R` and confirm the Discovery room restarts locally.
- Solve again, walk through the exit, and confirm Stabilization Lab Destination
  loads without an intermediate completion overlay.

## Blind test

Tell the tester only:

> This is a continuation of the previous first-person puzzle prototype. Try to find a way out.

Do not explain the Beam, artificial observation, switch purpose, or destination
count. Record:

- Whether they initially apply the old observation rule.
- Their reaction when the Cube fails to move.
- Whether they notice and investigate the Beam.
- Whether they discover the alcove switch only after investigating the Beam
  side, without feeling that it was unfairly hidden.
- Whether they experiment with Beam power.
- Whether they conclude the Beam is another observer or stabilizer.
- Whether they instead describe it only as an anti-teleport laser.
- Whether the switch is discoverable without reading as an obvious tutorial
  button.
