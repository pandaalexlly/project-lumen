# Triple-coexistence greybox validation

**Status:** isolated technical prototype. **Human comprehension: UNVALIDATED.** This scene tests the three-fixed-facility premise of the current brief; it does not revise the production topology, previous design documents, or the F5 route.

## Question and scope

Can an unbriefed player, *after genuinely recognizing the three locations from prior exploration*, see H0, H1, and H2 at the same time and conclude that they are separate fixed facilities rather than one facility changing state? This scene supplies the physical final view only. It cannot manufacture the prerequisite memory or belief by itself.

Open `res://scenes/tests/triple_coexistence_probe.tscn` directly. The existing first-person player starts **inside H0's Atrium**, facing its open frontage. From there, an ordinary continuous ground route reaches the H0 ramp and both observation approaches. Walking and looking are the only actions. No room exchange, observation logic, Beam, camera rule, UI explanation, document, cutscene, label, or final art is present. The horizontal Left/Right rooms are deliberately omitted: they are not needed to test simultaneous stack visibility and would add a second question to this probe.

Each immobile stack has an open-front Atrium between an upper QER placeholder and lower Awakening placeholder. H0 has paired repairs, H1 slanted splices, and H2 offset capped posts, repeated through the three levels. These are ordinary structural differences in one restrained greybox palette, not color codes or in-world names. The H0 access floors stop on H0's side of open gaps; no floor reaches H1 or H2.

## Candidate viewpoints retained for comparison

| Candidate | Physical approach and visible evidence | Test risk, not a verdict |
| --- | --- | --- |
| **A — internal elevated H0 gallery** | Leave H0 through its frontage, ascend its continuous ramp, and stand in the narrow open gallery. H0's own repair and the two neighboring identities can be framed together. The player can look up/down to trace each QER–Atrium–Awakening stack. | H0 is large in the foreground; the default 75° camera does not present every tier in one static frame. The gallery frame or service runs may read as a bridge connecting facilities. A player may register only two side structures. Test whether movement resolves those readings or just adds effort. |
| **B — external oblique apron** | Descend the ramp, use H0's separate ground bypass and exterior run, then move laterally along the apron. All nine level targets have direct sightlines and fit the default camera frustum across a two-metre standing region. Near H0 posts shift against distant H2 posts with actual movement. | This is the clearest simultaneous three-stack composition in the current greybox, not an approved final solution. The service approach can still suggest ordinary wings; depth and void must read as material separation rather than decorative backdrop. |

Neither candidate is selected as the production solution. The geometry is deliberately small, open, and incomplete; its purpose is to expose failures cheaply.

## Technical checks

Run from the repository root:

```powershell
godot --headless --path . --editor --quit
godot --headless --path . --script res://scripts/world/triple_coexistence_validation.gd
godot --headless --path . --quit-after 120 res://scenes/tests/triple_coexistence_probe.tscn
```

The dedicated validator checks three named fixed roots with Atrium/QER/Awakening and recurring identity geometry; unchanged transforms across physics frames; broad A/B samples with the three identities in one frustum, direct physics sightlines to each level, and all nine levels in B's frustum. It measures more than 2° of near/far bearing change at B, samples floor support and capsule clearance, and walks the **existing** PlayerController from spawn through A, back, and to B. It also checks the H0-side wall and floor gaps, the unchanged F5 main scene, and the absence of viewport/sprite/video substitutes or extra camera feeds. These assertions are technical visibility and access checks, **not** an understanding test.

The rendered audit used the unchanged player camera: A showed both neighboring identity cues but crowded H0's own vertical stack; B showed the three complete stacked silhouettes and separated lower volumes. An initial elevated cross-scene access bridge visually suggested a facility connection despite passing collision checks; it was removed in favor of the ground-level B approach. A still has a bridge-like visual risk from its own gallery frame and access geometry. Do not promote the current image composition to a human readability result.

**Results in this run (Godot 4.7.2):** editor/import and direct scene launch completed with exit code 0. The isolated validator passed: player spawn inside H0's Atrium; three fixed stacks; 66 unchanged structural transforms; A/B direct sightlines; B's full nine-target framing; 3.51° of measured near/far bearing change across B; 330 floor/clearance samples; and an actual no-jump PlayerController walk from the Atrium spawn through A and B. The M/N spatial identity, state-persistence, camera-observation, and connected-facility regressions passed. `git diff --check` passed. The sandboxed Windows profile emitted log/telemetry-write and certificate-store warnings; these were outside the scene assertions and did not change their results.

## Blind human test protocol

1. **Separate prerequisite from reveal.** A cold launch here tests only whether three stacks, the current H0 location, and depth are visually legible. To test the intended *reversal*, first give the participant an unbriefed, consistent prior-exposure route in which they encounter each identity cue and vertical stack in apparent succession. Do not tell them there are three facilities, that the architecture exchanges, or what conclusion to seek. Record their own belief before the reveal; do not plant the "one changing facility" theory if they did not form it.
2. **Counterbalance candidates.** Give half the participants A first and half B first. Let them walk and look freely; do not teleport to markers, narrate the view, or point at repairs. After their first spontaneous interpretation is recorded, allow the second vantage and record whether it changes that interpretation. The developer marker names never appear in-world.
3. **Observe rather than coach.** Record whether they identify the location under their feet, recognize the other two from prior exposure, trace each upper and lower room to an atrium, move laterally to test depth, and use fixed separation to reject a single changing space. Record the first unsolicited explanation and any changed explanation verbatim. Do not say "coexist," "copy," "state," or "facility" as an answer prompt.
4. **Ask neutral follow-ups after exploration.** "What places are you seeing?" "Which details have you seen before?" "What remained in view as you moved?" "What could you check next?" Only after the participant commits to a model, ask which observation makes competing models less likely. Avoid yes/no confirmation of the intended answer.

**Human success criterion:** the participant independently identifies their current H0 and the two previously visited identities as *simultaneously present, materially separate places*, supports that claim with visible fixed stack relationships and movement/parallax, and explains why one changing location cannot account for the view. Counting three similar facades without connecting them to remembered locations is not success. Nor is repeating a facilitator's wording.

| Outcome to record | Likely diagnosis to investigate |
| --- | --- |
| "Three ordinary wings" | Coexistence is legible, but the prior one-facility interpretation or remembered identities did not meet the reveal. Check exposure and distinctive history before adding explanation. |
| "Another quantum state" | Co-presence or fixed separation was missed; check whether all three can remain visible during lateral movement and whether the player can retrace the H0 access route. |
| "Screens/mirrors/background models" | Open apertures and parallax did not read as real volume. Test stronger depth/occlusion and walkable-vs-unwalkable boundaries, not a text label. |
| "I have not been here" / identity confusion | Repairs and vertical relationships are not memorable enough, or prior exposure was too brief. Test the identity cue design independently. |
| Immediate correct guess before evidence | The three-stack presentation may reveal the answer too early; check whether the participant can actually justify it and whether the lead-in leaked the premise. |
| No stable account | Compare A-first versus B-first, inspect sightline crowding and ordinary-wing ambiguity; do not conclude the world rule is bad from one session. |

## Decision boundary

**Technical validation** can establish: fixed three-stack geometry, two reachable observation positions, simultaneous framing, direct physical sightlines, parallax, and no walkable inter-stack shortcut. **Human validation** must establish that prior memories transfer into the view and that the player eliminates one-changing-facility alternatives without being told. No blind sessions have occurred. Do not proceed from this document as if that cognitive gate passed.
