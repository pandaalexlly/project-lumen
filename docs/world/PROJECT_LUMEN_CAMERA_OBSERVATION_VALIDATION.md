# Project Lumen — Camera Observation Validation

**Status: isolated technical greybox implemented; no final-facility integration or unbriefed human test. Human readability is UNVALIDATED.** This contract builds on [Knowledge Architecture V2](PROJECT_LUMEN_KNOWLEDGE_ARCHITECTURE_V2.md), [Knowledge Discovery Events](PROJECT_LUMEN_KNOWLEDGE_DISCOVERY_EVENTS.md), the [State Persistence Prototype Validation](STATE_PERSISTENCE_PROTOTYPE_VALIDATION.md), and the [Core Mystery Validation Plan](PROJECT_LUMEN_CORE_MYSTERY_VALIDATION_PLAN.md). It proposes no new quantum law: a *live powered lens with actual direct sight* is another observer under K1–K3/K5. A camera's power, a security console, and stored footage are not relocation commands or saved-state mechanisms.

## Implemented isolated fixture and technical result

Run `res://scenes/tests/camera_observation_probe.tscn` directly (F6), not the F5 main scene. The scene reuses the existing first-person player, direct player-visibility query, and the state-persistence A/B module without modifying their scripts. Its **scene-local** fixture adds one fixed, powered CCTV housing aimed at a participating A-side module surface. A physical opaque maintenance shroud is moved with the normal E interaction ray; it intersects the lens ray when closed but does not change camera power, the module's setting, either fixed receiver, or the lamp circuit. The camera does not see empty B from this mount. There is no Beam, recording monitor, puzzle text, objective marker, or camera-off console in this isolated test.

The fixture counts the surveillance `Camera3D` as an independent observer only while it is live and has actual frustum/physics line of sight. The shroud's `is_blocked` value is **not** read as a gameplay switch: its collision geometry must actually obstruct the ray. Player sight is still tested by the existing `ObservationManager`; candidate visibility, rearm, and player-clearance behavior remain those of the isolated A/B module. The familiar integrated repair, mounted lever, fixed A contact, and lamp let a player check that camera release changed *eligibility to move*, not the object's identity or current condition.

| Tested comparison | Expected and observed technical result |
| --- | --- |
| Player looks away; powered lens clearly sees current A member. | Module holds at A past the normal release interval. |
| Same lens/power; E moves the opaque cover across its optical path. | Lens no longer directly observes the member; the cover itself does not move the module while player sight remains. |
| Cover blocks lens and player also looks away; B remains unwatched. | One A→B relocation occurs after the usual unseen interval. The same repaired module and ON setting travel; fixed A output goes dark. |
| Player observes B, then conceals it again while cover remains closed. | Rearm permits one B→A recovery; the same A contact relights for the unchanged ON setting. |

## Final validation pass — 2026-09-29

The following completed with exit code 0 on the current working tree:

```text
godot --headless --path . --editor --quit
godot --headless --path . --quit-after 120 res://scenes/tests/camera_observation_probe.tscn
godot --headless --path . --script res://tests/world/camera_observation_validation.gd
godot --headless --path . --script res://tests/world/state_persistence_validation.gd
godot --headless --path . --script res://tests/world/mn_spatial_identity_validation.gd
git diff --check
```

**Passed technical checks:** camera-only direct observation prevents relocation after the player looks away; placing the opaque cover in that same powered lens's path removes its observation; the cover does not move the module while the player still sees it; with both views absent, one legal move occurs; the same repaired module and attached ON condition survive A→B→A, while fixed receiver geometry and A's contact remain in place. The validator also checks candidate B is outside the camera's view, the E interaction ray reaches the cover, rearm is required, and recovery works. The existing state-persistence and M/N automated tests passed unchanged. `git diff --check` reported no whitespace errors; its line-ending notices concern pre-existing tracked files.

**Human readability remains UNVALIDATED.** Headless checks cannot establish whether an unbriefed player notices the lens or its target, understands that the cover blocks an optical path rather than toggling a machine, finds a comfortable concealment position, or predicts the hold/release before seeing it. The greybox tests obstruction, not an independent off-member re-aiming comparison; a cover-as-switch interpretation remains plausible until blind sessions probe it. Beam equivalence is inherited from the established observation model, but this isolated camera fixture has no Beam and does not itself test a three-source comparison. No Q-room or true-ending transfer has been tested.

Godot's sandboxed process reported failures to write `user://` logs, playtest telemetry, and editor settings, plus a Windows root-certificate warning. None prevented import, launch, or these test assertions; they are not evidence of player-facing readability.

## The causal claim to falsify

The same bounded member should remain in its present placement while either the player, a reaching Beam, **or a live camera lens** directly observes it. Removing the camera's sight alone merely makes relocation *eligible* if all other current-member and candidate views, rearm, and safety conditions also allow it. A powered camera aimed at fixed scenery does not hold the member. A dark or stored image does not continue a past observation. If the lens watches an **empty** candidate, the existing K2 exclusion rule would apply; the first K5 proof deliberately avoids that extra variable.

This is a claim about an optical relationship, not a “camera enabled” flag. A power-off versus power-on comparison by itself is too weak: it is compatible with an electrical interlock. The essential contrast keeps the **same camera powered** and changes only whether its lens has a clear path to the already-known object.

## Discovery sequence and reasonable mistakes

| Player encounter | Likely explanation | Evidence that makes it insufficient | Revised prediction available |
| --- | --- | --- | --- |
| Earlier ordinary corridor: a service CCTV housing points through a work aperture. Its mounting, cable, and maintenance access make sense for surveillance. | Security system or background decoration. | No “camera puzzle” framing yet. On a revisit, its physical aim becomes relevant to a member the player already understands. | “What exactly can that lens see from here?” |
| A repaired quantum module at fixed receiver A is familiar from the persistence comparison. The player hides it from their own sight; Beam is absent, but it remains at A across a comparable interval. | Broken machine, automatic cycle paused, powered receiver, or hidden script. | B is visibly a lawful empty alternative before the player hides; A/B contacts and the module's attached setting do not change. The only overlooked live witness is the lens trained on the module's repair/collar. A single no-move interval is **not** proof. | “If that lens is watching the member, changing its view should matter without changing machine power.” |
| From fixed service access the player blocks the lens-to-member path with an ordinary opaque maintenance cover while the camera stays powered. They conceal their own view again. A lawful A→B move becomes possible after rearm. | The cover is a hidden switch or opening it triggers a timed animation. | The cover does not touch the module, receivers, wiring, or B; the module is still held when the camera can see it and can move when the same powered camera sees only the cover. Repeating the comparison and an independent physical obstruction, if needed, tests the *ray*, not the cover's interaction event. | “Clear live sight holds; blocked sight removes one observer, but does not command B.” |
| The camera remains live and powered but is aimed at fixed scenery, or its sight is physically intercepted without any power change. The module can again move only when player/Beam views are also absent. | Camera power, a security console, or recorded video selected a destination. | On-member versus off-member sight predicts the result better than power or an old image. A watched module still holds even with the camera blocked. | The camera acts like player vision and Beam **only when its actual live view reaches a relevant surface**. |

Do not stage a “camera reveal” by having a terminal announce the rule. The contradiction should arise because the player's correct Awakening inference—“nothing is watching it now”—fails until they notice the mundane lens they previously discounted.

## Minimum isolated greybox specification

The isolated fixture above instantiates the minimal contrast. The specifications below remain design limits for any revision; they are **not** an instruction to build a Signal wing or final route.

- **Known object:** one recognizable repaired module/assembly with a participating non-Cube surface, an ordinary attached condition, and two fixed A/B receiver seams. The previous state-persistence fixture supplies a useful causal baseline: the same repair and lever follow the object; A's contact/lamp stays fixed. Do not require the player to learn K6 and K5 simultaneously. Keep its attached setting unchanged during the primary camera comparison.
- **One live lens:** one mundane powered security camera on fixed infrastructure, with visibly readable orientation and a direct path to the member at A. Its footprint must **not** include candidate B. Its power indication remains unchanged through both trials; there is no exposed “unlock” console. A monitor and recorded footage are unnecessary for the first proof.
- **Fixed inspection and concealment:** an ordinary path lets the player inspect the camera, A, B, and the aperture from fixed ground. A nearby broad blind recess lets them stop observing either receiver without precision camera angles. A service-side opaque cover can interrupt only the camera-to-member path while leaving the module, A/B geometry, supply, and player concealment unchanged. It should read as plausible camera maintenance equipment, not a glowing control. A body/ordinary-object occlusion or an off-member camera aim can provide an independent corroborating contrast if the cover alone looks like a switch.
- **Observer accounting:** Beam absent or consistently out of reach; player does not see current or candidate during the release interval; no second live camera; B remains eligible and unobserved; module and destination unoccupied. Use the same rearm and safety rules as the known object. The camera is a *source* of direct observation, not a global boolean that freezes the fixture.

The useful sightline arrangement is `fixed camera → open service aperture → A module member`, while `fixed blind recess` sees neither A nor B. The cover closes the aperture **near the camera** so it does not also hide B from the player during preliminary inspection or alter a receiver. A fixed route back to both receivers permits checking results and rearming. No camera-to-B ray should exist in this first test, because candidate exclusion would make a no-move result ambiguous.

| Trial | Player sees member/candidate? | Beam reaches member/candidate? | Same camera powered? | Camera's live view | Expected inference, not a commanded outcome |
| --- | --- | --- | --- | --- | --- |
| Baseline hold | No | No | Yes | Clear to current A member | A remains held across a meaningful comparison interval. |
| Sightline release | No | No | Yes | Physically blocked or off-member; B unseen | A→B becomes lawful after rearm; repeat to distinguish from an unlucky single interval. |
| Player-control contrast | Yes, current member | No | Yes | Blocked | A remains held by player sight, showing the cover is not a relocation command. |
| Beam-transfer contrast (only if needed) | No | Yes, current member | Yes | Blocked | A remains held by Beam reach; camera is not a privileged switch. |
| Return/recovery | No after reobservation | No | Yes | Blocked/off-member for both current B and candidate A | B→A may occur lawfully. A camera still aimed at **empty A** could exclude the return, so do not use that state as an unexplained reset. |

The A/B fixture has only one alternative destination. A resulting B occupation does **not** prove that the camera or cover *selected* B. The technical test should verify direct camera-to-member visibility, candidate visibility, rearm, overlap safety, and identical power across contrasts, not merely that an animation played.

## Prediction test and interpretation of failure

Before the player touches the cover, ask neutrally: **“What do you expect to happen if the lens can no longer see that part, while everything stays powered?”** Record their answer and reason. After a successful contrast, ask what they predict if the same camera sees the member again, and what an analogous lens facing a different quantum surface could do. The strong answer identifies *live line of sight to a participating surface* and treats relocation as permitted rather than ordered. “Turn off camera to open the route” is a weak or wrong model even if it happens to produce movement.

Score separately: spontaneous notice of the lens; correct before-action prediction; controlled on-member/off-member comparison; recognition that the camera remained powered; repeatable diagnosis after a no-move trial; and transfer to a new lens position without a prompt. Record exact player language, first hypotheses, and whether they needed a developer hint. Completion alone is not a cognitive pass.

If players never suspect the camera, inspect whether its housing, aim, aperture, and target are physically legible before adding text. If they treat the cover as an electrical switch, give a second *geometrically different* occlusion or off-member aiming comparison with power fixed. If they blame a timer, compare extended watched holds against repeated sightline releases after rearm. If they infer the camera from a single failed relocation, the evidence is too weak: confirm candidate eligibility and all other sources, then repeat. If a clear powered lens and a blocked powered lens produce indistinguishable behavior under controlled conditions, the K5 fixture fails technically and should not be integrated. If the behavior works but players cannot predict it, revise environmental evidence rather than the rule.

## Relationship to later knowledge and the ending

- **Beam (K3):** Awakening has already established artificial observation. Camera discovery transfers that law from a conspicuous Beam to an ordinary facility device. An off-member lens is analogous to a Beam that is powered but misses its target. Neither selects a destination.
- **State Persistence (K6):** The repaired module's identity and attached setting remain its own before and after camera release. The camera constrains *when and where it can be*, not what its lever used to say; blocking the lens cannot restore A's prior ON snapshot. A fixed A lamp may change only because the module's present condition and socket connection change.
- **True-ending role (proposed):** A later live lens at Q might hold a participating M/N wall or exclude an eligible placement according to its real view. Only after this isolated K5 contrast is human-readable should such a consequential sightline be considered. The player should predict which surface that lens sees and what removing that particular observation permits. No camera-off flag, recording deletion, or console interaction should unlock an ending; K7 room identity and fixed-route alignment remain separate inferences. This document does not validate the final topology or authorize a Q implementation.

## Fairness and decision gate

The first camera must be discoverable as believable equipment **before** it becomes explanatory evidence. Its lens orientation and physical path to a known member must be inspectable; a player must be able to lose their own sight comfortably; any Beam/candidate/other-camera veto must be absent or diagnosable; the same-powered camera comparison must be repeatable; and an early no-move trial must not be treated as a forced failure. Existing ordinary cameras elsewhere can gain meaning on revisit without being highlighted as collectibles or clues. Stored footage may later offer historical context, but it cannot silently act as a live observer.

An invisible camera, a camera whose status changes simultaneously with the object, a “disable security” button that directly moves it, a monitor that inexplicably holds despite no live lens, or a camera aimed at both current member and candidate without a separable comparison would make the revelation arbitrary. Do **not** use any of those to justify a final lock.

**Decision:** the isolated camera-sightline **technical feasibility check passes** for a powered lens versus physical obstruction without changing global observation semantics. Keep human discovery, before-action prediction, transfer to Q, and true-ending readability explicitly **UNVALIDATED** until unbriefed sessions produce those observations. A technically working camera hold is not yet a player-discovered law.
