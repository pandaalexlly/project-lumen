# Triple Coexistence — Pre-Pilot Freeze Checklist

**Release gate for two unscored logistics pilots, not a completed sign-off.** Check and date each item against the actual machine, build, staff, and participants before the first pilot. The isolated prototype has recorded technical passes; **human comprehension remains UNVALIDATED**. This checklist does not authorize gameplay, geometry, or rule changes, and does not require a commit or push.

Freeze ID: ______  Date/time: ______  QA owner: ______  Moderator: ______  Build/snapshot ID: ______  Test machine/settings ID: ______  Pilot A date/ID: ______  Pilot B date/ID: ______

Use the [document authority index](../../docs/world/PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md) for precedence. The [current cognitive blind run sheet](TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md) controls participant-facing prompts, eligibility, timing, and route assignment; the [pilot checklist](TRIPLE_COEXISTENCE_COGNITIVE_PILOT_CHECKLIST.md) controls detailed operator checks. The [execution checklist](TRIPLE_COEXISTENCE_PLAYTEST_EXECUTION_CHECKLIST.md) is the per-session workflow; the [session tracking sheet](TRIPLE_COEXISTENCE_PLAYER_SESSION_TRACKING_SHEET.md) records raw data; the [scoring revision](../../docs/world/TRIPLE_COEXISTENCE_MENTAL_MODEL_SCORING_REVISION.md) defines the complete-stack evidence threshold; the [pilot review guide](../../docs/world/TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md) controls post-pilot disposition. The older proof-only blind protocol is **not** an alternative script for this integrated test.

## 1. Known and frozen for the pilot pair

These are the declared authorities and intended test conditions. A box means the operator confirmed and recorded the **actual frozen instance**, not merely that the document exists.

### Document authority and scope

- [ ] Staff briefing names the [canonical spatial rulebook](../../docs/world/PROJECT_LUMEN_CANONICAL_SPATIAL_RULEBOOK.md) as world-rule authority and the current cognitive run sheet as test-procedure authority. Older M/N–P/Q geography and the proof-only protocol are marked reference-only; no stale route instruction or answer-bearing diagram is in moderator materials.
- [ ] Test question is written as two separable gates: did visits produce a participant-generated **one-changing-place** model (`G1`), and did the first simultaneous view make someone holding it revise to **three fixed, complete units** (`G2`)? The pilots test whether these measures can be captured, **not** whether either gate succeeds.
- [ ] Moderator, observer, and later reviewers know the `T0` visits → `T1` H2 sketch → `T2` H0 return → `T3` first-view lock → `T4` diagnostic order. The second viewpoint or debrief cannot rewrite `T3`.
- [ ] The scoring revision is available to analysts: three atrium cues are at most location-level evidence; Level 3 additionally needs each atrium's own QER-like upper and Awakening-like lower relationship plus fixed coexistence. The older `I/C/E/R` codes remain recorded. Do not ask players to name these concepts.

### Prototype and build identity

- [ ] Identify the exact isolated scene: `res://scenes/tests/triple_coexistence_cognitive_probe.tscn`. Confirm direct game-window launch, clean H0 rear-pocket spawn after a close/relaunch, H0 → H1 → H2 → H0 sequence, and traversable A gallery and B ground approaches. **Do not use F5**, which opens Awakening.
- [ ] Record Godot/build version, project snapshot, scene and wrapper-script file identities, and relevant display/input settings. Capture a read-only `git status --short` or equivalent manifest **plus hashes/copies of untracked or modified prototype files**; a commit ID alone does not identify an untracked working-tree scene. Do not require a clean tree, commit, or push. Use the **same frozen snapshot** for both pilots; any change gets a new ID and a comparability decision.
- [ ] Operator-only dry run on that exact snapshot checks controls, mouse capture/release, final fork wording applicability, route walkability, first-view sightlines, and no clear triple-stack leak during prior visits. Record deviations from the [cognitive prototype technical validation](../../docs/world/TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md); a historical pass is not proof this machine/build is ready.
- [ ] Participant display hides editor, console/validator output, filenames, node labels, study documents, previous recordings, and A/B assignment. No player-facing explanation, objective marker, or developer overlay has appeared in the test build.

### Test materials and room

- [ ] Fix **one** playable, nonverbal prior observation experience for both pilots and the intended scored wave; record its build and delivery. No spoken explanation of observation, quantum behavior, copies, facility count, or the research hypothesis.
- [ ] Prepare two distinct, unbriefed and spoiler-screened pilot participants: one assigned A-first and one B-first. Their interpretations will be **unscored** and not pooled with formal sessions. Keep assignment concealed until after the H2 sketch.
- [ ] Moderator has only the current run sheet and necessary operator checklists; observer has blank timestamp/intervention notes. Two ID-only blank sketch sheets, pens, timer, session tracking sheet, consent materials, and a pilot review record are ready. Player cannot see any staff form, prior sketch, or answer-bearing title.
- [ ] Test room, chair, monitor/resolution/FOV/brightness, control mapping, audio, accessibility arrangements, and observer seat are prepared. Record any accommodation or setting deviation rather than silently changing the A/B exposure.
- [ ] Only one staff member speaks. Controls help, receiver-stall prompts, H2 sketch questions, A/B ramp-or-ground instruction, first-view neutral question, and T4 questions come from the run sheet; no improvised explanation, pointing, camera steering, praise, or confirmation.

### Recording and data protection

- [ ] Consent and prior-exposure screen are ready **before** capture or gameplay. Anonymous session IDs are assigned; identifying consent records are separate from gameplay notes.
- [ ] Screen and microphone capture pass a short playback check on the participant display/settings. Speech, repair details, view movement, and timestamps are recoverable. Recording, observer log, and sketch clocks are aligned.
- [ ] Approved access-restricted storage and file naming by anonymous ID are ready, with capacity and a way to verify saved playback. Recordings/sketches do not go into the project repository or a shared participant-facing location. Follow the team's existing retention/deletion policy; if none is available, obtain one before recording.
- [ ] A raw observation/intervention log can distinguish what was **on screen**, what was **apparently inspected**, what the player **said/sketched/predicted**, and what staff **prompted**. It can record assigned versus actual first view, three-atrium-cue opportunity versus complete-stack opportunity, and any early leak/crossover.

## 2. Known but intentionally unresolved — accept explicitly, do not fill in during a pilot

For each item, mark **accepted for logistics pilots** with initials or escalate. Acceptance means it does not prevent testing the *procedure*; it is not a world-rule decision or evidence that players understand.

| Open item | Boundary for this test | Acceptance / owner |
| --- | --- | --- |
| **Human comprehension and A/B effectiveness** | Unknown whether unbriefed players form the intended false model, identify three complete stacks, or prefer one view. A pilot's answer is diagnostic only. | ______ |
| **Production QER transfer, doors, and full facility implementation** | The floor-level H0 → H1 → H2 handoff is test scaffolding, not the canonical QER algorithm; production destination, egress, and other rulebook `UNRESOLVED` matters are outside pilot scope. | ______ |
| **Prototype evidence risks** | Inboard/exterior repair motifs match but are not one continuous surface; the lower Awakening tier first appears at the proof; the transfer may read as transport/loading; A may read as a bridge and B as ordinary wings. These are hypotheses to record, not fixes to improvise. | ______ |
| **Player behavior and exposure** | Players may infer multiplicity early, fail to find a view, look without noticing, or retain a rival theory. Preserve exact timing and classify cause afterward. No fixed path or answer is guaranteed. | ______ |
| **Confidence-prompt reactivity** | Pilots may test the same neutral confidence wording at T1 and T3. Whether to retain it for scored sessions remains open until pilot review; never ask it selectively or compare unmatched answers. | ______ |
| **Scored-wave document synchronization** | The scoring revision adds vertical-unit mapping (`V`) beyond the run sheet's older `I/C/E/R` full-reversal shorthand. Pilots must capture evidence for both; the final scored-wave protocol/analysis forms may require a synchronized decision before recruitment. | ______ |

Other accepted limitation or variance (describe, owner, why it cannot bias the logistics question): ______

## 3. Must be fixed before **any** pilot starts — hard stops

Leave the freeze **NO-GO** if any item below is unchecked. Fix the process or record a new snapshot; do not compensate by giving the participant extra information.

- [ ] One operative script is explicitly selected and physically available; moderators will not mix the current cognitive run sheet with the older proof-only protocol, old left/right directions, or outdated M/N maps.
- [ ] A specific nonverbal primer, exact build/snapshot, settings, A/B pilot assignments, and the same confidence-prompt trial policy are recorded **before** participant exposure. Do not choose them after seeing a pilot answer.
- [ ] Scene launches cleanly on the test machine; fresh restart, full visit route, both approaches, controls, mouse capture, and safe movement pass the operator-only check. Any parser/resource/scene fault or broken route is investigated before participation.
- [ ] The moderator can identify the H2 pause point and the final ramp/ground fork without showing node names, revealing the exterior proof, pointing, or substituting egocentric left/right directions. If the assigned sentence cannot be delivered before a full proof view, pause and repair procedure.
- [ ] The room and screen do not expose staff documents, scene names, maps, prior results, or a clear triple-stack view during the three visits. Any pre-proof leak that defeats the intended baseline must be documented and resolved before a clean logistics pilot.
- [ ] Recording consent, spoiler screen, anonymous-ID convention, separate identity storage, working screen/audio capture, clock alignment, blank sketches, intervention log, and restricted storage are ready. If data cannot be recovered, the pilot cannot validate the procedure.
- [ ] Moderator rehearses neutral responses and stop conditions. Observer knows not to coach, gesture, or react. The protocol's receiver-stall/no-view/first-view triggers are available; there is no improvised answer-bearing assistance.
- [ ] Reviewers agree how to record **both** adequate three-atrium-cue exposure and opportunity to inspect all three upper/central/lower structures; a cue in camera is not player understanding. A Level 3 inference must not be credited from a count or noun alone.

If a hard stop emerges during a pilot, preserve the partial record, label the affected measure, and use the [pilot result review guide](../../docs/world/TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md) to decide whether to repeat that pilot, repeat both, or request separate prototype investigation. Do not erase the case or silently change the build mid-pair.

## 4. Freeze decision and handoff

| Sign-off field | Record |
| --- | --- |
| All Section 1 checks evidenced? Missing item and owner |  |
| Each Section 2 unresolved item explicitly accepted for pilots? Exceptions |  |
| All Section 3 hard stops cleared? Evidence/build ID |  |
| Two unscored participants scheduled, A-first and B-first; moderator/observer briefed |  |
| Recording playback and secure storage verified by whom/when |  |
| **Decision: GO to logistics pilots / NO-GO pending fix**; QA signature and timestamp |  |

**GO** means only that the frozen procedure and materials are ready to test *measurement reliability*. After both pilots, apply the pilot review guide: procedure ready, repair and repeat, or prototype investigation required. Formal blind sessions cannot start merely because this pre-pilot checklist was signed; they need two usable pilot reviews and a locked scored-wave protocol. **Technical validation:** the isolated prototype has prior recorded passes, subject to the current-machine smoke check. **Human comprehension validation:** **UNVALIDATED**.
