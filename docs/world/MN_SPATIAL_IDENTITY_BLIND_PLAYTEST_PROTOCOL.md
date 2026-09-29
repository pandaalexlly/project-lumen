# M/N Spatial Identity — Blind Playtest Protocol

**Status: protocol only; no human validation has occurred.** This tests the isolated M/N greybox, not the final facility. It draws on the [Player Reasoning Audit](MN_SPATIAL_IDENTITY_PLAYER_REASONING_AUDIT.md), [Prototype Validation](MN_SPATIAL_IDENTITY_PROTOTYPE_VALIDATION.md), and [Core Mystery Validation Plan](PROJECT_LUMEN_CORE_MYSTERY_VALIDATION_PLAN.md). The reasoning audit identified premature exchange and weak rear-face memory as risks; the later prototype revision added a shared first view, paired inspection aprons, and three-distance identity cues. Those are technical provisions, **not evidence that players use them**.

## Decision this test can make

Can a genuinely unbriefed player form a *prospective*, two-sided model: “The repaired doorway room will be where the solid-backed room was; the solid-backed room will be where the repaired room was; the surrounding landmarks will stay put”? Can they verify that model through a repeatable observed/hidden comparison? They need not say “M,” “N,” “socket,” or “quantum.” Reaching a changed doorway or describing the swap after it happens is not enough.

Score **identity/location reasoning** separately from **observation causality**. A player might correctly track both rooms yet attribute the exchange to a timer; that is an identity success and a causal-model failure. Conversely, knowing “look away” without tracking both room identities is not an identity success. The fixture cannot validate cameras, Beam, passenger travel, final P/Q geometry, or the historical origin of duplication.

## Setup and blinding

- Recruit players who have encountered Awakening's Cube/Beam observation behavior through play, but have **not** seen this test scene, design documents, developer notes, videos, or another participant's session. Record whether they finished Awakening and what they recall of it, without correcting their model. If a player has not played Awakening, record that as a separate exploratory cohort rather than mixing the result with this test.
- Run only `res://scenes/tests/mn_spatial_identity_probe.tscn` in a fresh process for each player. Confirm the starting layout is intact (`M@A, N@B` in moderator notes), the mouse is captured, both rooms are visible from the shared overlook, and no debug console, scene tree, inspector, validation script, or designer diagram is on the participant's display. Do not change gameplay settings between participants. Obtain consent before screen/audio recording; use anonymous session IDs.
- Allow the ordinary movement/mouse controls and accessibility help needed to operate them. The only scripted participant briefing is: **“This is an unfinished facility space. Explore it as you normally would. Tell me when you think you understand something unusual, or when you want to stop. I may ask what you expect to happen before you try something.”** If asked for an objective, repeat: **“Investigate whatever interests you.”**
- Never say or display “M,” “N,” “room swap,” “teleport,” “quantum room,” “receiver,” “socket,” “look away,” “two identities,” or “watch one wall” during the scored session. Do not direct the player to either apron, repair, doorway, fixed rib, plant, or blind spot. Do not point at the screen, demonstrate camera motion, restart after a surprising first exchange, or tell the player whether a theory is right.
- A neutral control intervention (“WASD moves; mouse looks; Esc releases the cursor”) is permitted and logged. A mechanics hint or a moderator-controlled demonstration invalidates the *independent discovery* measure from that point onward; any later behavior is diagnostic only.

Recommended first round: two unbriefed logistics pilots, then six to eight **new** unbriefed players using the locked protocol. Do not count pilots in the decision cohort if the briefing, capture method, or scene setup changes. A small sample finds recurrent failure modes; it is not a statistical claim about all players.

## Moderator sequence — observe, do not assign puzzle steps

The stages below are **observation windows for the moderator**, not tasks read to the player. Use a roughly 12–15 minute unassisted exploration window; allow a player to stop earlier. If there is no exchange or no deliberate second attempt, record that fact rather than manufacturing the event.

1. **First view and inspection.** Record what the player looks at from the shared overlook *before the first exchange*: both front silhouettes, M's tall front splice, N's broad lintel reinforcement, the central plant, receiver edges, A rib, or B stack. Record whether they voluntarily follow both aprons and notice M's rear doorway/repair versus N's wounded solid back. Close footing/fastener and floor-joint/clamp details are corroboration, not mandatory pickups. Do not ask them to name differences yet.
2. **First anomaly.** Note the precise action and view at which both rooms leave sight, whether the exchange happens before both were inspected, whether the player notices the return view, and whether they check **both** sides. Ask no leading question. If they volunteer “the door changed,” “I took the wrong side,” “both moved,” or another explanation, record the exact words and what they point to.
3. **Hypothesis formation.** Allow ordinary backtracking and repeat attempts. Record which comparison they choose: one room only, both rooms, fixed plant/slot landmarks, rear connections, or an observed hold. The player may first test a wrong hypothesis; a falsifiable wrong guess is useful evidence of reasoning. Do not turn this into a fixed room-by-room walkthrough.
4. **Prospective prediction checkpoint.** When the player announces or clearly begins a deliberate repeat attempt, ask **once**, before the exchange: **“What do you expect to find on each side afterward, and what do you expect to stay where it is?”** First record any prediction they had already volunteered, separately from the answer to this neutral prompt. Note current camera view, both room positions, exact words, and whether the exchange occurred *before the answer was complete*. If it did, the statement is retrospective; wait for another attempt rather than scoring it as a prediction. Do not ask “Will the rooms exchange?”
5. **Verification.** Let the player perform their chosen test. Record whether they check both shell identities and fixed landmarks after the exchange, whether they revise a wrong model, and whether they can produce a second controlled contrast: maintain view of either room for a no-exchange comparison, then reobserve and release both. A single failed look-away does not falsify a model if they cannot diagnose whether a member remained in view or whether the pair was rearmed.
6. **Post-session debrief, after primary scoring.** Ask: “What did you believe at first?”, “What made you change your mind?”, “Which features belong to a room and which to this place?”, “What would you expect if you watched one room while the other was out of view?”, and “What, if anything, still feels random or unclear?” These questions may clarify interpretation but cannot retroactively create an independent pass. Explain the design only after all recorded answers.

Do not prompt the player to keep the camera aimed at a shell while answering; that itself hints at the rule. If a spontaneous exchange occurs during a question, timestamp it and use the next lawful attempt for a prospective checkpoint. If the player becomes stuck, a neutral “What would you like to inspect next?” may be used after the unassisted window and marked as **prompted diagnostic**, not blind discovery. No explanation should be given before primary scoring ends.

## Observation record and coding

Capture a timestamped screen/video trace when consented, plus short verbatim quotes. For every exchange attempt record the **before state**, player camera location/direction, what was actually visible, action, **after state**, and whether a prediction was stated before the result. Moderator labels A/B and M/N stay on the private sheet only.

| Measure | Record as observed behavior, not inference by moderator | Coding distinction |
| --- | --- | --- |
| **First-view opportunity** | Did the player look toward both fronts from the overlook before turning away? Were both large repairs plausibly in view? | Available on screen / apparently attended / remembered later. Do not equate these. |
| **Two identities** | Which paired cues did they independently describe or revisit for each shell? | `0` none; `1` “door room versus other” only; `2` two distinct integrated feature bundles (front/rear/close as available). |
| **Fixed location** | Did they locate the plant, A rib/B stack, receiver rims or rear run/recess before and after? | `0` not used; `1` recognized a familiar side; `2` predicted at least one fixed reference would remain. |
| **First exchange awareness** | Did they notice a changed occupant, inspect the other side, and question their prior model? | Note whether first exchange happened **before both identities were inspected**. No forced reset. |
| **Prospective exchange model** | Exact statement *before a deliberate exchange*: what will be at **each** side, which features travel, and what stays fixed. | `0` none/retrospective; `1` one-sided or “something changes”; `2` correct two-sided shells but no fixed reference; `3` correct two-sided shells **and** fixed reference. Mark spontaneous vs neutral-prompted. |
| **Observer model** | Does the player predict that viewing either shell holds the pair, then test a repeatable watched/hidden contrast? | Record independently from identity score. “A timer does it” is not an observer pass. |
| **Rival explanations** | Verbatim words and evidence offered for teleportation, random movement/timer, navigational mistake, room loading, renovation/door animation, or building movement. | “Teleportation” is **not automatically failure** if their prediction conserves both shell identities and fixed ground. |
| **Verification and confidence** | Did observed result match prediction? Did they inspect both slots and update a wrong claim? How certain are they, and why? | Completion or confident vocabulary without a before-action prediction is not a cognitive pass. |

For the main decision, a **full independent identity pass** is code `3` on the prospective model with a correct post-exchange check of both rooms and a stable landmark, achieved before any mechanic hint. A neutral question can elicit the model without supplying it; still report spontaneous and prompted passes separately. Observation causality is a second gate. Record elapsed time to first inspection of each shell, first unnoticed/ noticed exchange, first two-sided hypothesis, and first valid prediction. Do not collapse all failures into “player did not solve it.”

### Session sheet (copy per participant)

| Field | Entry |
| --- | --- |
| Anonymous ID; date; build/scene revision; moderator |  |
| Awakening exposure and recalled model; relevant game familiarity |  |
| Briefing/control assistance; recording consent; any contamination |  |
| Timestamps: both inspected / first exchange / first two-sided comparison / prediction / verification |  |
| Before-state and camera view at prediction; exact quote; spontaneous or prompted |  |
| After-state and what player checked at **both** sides |  |
| Identity `0–2`; fixed location `0–2`; prospective model `0–3`; observer model notes |  |
| First and revised wrong explanations, with player evidence |  |
| Moderator intervention, technical anomaly, or invalidation |  |
| Debrief quote and proposed cause of any failure |  |

## Failure diagnosis — do not revise the rule from a single miss

| Observed failure pattern | More likely cause | Check before assigning blame | Smallest corresponding revision if repeated |
| --- | --- | --- | --- |
| First swap occurs before the player has noticed two distinct fronts. | **Poor spatial pacing/layout**, possibly a technically legal early release; not proof the player cannot reason. | Did the player begin at the intended shared overlook? Were both long-range cues actually visible and attended? Did they turn away immediately? | Adjust initial sightline/approach framing only; do **not** add a hidden “inspect both” gate. |
| Player sees both fronts but cannot later tell M from N. | **Unclear identity features.** | Which long/medium/close cue was visible at their real distance? Did N become merely “the other room”? | Strengthen integrated form, repair continuity, or lighting at the missed distance; no labels or color coding. |
| Player knows which room is which but cannot establish where they are. | **Poor spatial layout** or weak fixed references. | Did plant, A rib/B stack, and receiver rim remain visible during their comparison route? Did they accidentally use a different approach? | Improve fixed reference continuity or comparison vantage, not room markings. |
| Player tracks one room but never checks the other. | **Insufficient paired evidence** or one-sided spatial framing. | Was the other room accessible in the same return loop? Did the moderator accidentally imply only one side matters? | Shorten/clarify the two-sided comparison path and maintain both rooms as peers. |
| Player remembers both identities and landmarks, but still predicts a door animation, room loading, or whole-building move after repeat counterexamples. | Potentially **overly complex inference** or an insufficiently discriminating causal contrast. | Can they state what each rival theory predicts? Can they voluntarily run a watched hold and empty reverse exchange? | First clarify the observed/hidden comparison and shell boundary; reconsider the proof structure only if fresh cohorts still cannot make a prospective distinction. |
| Player calls it “teleportation” but predicts both shells and fixed surroundings correctly. | **Terminology difference, not conceptual failure.** | Ask what teleported and what stayed, after the primary prediction. | No revision based on the word alone. |
| No exchange, repeated unexpected exchanges, unsafe collision, or control failure. | **Technical/session fault**, not a cognitive verdict. | Compare actual view, rearm and safety state against validator behavior; log the event. | Repair the isolated fixture and rerun with a new blind player; mark affected session invalid for that measure. |

If evidence was never encountered, classify **access/attention** before calling the reasoning too difficult. If evidence was encountered but not recognized, classify **feature readability**. If recognized and remembered but not connected to the reciprocal outcome, classify **inference load**. Preserve mixed cases and exact quotes rather than forcing one cause.

## Revision and decision rules

- **Keep the core identity rule for the next isolated/integrated test** when at least two-thirds of a fresh six-to-eight-player decision cohort (for example, 4/6, 5/7, or 6/8) achieves a full pre-action two-sided prediction without mechanics hints, including at least one fixed landmark, and verifies the opposite occupation. Also require no repeated technical or spatial access blocker. Report spontaneous and neutral-prompted predictions separately. If identity passes but few players can predict a watched hold, keep the identity finding **separate** and revise causal readability before relying on observation in a larger mystery. This is a predeclared practical design gate, **not** statistical proof or authorization for final-room production.
- **Adjust presentation/layout, one variable at a time**, when players can use the observation rule but repeatedly miss a cue, lose the other slot, or misidentify a fixed landmark. Prioritize the distance-specific feature, first-view framing, or ordinary comparison route implicated by recordings. Keep the same exchange semantics, no tutorial text, no reward marker, and test the revision with **new** blind players.
- **Reconsider the spatial proof or core exchange concept** only after at least two distinct minimal readability revisions and fresh cohorts leave the same serious result: players demonstrably see and remember both shell identities **and** fixed references, yet cannot predict the two-sided exchange or need an explicit explanation to do so. First rule out technical faults, leading questions, and the artificiality of this compact fixture. Record a `REVISE`/`NO-GO` rationale rather than adding a secret selection rule.
- **Hold** if the cohort is too small, contaminated, technically unstable, or mixed in ways that do not isolate cause. Do not claim a pass because a player reached a doorway, used the word “quantum,” or understood after debrief. Do not claim a fail because one player never saw the second room.

Report the number of sessions at each prediction code, how many were spontaneous versus neutrally prompted, the rate of premature first exchange, dominant rival explanations, and the specific evidence players cited. Keep raw anonymized quotes and timestamps for review. **Current status remains UNVALIDATED** until such sessions are run; this document only defines how to test the discovery fairly.
