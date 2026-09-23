# Stabilization Lab Combined Playtest

Open `scenes/prototype/stabilization_lab_combined.tscn`. Use WASD and mouse;
press `E` to interact and `R` to restart.

## Developer smoke test

- Confirm the Beam starts enabled, aimed at the Cube on the neutral Start pad,
  and the exit door is closed.
- Look away for more than 2.5 seconds and confirm the Beam keeps the Cube at
  Start.
- Use the aim switch to redirect the Beam to the empty east-side distractor
  pad. Confirm that using the switch does not move the Cube by itself.
- From the west side of the central screen, near `(-4.8, 3.1)`, look toward the
  empty west-side distractor pad. Confirm that pad remains visible while the
  screen completely hides the current Cube and southern goal Plate.
- Hold that view through the normal release interval and hidden grace. Confirm
  the Cube relocates directly from Start to the goal Plate.
- Confirm the PressurePlate activates, the SimpleDoor opens, and walking
  through the northern exit shows `PROTOTYPE COMPLETE`.
- Press `R` and confirm the room restarts with the Cube and Beam at Start.
- As a recovery check, deliberately produce Start-to-west-distractor movement,
  then use the east side of the screen to keep Start visible while hiding the
  current Cube and goal. Confirm the Cube can still reach the goal.

## Blind playtest

Prerequisite: the tester should already understand the current-state and
future-destination Beam rules from the previous Stabilization Lab rooms.

Tell them only:

> This continues the previous prototype.
> Try to find a way out.

Record:

- Whether they immediately understand why Start remains fixed initially.
- Whether they intentionally redirect the Beam away from Start.
- Whether they initially try ordinary turn-away behavior.
- Whether they notice that their own gaze prevents the Cube from using a
  candidate position.
- Whether they deliberately keep the west-side distractor visible.
- Whether they understand Beam and player sight as equivalent constraint
  sources.
- Whether they describe the solution as eliminating possibilities rather than
  getting lucky.
