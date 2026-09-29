# M/N Spatial Identity — Isolated Greybox Validation

**Status:** Implemented technical probe; **unbriefed human comprehension is UNVALIDATED**. This is the first isolated test proposed by [Core Mystery Validation Plan](PROJECT_LUMEN_CORE_MYSTERY_VALIDATION_PLAN.md), not a production Atrium, a final P/Q layout, or an ending route. It does not modify Awakening, the existing Assembly prototype, observation rules, or main-scene progression.

## What the probe contains

Open `res://scenes/tests/mn_spatial_identity_probe.tscn` and run that scene (F6), or launch it directly with Godot. F5 still starts the existing Awakening main scene. Movement and mouse look use the existing first-person player. No E interaction, UI instruction, story text, label, or explicit exchange control has been added.

```text
fixed rear service run     fixed blind recess
          |                        |
       slot A                   slot B
      M initially              N initially
   fixed rib outside       fixed stack outside
          \                    /
           fixed central plant
       paired inspection aprons
        shared initial overlook
```

Both rooms share the same greybox footprint and front-facing construction grammar. The revised spawn looks toward **both** fronts at once from a fixed central overlook. Two broad, ordinary inspection aprons lead toward the room openings without directing the player to a control or forcing an exchange. The central plant and the A/B-specific receiver landmarks remain in the same visual field. This gives a natural opportunity to compare both occupants before the first look-away; it is not a hidden “inspect both” requirement, and an early lawful exchange remains possible.

Each identity now has a three-distance evidence hierarchy. All repairs use the same restrained facility material rather than color coding:

| Shell | Long-distance feature from shared overlook | Medium-distance confirmation from apron/front opening | Close inspection detail |
| --- | --- | --- | --- |
| **M** | Tall repaired splice integrated into the inward-facing front pier. | Existing rear doorway and open leaf beside its older vertical wall repair. | Splice footing plate and small fasteners tied into the front pier/floor join. |
| **N** | Broad reinforcement integrated into the front lintel instead of M's vertical splice. | Distinct structural wound in its solid rear face, with a local brace. | Repaired floor joint and clamp just inside the front opening. |

The cues are children of their respective room shells, so they travel with identity. The plant, receiver rims, A rib, B stack, ground, service run, and blind recess are fixed. M's doorway meets a short fixed service run at A; after exchange it faces B's blind recess. This is a relationship to surrounding space, not a door animation.

The player can inspect either room from fixed Atrium ground. Once at least one shell has been seen, the pair exchanges **only after both rooms have been out of the player's direct view** for a short interval. The swap is atomic, offscreen, and reciprocal: `M@A, N@B` ↔ `N@A, M@B`. A visible participating shell holds the pair; no button selects a destination. The player must be outside both room footprints for safety. Reobserving a shell rearms the next legal test. There are only two legal occupations in this isolated fixture, so the other occupation is deterministic; this does not establish a general destination-selection rule.

## Technical checks performed

Run:

```powershell
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/world/mn_spatial_identity_validation.gd
godot --headless --path . --quit-after 120 res://scenes/tests/mn_spatial_identity_probe.tscn
```

The automated validation checks that **both shells and both long-distance facade features are simultaneously visible from the initial overlook**; each shell can also be separately inspected from fixed ground; a watched shell prevents exchange; a hidden interval swaps **both** whole identities; the plant and both receivers do not move; each shell retains its three-distance cues; no second swap occurs without reobservation; rearm allows return to the starting occupation; and no exchange occurs with the player inside a shell. Godot's scene launch and editor parse also complete. These are geometry and state checks, **not** proof that the repairs are salient or memorable to an unbriefed person.

The sandboxed Godot process reported failures to write its user log/editor settings and to read the Windows root certificate store. Those environment diagnostics did not stop parsing, the scene launch, or the validator; they should not be mistaken for game-logic failures.

## Unbriefed player test — not yet performed

Recruit players who have experienced Awakening's observation behavior but have not read the design documents. Tell them only that this is an unfinished facility space and invite investigation. Do not use “M,” “N,” “quantum room,” “swap,” “look away,” “socket,” or “teleport” in the participant briefing. Record actions and their own explanations, not just completion.

**Intended observation order, not a forced route:** From the shared overlook, both similar fronts and their different large repairs are available together; the player follows either apron and notices its rear doorway or solid wound; closer inspection finds a footing or floor-joint repair; a glance to the plant/rib/stack separates those fixed features from the shell. Only then is a first unseen change likely to have enough remembered evidence for comparison. Record whether this actually happens. The prototype never withholds exchange until the player has completed these observations.

1. **First inspection:** Do they look at both fronts from the overlook before moving? Which long-distance repair do they notice without prompting? Do they follow either apron, identify the rear doorway/solid wound, and then notice a close footing/floor detail? Can they distinguish those travelling features from the plant, rim, rib, and stack?
2. **First change:** If both rooms leave view, do they notice a difference and check **both** frontages? Record any premature change before they inspected both identities; do not reset or reveal the rule. If they see only a changed door at one slot, record that as an incomplete reading.
3. **Prospective prediction:** Before the player's next self-initiated release, first invite their own prediction without naming the pair. If needed, ask neutrally, “What do you expect to find at each side if this happens again, and what would stay where it is?” The target is a two-sided prediction—M's vertical splice/door/footing at N's former position, N's reinforced lintel/wound/floor joint at M's former position, fixed landmarks unchanged. An exceptionally observant player may make this prediction before the first exchange; do not require that to pass or add a knowledge gate.
4. **Counterfactual:** “What do you expect if you keep watching one of them?” and “Which parts belong to this place, and which parts belong to the room?” Ask only after their spontaneous exploration; do not teach the answer through the questions.
5. **Interpretation:** Let them describe the event freely. Expected early accounts include ordinary repair differences, a rear door changing, random movement, a loaded scene variant, or the building moving. “Teleportation” is not automatically a failure if they mean lawful relocation of two persistent shells; a single room vanishing/reappearing, a hidden lift, a rearranged set, or the whole building moving is insufficient unless they can explain both identities and fixed references.

**Cognitive pass:** Before a deliberate exchange attempt (normally the repeat), an unbriefed player can say in their own terms, **“the repaired doorway room will be where the solid-backed room was, and the solid-backed room will be where the repaired room was,”** while predicting at least one fixed landmark will not move. They then verify both identities and explain why room identity differs from slot location without a designer prompt. A lucky observation of the swapped layout, or repeating a phrase after a question, does not pass. Also record whether the cause of release is understood as loss of observation rather than a timer; the experiment must be repeatable and not feel random.

**Revision triggers:** If identities are missed, improve the integrated marks and sightlines without labels or color coding. If the event reads as a single teleport or door animation, strengthen simultaneous two-slot comparison and the fixed exterior references. If players cannot comfortably produce or recover an exchange, revise geometry/timing before adding narrative. If the space itself is read as moving, the fixed plant/rib/stack and receiver edges are not doing enough work. Do not answer a comprehension failure with tutorial text.

## Limits of this result

- This fixture isolates **player vision only**. It does not validate Beam or live-camera holds, K2 candidate-only observation, passenger inclusion, historical duplication, or the proposed true-ending X connection.
- The room construction is deliberately simple runtime greybox geometry. It is not a production art/layout commitment, and A/B here are test positions rather than final P/Q sockets.
- The technical test proves state and reference invariants under scripted camera orientations. It does not prove a natural first-play path, a clear rendered view for every human, or the emotional “I understood the boundary” moment.
- No unbriefed session has occurred. The current answer to “Is the core spatial identity mystery understandable before full production?” is **not yet known**; this scene makes that question testable without building the full game.
