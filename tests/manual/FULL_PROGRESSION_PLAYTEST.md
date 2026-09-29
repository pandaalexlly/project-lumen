# Full Progression Playtest

## A. Developer full-run smoke test

Start only by pressing `F5`. Use WASD and mouse, press `E` to interact, and
press `R` to restart the current stage.

1. Confirm F5 opens the Project Lumen main menu. Select `BEGIN CALIBRATION` and
   confirm Observation Lab starts in its configured Discovery spawn with the
   mouse captured and all local puzzle state reset.
2. Complete the direct-observation Discovery Cube, QuantumDoor, and bounded
   Application Cube progression.
3. Walk through the opened Application exit and confirm Stabilization Lab
   Discovery loads directly without showing `PROTOTYPE COMPLETE`.
4. Confirm mouse look, WASD, `E`, and `R` remain functional. Complete the
   Beam-current-state experiment and walk through its exit.
5. Confirm Stabilization Lab Destination loads directly. Complete its
   destination-exclusion puzzle and walk through its exit.
6. Confirm Stabilization Lab Combined loads directly. Use its power switch to
   turn the Beam OFF. Make an ordinary first attempt and confirm the Cube
   moves from S to the right-side orange C Plate rather than randomly reaching
   the exit; confirm C closes both observation shutters.
7. Use the cyan recovery console. Confirm the room returns the Cube to S and
   reopens the shutters without a scene reload while preserving Beam OFF.
8. Reobserve S, then deliberately keep C visible while G is hidden. Confirm the
   Cube moves from S to G because C is excluded and cross the exit into the
   Field Observation Site.
9. Complete the Field Site restoration and cross the service exit. Confirm the
   dedicated ending reports `OBSERVATION NETWORK RESTORED`, `R` revisits the
   Field Site, and the menu button returns to the main menu.

Separately press `R` once in Observation Lab, Stabilization Discovery, and
Stabilization Destination before exiting each stage. Confirm each restart
reloads that current stage, not Observation Lab, and its exit still advances to
the configured next stage afterward.

At every transition confirm:

- the incoming Cube and Beam use that room's configured initial state;
- the PressurePlate is inactive and the SimpleDoor is closed;
- no previous stage state is retained;
- no intermediate completion overlay appears;
- the mouse is captured and movement, camera, interaction, and restart inputs
  work normally.

## B. Blind playtest

Tell the tester only:

> This is an early first-person puzzle prototype.
> Use WASD and mouse.
> E interacts with devices.
> Try to find a way through.

Do not explain direct observation, the release interval, QuantumDoor,
Stabilization Beam, artificial observation, candidate exclusion, or the
combined constraint puzzle.

Record timestamps or approximate progression for:

- their first correct description of direct observation;
- their first deliberate QuantumDoor use;
- their first reaction to the Beam-stabilized Cube;
- discovery of the Beam switch;
- realization that the Beam excludes destinations;
- realization that player gaze also excludes destinations;
- the final combined solve.

After completion ask:

> How do you think these anomalous objects work?

Then ask:

> Why did the Cube go to the green Plate this time instead of the orange one?

Record both explanations without suggesting possible answers. For the second,
note whether they identify their direct view of orange C as the changed
constraint.

## Knowledge-curve review

Evaluate whether the complete sequence reads as:

> DISCOVER -> APPLY -> ENCOUNTER COUNTEREXAMPLE -> REVISE MODEL -> USE NEW RULE -> COMBINE RULES

Record rather than pre-emptively fix:

- fatigue or disorientation from the short shared release interval;
- mechanics that feel redundant;
- lessons that feel obvious before their stage begins;
- unexplained conceptual jumps;
- accidental solutions that bypass the intended knowledge acquisition.
