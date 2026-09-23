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
door. Both anomalous object types use the same provisional 2.5-second
observation-release interval.

Walking through the opened final door reaches a minimal prototype-complete
state. `R` restarts the full session, and falling out of the graybox also
reloads it.

## Stabilization Beam technical prototype

An isolated graybox scene tests a provisional second observation source. A
directional Stabilization Beam can lock the current Quantum Cube while the
player looks away, or make a covered candidate destination unavailable. Power
and aim switches expose both cases without adding the Beam to Observation Lab
or changing the shared 2.5-second release and 0.2-second destination grace.
