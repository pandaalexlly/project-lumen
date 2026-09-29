# Observation Lab Playtest

## A. Developer smoke test

- Launch the project and confirm the Player spawns in Discovery facing the Cube area.
- Observe the Discovery Cube, briefly break and restore line of sight, then conceal it for roughly half a second and confirm it relocates around the single pillar.
- Observe Door A, deliberately hide it, and confirm it relocates to Door B.
- Enter the dogleg, observe Door B, deliberately break observation, and enter Application after it returns to A.
- Confirm the Application Cube uses five visibly irregular positions and cannot reach the Plate on its first or second relocation.
- Continue valid observation cycles and confirm the Cube reaches the Plate on its third or fourth successful relocation.
- Confirm the PressurePlate opens the final SimpleDoor.
- Before exiting, press `R` and confirm Observation Lab restarts locally.
- Solve again, walk through the final doorway, and confirm Stabilization Lab
  Discovery loads without an intermediate completion overlay.
- Move the Player below the level and confirm fall recovery reloads the session.

## B. Blind playtest

Tell the tester only:

> This is an early first-person puzzle prototype. Use WASD and mouse. Try to find a way out.

Record:

- Their first hypothesis about the Cube.
- Whether Door A opens accidentally while they study the Cube.
- Whether they connect the Cube and Door behavior.
- Whether Door B feels like deliberate reuse of knowledge or repetitive waiting.
- Whether they understand what to do in Application.
- Whether the bounded third/fourth-move progression feels too repetitive.
- Their final verbal explanation of the anomaly rule.
