# TASK-038B - Coherent Assembly World Integration

**Technical verdict: GO TO CONNECTED-WORLD UNBRIEFED PLAYTEST.** This advances only the integrated technical greybox. It does not certify unrestricted human comfort or mystery comprehension.

## Scope and architecture

The formal F5 world remains `awakening_chamber.tscn` -> `operations_atrium.tscn` -> `connected_facility.tscn`. The connected facility now instances **one** `coherent_assembly.tscn` and two existing `stabilization_beam.tscn` devices. A/B/C are three fixed `fixed_receiver.tscn` instances and root transforms for that one travelling object, not three assembly copies. No ending, credits, destination button, knowledge flag, or progression lock was added. The original Awakening Cube/Beam/plate, ObservationManager, QuantumRelocator, and global Beam rules were not changed for this integration.

All coordinates below are Operations Atrium local, with no A/B/C rotation or scale change:

| Configuration | Assembly root / fixed receiver | Function |
| --- | --- | --- |
| A | `(-6, 0, 38)` | interior inspection placement and initial actual state |
| B | `(6, 0, 38)` | interior service/return placement |
| C | `(-6, 0, 50)` | exterior placement with a separate west fixed landing and onward ground |

The one root owns Cube, bearer/chassis, 4 x 4 m cradle/deck, and doorway-like collar. Their local transforms remain rigid on every move. A narrow bearer spine now physically joins the Cube to the low bearer/deck; a non-luminous repair gusset and plate on one collar post form the asymmetric travelling signature. They are mesh **and collision** under existing members, never copies on receivers. The spine has two additional visibility probes and the repair has three; existing Cube corners, bearer edges, deck corners, posts, and lintel remain sampled. The repair lies inside the existing collar envelope; no cast-shadow probes or special passenger-observation exemption were added. The fixed receiver hoods, bed, contacts, side landings, ramps, and exterior floor do not move with the root.

The reused TASK-035 script remains responsible for complete-member direct observation, artificial-source observation, complete candidate checks, grounded full-deck support, passenger capsule checks, and the atomic root/passenger transform commit. The facility instance supplies the three receiver NodePaths, current player/ObservationManager paths, and **fixed-only** support subtrees. The facility script only initially aims R at B; the existing I aim switch initially aims A.

## Real Beam and observer integration

The initial actual state is A; I and R start powered, I aimed A, R aimed B. Actual I/C emitter position is `(-1.500007, 2.6, 33.99969)`, preserving the TASK-038A eastward relocation rather than the obsolete paper position. The actual I/A emitter is `(-1.80498, 2.6, 33.82551)` after aim rotation, and actual R/B emitter is `(10.69979, 2.6, 33.99969)`. I has separate power and A/C aim E-interact controls; R has a power E-interact control. All three were ray-focused and toggled through the real input path. Fixed mast/housing geometry remains separate from the travelling members.

The real Beam visuals reach their intended target envelope: I/A 3.272 m to target with 8.689 m visual reach; I/C 14.268 m with 17.937 m visual reach; R/B 3.564 m with 12.324 m visual reach. At each actual aim, center/edge/corner full-field rays (9 per corridor, +/-0.31 m offsets) are clear of fixed collision while assembly members are correctly excluded from the *fixed-obstruction* check. The I/C emitter matches the TASK-038A marker within millimetres; the post-insertion fixed-world full-field margins are **0.360 m past the A east hood** and **0.364 m at the S aperture east edge**, both over the 0.30 m practical gate. Existing Beam semantics continue through assembly members, respect fixed occlusion, and ignore the player as a Beam blocker. Neither Beam selects or summons a destination: R ON excludes empty B or holds actual B, while R OFF only removes that observer.

## Causal and safety results

`tests/world/connected_assembly_validation.gd` runs in the formal Awakening world, using real scene nodes and no test-only gameplay flags. It checks:

- Initial A is held by I; empty B is excluded by R. The S sightline directly excludes prospective C.
- At D with I OFF, all 9/9 ordinary standing samples see the actual collar while Cube, bearer and deck remain hidden. This alone holds/rearms all of A. Turning to the matched fully concealed view without changing R or a candidate state permits empty A -> C. Direct player sight of A also holds it when I is redirected to C.
- With I/C excluding C and R OFF, a hidden empty A moves to B. Actual B held/rearmed by R, then R OFF with I/C still excluding C, returns to A. Actual C held/rearmed by I/C, then I OFF with R still excluding B, also returns to A. A previous placement is never disqualified merely for being previous.
- Empty A -> B and A -> C move all four member local transforms together. All three fixed receiver transforms remain unchanged. No receiver is interior route floor.
- A fixed landing and an empty receiver recess are not passenger support. A split landing/deck footprint is unsafe. A grounded central deck stance is full support. While aboard, looking at the assembly holds it; boarding itself does not initiate travel. If the player genuinely conceals all members, candidate observation, artificial observation, member collision, mapped player capsule clearance, and arrival-view concealment still apply.
- Supported A -> B and A -> C moves preserve local player pose, keep full support, and emit the state-change signal only after root and player have moved. Player capsule obstruction at C rejects a passenger candidate before commit; partial support and no-safe-candidate states wait without dropping the player. A first lawful supported A -> C trip succeeds with B never visited.
- At B, the player reobserves, walks east off the deck to fixed floor, reaches R/J/H by fixed access, and can let the assembly return empty. At C, the player reobserves, walks west onto fixed exterior floor, pauses, and remains on that floor when the assembly later returns empty. No ending trigger was added.
- The fixed access graph survives assembly occupation at A, B and C: 398 capsule/support samples per state over H/J/D/I/R/A/B/V/S approaches, plus the separate TASK-038A fixed-route and no-S-to-C-shortcut checks.

## Concealment and rendered technical gate

A fixed lower shroud was added to each side of the **stationary** receiver hood after the first sweep showed that 14 of 81 modest downward/side looks could see the travelling deck's rear corners. The shrouds meet the existing hood sides, stop above the travelling deck, preserve candidate/member collision clearance, and do not alter the observation law or deck. The repeated diagnostic sweep at **each** A/B/C placement covers x drift +/-0.45 m, deck depth 1.0/1.2/1.4 m, yaw -15/0/+15 degrees and pitch -12/0/+15 degrees. At every placement, all **81/81** stances were fully supported, directly concealed, and left the controlled passenger candidate legal. Normal `move_forward` controller input crossed the A fixed landing onto full deck support, drifted rearward while supported, and dismounted to fixed B and C landings; no gameplay boarding snap, attach action, or camera lock exists. The test does use a known *starting* pose and scripted angle/position sweeps for repeatability, so it does **not** constitute a human freehand comfort session.

Temporary 1280 x 720 rendered captures from the actual player camera were inspected at A initial approach, collar alignment, side seam/bearer, D, vacant A/B, occupied B, I/A and I/C, S with empty/occupied C, boarding, supported concealment, B/C arrivals, C exterior step-off and exterior look-back. The lift of the Awakening bulkhead and the posed assembly/camera in this capture run existed only in the capture process; scene data was not changed. The receiver appears physically vacant after a move, D exposes only an upper travelling member, S shows fixed exterior receiving infrastructure before arrival and the same travelling structure afterward, and the C west seam joins ordinary fixed ground. The concealed view faces substantial fixed hood surface rather than a narrow slit. This is a **technical composition inspection**, not evidence that a new player will form the intended hypothesis. The greybox still has dark/unbuilt background and sparse final-world detail by design.

## Validation status and gate boundary

**AUTOMATED TECHNICAL RESULT:** PASS. Dedicated world integration, TASK-035 isolated assembly, direct-geometry observation, shared release, Awakening chamber, Awakening Beam/plate, and connected fixed-facility validations passed. Relevant standalone Beam fixture, F5 main-scene headless launch, Godot headless editor/import, and `git diff --check` passed. The old Awakening test's expected artificial-source list was updated to include the two real connected-facility Beams; no Awakening behavior was revised. Godot emitted restricted-profile log/telemetry, certificate-store, and editor-settings write warnings; no parser, scene-load, or gameplay assertion failure remained.

**MANUAL TECHNICAL RESULT:** Rendered player-height inspection completed; controller-input boarding/dismount and broad systematic camera/stance sweeps passed. A physical person has **not** yet performed unrestricted keyboard/mouse comfort testing. The 81/81 envelope and non-snapped controller movement support the technical conclusion that concealment is not pixel-perfect, but exact human ergonomics should be verified in the next session.

**HUMAN MYSTERY READABILITY: UNVALIDATED.** No unbriefed human session has tested spontaneous assembly-boundary recognition, non-Cube observation inference, passenger hypothesis, early C recognition, anti-elevator reinterpretation, final-exit prediction, or emotional payoff. These remain the connected-world playtest questions; automated legality must not be mistaken for human discovery.
