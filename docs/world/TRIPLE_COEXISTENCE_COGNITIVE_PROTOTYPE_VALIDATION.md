# Triple Coexistence Cognitive Probe — Technical Validation

**Status: isolated greybox implemented; human cognition UNVALIDATED.** This probe extends the [spatial proof](TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md) with the prior visits required by the [cognitive scenario](TRIPLE_COEXISTENCE_COGNITIVE_VALIDATION_SCENARIO.md). It does not replace the [blind test protocol](TRIPLE_COEXISTENCE_BLIND_PLAYTEST_PROTOCOL.md) or establish that players experience the intended revelation.

## Run the isolated probe

Open `res://scenes/tests/triple_coexistence_cognitive_probe.tscn` directly; F5 remains the existing Awakening main scene. Use the existing first-person controls. There are no participant-facing labels, objectives, documents, or explanation. The narrow enclosed passages are test-only transfer receivers, not final Quantum Entanglement Room gameplay. A moderator should pause after the H2 visit and **before** the last receiver for the protocol's neutral pre-proof map, without displaying developer node names.

The route is H0 atrium rear pocket → right-hand enclosed receiver → H1 left-hand receiver → H1 atrium → right-hand receiver → H2 left-hand receiver → H2 atrium → right-hand receiver → H0 front pocket → existing A/B observation paths. The player can explore each rear pocket; a handoff occurs only inside its source receiver. There is no scene reload at the final proof and no visible facility swap. All H0/H1/H2 structures are instantiated from the unchanged original proof scene and remain present throughout. The final return lands on the observation side of H0's fixed interior partition, still inside the H0 atrium frontage, so the player can walk to either original viewpoint.

## What was built and assumed

- The wrapper adds fixed interior partitions that hide the simultaneous exterior view during prior visits. Each rear face repeats its stack's existing repair language: H0 twin seams, H1 diagonal splice, H2 capped offset post. A column/bracket in each pocket makes the QER floor's *upper* structural continuation inspectable by looking up; the lower Awakening tier is first visible from the exterior proof. The original exterior repair cues, QER/atrium/Awakening placeholders, three stack centers, and A/B viewpoint geometry are untouched. Inboard and exterior repairs match as **motifs**, not as one continuous physical surface.
- Two plain dogleg cells per atrium make source and arrival spaces visually similar. A local `Area3D` moves only the player between cells in the fixed H0 → H1 → H2 order; a third handoff returns to H0's front pocket. The receiver geometry hides the instant of relocation from direct view. There is no UI cue or explanation of the change.
- The floor-level handoff is a **test surrogate**, not a canonical QER destination algorithm, fifth/shared quantum room, solved internal puzzle, or production one-way door contract. No Left/Right exchange, observation logic, Beam, camera, or passenger rule is simulated here. The upper QER and lower Awakening placeholders remain fixed structural context; the lead-in does not require entering the lower tier.
- The intended first belief is a research hypothesis, not an imposed result. Similar atrium proportions, repeated transit grammar, and different repair histories make one changing place *plausible*, but participants may instead infer several places immediately or never form a map.

## Automated technical checks

Run:

```text
godot --headless --path . --editor --quit
godot --headless --path . --quit-after 120 res://scenes/tests/triple_coexistence_cognitive_probe.tscn
godot --headless --path . --script res://scripts/world/triple_coexistence_cognitive_validation.gd
```

The new validator checks:

| Check | Result |
| --- | --- |
| Three original, fixed QER–atrium–Awakening stacks; three aligned rear visit pockets; H0 spawn and unchanged F5 main scene | **PASS** |
| H0/H1/H2 inboard repair motifs frameable from each visit center; upper QER floor supports inspectable by looking up | **PASS**; H2's high cap also requires an upward look |
| Pre-proof camera-origin rays to the *other* stack identities, QERs, and Awakening tiers | **PASS:** 918 rays from 153 capsule-clear, floor-supported grid positions intercepted by the current pocket/stack; not an exhaustive free-look proof |
| Actual area-triggered H0 → H1 → H2 → H0 handoffs and safe supported arrivals | **PASS** |
| Existing PlayerController traversal through all three dogleg receiver paths and from H0 return through A and B | **PASS** |
| A/B final direct sightlines to all nine original stack targets, with all three identities in frame | **PASS** |
| Fixed structural transforms, no walkable bridge between stacks, no participant-facing label/UI/screen substitute | **PASS:** 111 original and wrapper static transforms remained unchanged |

The Godot headless import and direct scene launch completed with exit code 0 and no parser or missing-resource error. This host reports certificate-store, `user://logs`, and editor-settings write warnings; these did not stop the run. The cognitive validator printed `PASS triple cognitive probe` after the full route. `git diff --check` is also part of the final repository check.

The untouched original triple-coexistence validator also passed. Existing M/N spatial identity, state persistence, camera observation, and connected-facility validators passed on the same working tree. Their host `user://`/certificate warnings did not include assertion failures. These regressions protect existing prototypes; they do not establish the new cognitive result.

## Human validation still required

Use unbriefed participants with matched prior knowledge and the existing blind protocol. Record their volunteered account during H0/H1/H2, obtain a neutral sketch at H2 **before** the return, log any inference caused by returning to H0 before the triple view, and lock their first A/B interpretation before crossover. Report the baseline distribution as well as the rate at which players who actually held “one changing facility” revise that model using both remembered repair identities and simultaneous physical separation. Do not score mere counting of three visible structures as a revelation.

Specific risks to watch:

1. **Premature copies guess:** the three inboard repairs or handoff may make multiple sites obvious before the proof. That is a lead-in finding, not a successful reversal.
2. **Three spaces without prior identity:** players may see three stacks but fail to match them to the atria they visited. Verify repair visibility and memory, not just the final frame.
3. **Persisting quantum-state account:** the fixed partition or occluded transfer may make the view feel like another loaded state. Check actual free-look/parallax and the player's explanation.
4. **Ordinary architecture account:** “three wings” is not automatically wrong; score whether the player identifies three persistent units and reinterprets the prior visits, not the noun used.
5. **Test-scaffold artifact:** the floor-level receivers do not reproduce a real QER passage or its internal puzzle. The final H0 front-pocket arrival differs from the prior rear-pocket arrivals. Either may become the reason for a player's theory rather than the physical proof.
6. **Vertical and identity transfer:** the lead-in shows an upper QER support, not a walkable QER or the lower Awakening tier. Its inboard repair echoes the exterior repair but is not the same physical mesh. Whether players remember a whole stack and match the echoed motif across viewpoints is untested.
7. **Unsampled sightlines and navigation:** automated rays cover a clearance-filtered position grid, not every camera angle or exploratory path. Two nearly identical receiver cells in each pocket may confuse navigation; the H0 final arrival faces the partition, so players must turn to find the exterior. A human operator must free-look each rear pocket, attempt unintended exits, inspect the repair cues, and confirm the doglegs and final route are discoverable without coaching.

**Conclusion:** Technical validation supports “the four-phase sequence can be built while the three facility stacks stay fixed and the final proof remains walkable.” Whether unbriefed players first believe one place changed and then independently infer three coexisting fixed facilities is **NOT TESTED**.
