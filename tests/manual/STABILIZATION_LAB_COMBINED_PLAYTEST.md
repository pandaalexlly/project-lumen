# Stabilization Lab Combined Playtest

Open `scenes/prototype/stabilization_lab_combined.tscn`. Use WASD and mouse;
press `E` to interact and `R` only as a general prototype fallback.

## Developer smoke test

- Confirm the room remains bright enough for its architecture and all devices
  to be legible: Cube, Beam, S/C/G fixtures, both Plates, twin shutters, aim
  switch, recovery console, and exit.
- Confirm the Cube begins at S, both shutters are open, both Plates are
  inactive, the exit is closed, and the enabled Beam is aimed at S.
- Hide S for longer than the short release-and-grace window (roughly half a second) and confirm the Beam keeps it stabilized.
- Use the west power switch. Confirm the Beam turns OFF, its visible field
  disappears, its emitter face changes to the inactive state, and the Cube is
  no longer artificially observed.
- From the switch-side approach, use an ordinary first-attempt view or simply
  look away from the destination machinery. Confirm the Cube moves from S to
  the right-side orange C Plate rather than winning randomly, and both shutters
  close. Repeat a few ordinary turn-away directions and confirm C wins whenever
  it remains safe.
- Use the large cyan recovery console on the east side. Without reloading the
  scene, confirm both shutters reopen, the Cube returns to S, the C Plate
  deactivates, the green G Plate remains inactive, and the exit remains closed.
- Confirm recovery intentionally preserves the Beam's OFF state.
  Reobserve S from the east side near `(7.8, 4.5)` before another attempt.
- From the east-center gallery around `(3, 3.5)`, deliberately keep the
  right-side orange C position visible while the equipment shield hides S and
  the left-side green G position. Confirm the Cube moves from S to G, the green
  Goal Plate activates, the shutters stay open, and the final exit opens.
- Cross the exit and confirm the Field Observation Site loads without an
  intermediate completion overlay. Verify `R` still reloads the current room
  before exiting it.

## Blind playtest

Prerequisite: the tester understands the current-state and future-destination
Beam rules from the preceding rooms.

Tell them only:

> This continues the previous prototype.
> Try to find a way out.

Record:

- whether lighting and all important devices are readable;
- whether C and G look functionally different before either activates;
- whether the first S-to-C move clearly explains why the shutters closed;
- whether the east recovery console is found without prompting;
- whether recovery feels like a facility operation rather than a game reset;
- whether preserving Beam OFF makes the second attempt understandable;
- whether they deliberately use their gaze to exclude C on the successful try;
- whether success feels determined rather than lucky.

After success ask, without suggesting the answer beforehand:

> Why did the Cube go to the green Plate this time instead of the orange one?

The desired explanation should involve the tester looking at the orange
position and thereby making it unavailable.
