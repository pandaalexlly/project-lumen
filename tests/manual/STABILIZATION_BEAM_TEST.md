# Stabilization Beam Technical Test

Open `scenes/prototype/stabilization_beam_test.tscn`. Use WASD and mouse; press
`E` while aiming at a switch. The left switch toggles Beam power. The right
switch changes its aim between destination A and destination B. Reload the
scene before each test so the Cube starts at A, the Beam starts off, and it is
aimed at A.

## Test A: current-state stabilization

1. Turn the left switch on and confirm the narrow visible Beam matches the
   emitter face, covers the Cube at A, continues through it, and ends on the
   room wall.
2. Look directly at the Cube, then turn fully away for about three seconds.
3. Look back and confirm the Cube remains at A.
4. While looking away, switch the Beam off and confirm the Cube can relocate
   after the normal shared release interval.

## Test B: ordinary relocation

1. Leave the Beam off.
2. Observe the Cube at A, then turn fully away for about three seconds.
3. Look back and confirm the Cube relocated to B.
4. Repeat from B and confirm the two-position fixture can return to A.

## Test C: destination exclusion

1. Use the right switch once so the Beam aims at B, then turn the Beam on.
2. Confirm the visible Beam covers B but not the Cube at A.
3. Observe the Cube at A, then turn fully away for about three seconds.
4. Confirm the Cube remains at A because its only candidate is stabilized.
5. Turn the Beam off, face away from both destinations, and confirm B becomes
   available after the pending destination recheck and hidden grace.

## Test D: wall and visual occlusion

1. In the editor, move `OcclusionPanel` from its parked position into the
   center of the Beam path between the emitter and destination A.
2. Run the scene, aim the Beam at A, and turn it on.
3. Confirm the visible Beam ends at the panel and does not continue through it.
4. Confirm the panel prevents the Beam from stabilizing the Cube behind it.
5. Restore the panel's parked position and confirm the Beam returns to its full
   configured length. The Cube itself should not shorten the visible Beam.

Record whether the device reads as another observer of the anomaly rather than
as a generic anti-teleport switch.
