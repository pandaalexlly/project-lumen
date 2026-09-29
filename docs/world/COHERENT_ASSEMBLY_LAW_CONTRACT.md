# Coherent Assembly Law Contract

TASK-032 — design validation only. Status: **REVISE before implementation**.

**TASK-034.3 amendment:** [Direct-geometry observation (S2)](OBSERVATION_EVIDENCE_CONTRACT_REVIEW.md) now governs this proposed contract. Actual member/payload geometry and existing Beams observe; cast shadows on independent surfaces are indirect evidence subject to a separate presentation check. A later shared-implementation conformance pass removed the singleton Cube/Door shadow-footprint samples; it did not implement assemblies. The later P2 geometry is eligible for human paper validation subject to authored-lighting review; assembly implementation remains unapproved.

This review challenges [TASK-031's mystery framework](CORE_MYSTERY_AND_KNOWLEDGE_FRAMEWORK.md); it does not approve that proposal by restating it. Nothing here is implemented. No gameplay, scenes, existing content, or observation behavior is changed.

## 0. Findings and decision boundary

The coherent-assembly idea can preserve the trusted observation rule, but TASK-031 leaves several important assumptions unresolved:

1. A physical connection is not automatically membership. Structural integration, attached payload, temporary support, and ordinary docking must be distinguished visibly.
2. The first viable model should be a **single rigid assembly in several placements**, not independently rearranging pieces held together only by an invisible state number.
3. All transported non-player geometry must contribute to observation, including secured cargo. Otherwise watching the load could fail to hold the load that visibly moves.
4. A passenger remains an observer. No “inside the experiment” exemption is allowed.
5. Existing candidate queries are not already a full counterfactual world model. Beam queries exclude the departing relocator; current direct-view candidate queries raycast the current scene. An assembly-specific future evaluation must explicitly resolve that distinction.
6. Physical support and safe departure require precise contracts. In particular, a partial step, a loose object underfoot, and a blocked passenger arrival cannot be dismissed as implementation details.
7. The finale can be reduced to one optional preparation action, boarding, turning toward fixed cover, and walking out. Waiting and reobserving are not extra commands.
8. The unqualified claim that the opening Cube “was always part of a larger assembly” is unsupported by the preserved opening. That wording is a design failure unless later physical evidence establishes it without contradicting the opening.

**Recommendation:** use geometric observation for this design, defer perceptual darkness, and continue design validation under the revised contracts below. Do not build an assembly or expand the world on the strength of this document. Conditional logical consistency is not evidence of player comprehension.

## 1. Terms and trusted baseline

| Term | Meaning |
| --- | --- |
| Assembly X | One bounded, permanently integrated quantum chassis and its structural members |
| Structural member | A rigid part of that chassis; not an arbitrary remote object |
| Secured payload | Nonstructural equipment visibly restrained to X for the whole authored encounter; transported and included in X's observation envelope |
| Passenger | The player temporarily included by direct, full structural support |
| Configuration q | One authored rigid placement of X and its fixed payload, with a complete collision and visibility result |
| Current observation O(q) | At least one current member/payload envelope is observed by the player or any enabled Beam |
| Candidate exclusion V(r) | At least one prospective member/payload envelope in r is observed |
| Legal alternatives L | Alternative configurations that satisfy all observation, occupancy, support and collision conditions for the present passenger status |
| Release opportunity | A continuous unobserved period, permitting at most one successful transition after the established release interval |
| Fixed structure | Architecture outside X that remains in place when X transitions; not necessarily immune to ordinary machinery or damage |

A member does not become exempt because a particular pair of configurations would leave one of its surfaces in the same place. All members always belong to the observed assembly. There is no per-destination “ignore this visible part” flag.

### Existing behavior that remains authoritative

- Player observation is camera frustum/guarded view plus physics line of sight, not an illumination measurement.
- Current object observation combines player and artificial observation with OR.
- A Beam observes only when enabled, within its volume and unobstructed by relevant world geometry.
- Player bodies do not occlude Beams. Boarding or body-blocking cannot switch a Beam off.
- The singleton Cube/Door executable now checks body-geometry samples only. This sampling approximates S2's direct-visibility law; it is not a separate player-facing physics rule. Under S2, a player's intention to look away is insufficient if actual participating geometry remains visible.
- Observed alternatives cannot receive the object.
- A release interval can be cancelled by renewed current observation.
- One successful transition consumes that uninterrupted release opportunity. Reobserving the actual current object rearms a later opportunity.
- A stored image, gauge inference, memory, name or diagram does not observe the object.
- Current release/grace values and optional previous-destination filters are implementation policies, not numerical lore.

The current player has movement, looking and interaction, but no jump, crouch, inventory, carrying or body-avatar mechanic. The hypothetical edge cases below do not authorize adding these abilities.

## 2. Formal assembly membership contract

### 2.1 Permanent structural membership

For this proposed model, two parts are members of one assembly only when they are rigidly integrated into the same continuous quantum-bearing structure, with that integration physically inspectable.

Use an unbroken chassis or load-bearing structure that incorporates the quantum element. Permanent structural joints may be welded, interlocking or visibly bolted through the bearer. A mounting that merely holds a detachable sample across an isolation gap is different from making that sample a structural part.

This is a world-authoring contract, not a rule that the game dynamically infers membership from every bolt:

- Every authored rigid structural connection that visibly continues the coherent chassis must be honored. A hidden membership list cannot cut across a visibly continuous bearer.
- A declared boundary must have a physical discontinuity: docking gap, separate feet, unlatched receiving socket, sliding bearing or isolation mounting.
- An arbitrary internal tag, matching material or cable is not sufficient evidence.
- A bolted ordinary machine does not automatically become quantum. The quantum-bearing structure must be identifiable through construction and repeated experiments.
- Membership is permanent during play. No assembling, unbolting, breaking links, growing domains, crafting or attaching distant objects is proposed.
- If the chassis is shown rigidly bolted to the ordinary building with no isolation boundary, either that building segment must belong too or the scene is invalid. “It stops there because the puzzle needs it to” is not an answer.

Cube, frame, cradle, structural collar and an integral conduit can all be members. A doorframe can belong when it is visibly part of the bearer. The surrounding fixed wall does not belong if a clear docking clearance separates it from the frame. A flexible cable or hose crossing that clearance supplies power or fluid, not membership; its physical connection must also permit departure.

### 2.2 Rigid placement constraint

For the first contract, each member has a fixed local transform relative to X's root. Configuration r changes the root placement, not the member-to-member relationships.

In design notation: member world transform in r = root placement in r × member's fixed local transform.

The Cube, cradle and collar therefore move as one recognizable structure. Their changed relationships to fixed apertures, pipes and landings can change usable routes without changing the assembly internally.

This is a material narrowing of TASK-031. Independently moving members, articulated folds, remote disconnected “entanglement,” topology swaps and whole-room rearrangements are excluded from the first contract. If the planned mystery needs them, this contract must be reopened before implementation.

Yaw rotations and translations are sufficient candidates; exclude pitch, roll, scaling and gravity changes for the first model. These restrictions avoid introducing a separate bodily-orientation puzzle.

### 2.3 Membership examples

| Example | Assembly member? | Why | Player-readable evidence |
| --- | --- | --- | --- |
| 1. Cube bolted into a transfer chassis | Yes, if it is structurally integrated across a continuous bearer; not if merely clamped in an isolated specimen holder | Bolts alone are not magic; the physical load path and isolation boundary decide which example has been authored | Visible through-joints and continuous bearer versus padded clamps, a gap or separate mount; observe either part and compare |
| 2. Cube beside a chassis | No | Proximity is not connection | Separate feet/gap; Cube can change while chassis stays fixed |
| 3. Doorframe structurally continuous with chassis | Yes | The continuous bearer includes it | Follow the structure into the frame; a visible gap separates the receiving wall; watching the frame holds the Cube |
| 4. Cable between otherwise separate machines | No | Signal/power connection is not rigid structural integration | Flexible slack and distinct machine bases; machines do not acquire a shared state |
| 5. Pressure plate touching chassis | No, if it is a separate floor-supported plate | Contact or transmitted force does not change identity | Independent base and seam; an ordinary plate may respond to weight without travelling |
| 6. Player standing on chassis | Not a permanent member; temporary passenger if section 6 is satisfied | Support determines transport inclusion, not membership | Continuous deck underneath the full stance, feet clear of fixed landing; reproduce boarding/stepping-off difference |
| 7. Player touching the side | No passenger and no membership | Side contact does not provide full support | Feet remain on fixed floor; side touch changes nothing |
| 8. Loose equipment strapped to cradle | Not a structural member; secured payload if restrained for the authored encounter | Restraints maintain its relative placement; its visible motion must be included in observation | Taut, inspectable straps/cradle clamps; shared position and carried wear after movement |
| 9. Ordinary floor beneath chassis | No | Supporting contact is not structural integration | Slip/docking gap and separate load-bearing floor; departure leaves that floor intact |
| 10. Two distant assemblies made from similar materials | No shared membership | Material family identifies a technology, not a particular object | Separate chassis/boundaries and independently testable observation |

Secured payload is not a loophole: seeing the strapped load holds X, and a visible future load envelope excludes its candidate. Calling the load “decoration” must never let it move while watched.

A loose unrestrained prop is not silently welded into the assembly or granted recursive passenger behavior. For this first proposal, loose movable cargo on a departure deck is outside approved content. If such a body nevertheless enters the mechanism, unsafe departure is rejected; it is not discarded or transported by an undocumented rule.

## 3. Observation contract

### 3.1 Current configuration

Let E(q) be the union of all structural-member and secured-payload body geometry in configuration q, including directly visible edges and silhouettes. Under TASK-034.3/S2, projected cast shadows and other indirect state evidence are not part of this observation envelope.

**O(q) is true if any player or Beam query observes any part of E(q).**

Therefore seeing or Beam-observing any of the following holds the whole assembly: Cube, cradle, collar, integral conduit, participating doorframe, or secured transported equipment. The Cube has no privileged authority.

Occlusion by another member never licenses visible change. If a visible collar hides the Cube, the collar itself holds X. A sliver of a participating member is sufficient; do not require that players recognize or identify it consciously.

Fixed architecture can occlude the assembly without pinning it, because it is not part of E(q). A hood attached to the moving chassis cannot provide the same trick: seeing its inner surface observes a participating member. The recommended service hood is fixed to the independent building.

### 3.2 Player and passenger

The same camera tests apply before, during and after boarding. No passenger exemption, closed-eye input, special camera mode or “only external observers count” rule exists.

The current invisible player capsule is not a newly visible quantum member. The player still acts as an observer; Beam transparency of that capsule is preserved. Adding a visible carried body, hands or mirrors requires a later observation review; adding a passenger cast shadow requires presentation revalidation. None authorizes an ad hoc self-observation exception.

For now, no visible transported player body or passenger shadow is added. Direct transported geometry cannot be omitted from the rule; indirect cast shadows follow the separate presentation contract. External NPC observers and multiple passengers are outside this contract.

### 3.3 Partial-observation tests

| Visible or Beam-covered element | Cube hidden? | Current result |
| --- | --- | --- |
| Only the collar | Yes | Entire X held |
| Only one edge of the cradle | Yes | Entire X held |
| Only secured equipment | Yes | Entire X held |
| Only a cast shadow on independent architecture | Yes | No direct hold, candidate exclusion or rearm under S2; presentation must be checked |
| Fixed receiving wall beside the cradle | Yes | Does not observe X |
| Another member occludes a sampled Cube point, but is itself visible | Yes | Entire X held; envelope coverage must catch the front member |
| One member through a real opening; all other members behind walls | Either | Entire X held |
| No participating geometry visible; only fixed hood/wall, possibly indirect evidence | Yes | Player does not hold X; Beams are still tested |

Seeing one participating edge but missing all sampled probes is a coverage bug or invalid authored envelope, not an intended player exploit. No pixel hunting belongs in the discovery.

## 4. Candidate-state contract

### 4.1 Whole-state legality

A candidate r differs from the current q and is legal only when all of these hold:

1. The complete authored rigid placement exists and preserves membership and fixed internal relationships.
2. All member and secured-payload transforms, shapes and direct-geometry observation envelopes are resolved together.
3. No prospective member/payload envelope is observed by the player or any enabled Beam.
4. All destination volumes fit without penetrating unrelated geometry, another assembly, fixed equipment or any actor left behind.
5. If the player is a passenger, their complete destination body and camera clearance are safe and full structural support remains valid.
6. Departure does not intersect, trap, carry accidentally, or remove the sole support from a nonpassenger.
7. Required fixed approach/landing clearances remain usable. In authoring, every supported arrival has a safe standing area and recovery route.
8. Observation grace and all relevant current conditions still hold at commit.

Observing the future collar excludes the entire candidate even if its Cube position is hidden. A single obstructed member or passenger invalidates that candidate. Other safe alternatives may still be chosen. If all candidates are invalid, nothing moves.

Formally, for current state q, current passenger status p and a single world snapshot w, define **L(q, p, w)** as all authored r other than q for which candidate observation is false, destination/arrival safety is true, and departure safety is true. A transition additionally requires **O(q) = false**, a mature unconsumed release opportunity and a completed legal-candidate grace interval. Keeping these gates separate is why an available C never defeats a still-observed A.

Do not remove an eligible passenger to make an otherwise unsafe candidate legal. Do not choose a “near enough” placement, nudge the player through a wall, truncate the assembly or roll a different state for each component.

For this proposed assembly policy, all otherwise legal returns are permitted, including immediate return to the previous configuration. This is an explicit future content policy; current Cube settings remain unchanged. Clue reads, area visits, chapter state and successful-move counts cannot add candidates.

### 4.2 Observation worlds and the current-code distinction

Current-state tests use the actual world and actual observers.

For assembly candidates, define a **vacated source snapshot**: remove only X's departing member/payload colliders and the included passenger from their old poses. Keep fixed walls, independent machinery, other assemblies and nonpassengers. Observer identity and pre-transition camera pose do not disappear just because the passenger's old collision capsule is omitted.

Test prospective envelopes against that snapshot. A first intersection with a candidate's own surface confirms a visible candidate member; its own geometry cannot conceal the whole candidate from a union-of-members test. Validate the fully placed candidate too, so an inserted member cannot create contradictory Beam/LOS assumptions. Any exposed transported member excludes that state.

The player's actual pre-transition view remains a veto: a rider cannot look straight at a visible destination and claim “my camera will leave here anyway.”

**Additional proposed passenger arrival-safety check:** evaluate the mapped camera pose in the complete hypothetical arrival world. Reject the arrival if that pose would directly expose participating geometry. Cast shadows on independent surfaces cannot invoke this veto under S2. This is a conservative passenger-specific safety restriction, not a claim that a hypothetical future observer already exists in the current game. Fixed shielding at both berths should make it redundant in ordinary play. If it causes unexplained rejected candidates, revise the layout or contract before building.

This makes two obligations explicit: a destination cannot be visible from the current view, and a carried camera cannot receive an arrival that defeats the intended concealment.

Implementation compatibility is not automatic. Today Beam candidates exclude the departing QuantumRelocator, while direct-view candidate queries use current-world rays without the same departing-root exclusion. Neither existing path validates an atomic multi-member scene. A future assembly evaluator would need its own approved counterfactual-query design; this review does not alter either existing API.

### 4.3 Direct silhouettes and indirect shadows — TASK-034.3

Preserve geometric observation, not a universal shadow observer. A direct silhouette is actual participating geometry seen against a background and holds/excludes normally. A cast shadow projected onto independent architecture is indirect evidence: no hold, exclusion, rearm or arrival veto. Ordinary darkness still does not remove geometric observation.

An authored assembly needs body/payload coverage appropriate to its full extent and prospective placements. The current Cube's fixed footprint probes are conservative implementation sampling, not a physical shadow solver or a law to copy onto a large frame.

Separately, actual authored lighting plus a recorded safety margin must avoid conspicuous watched shadow discontinuities, such as a recognizable collar projection vanishing or a full outline exposing destination selection. Minor ambiguous variation or passive after-response may be acceptable. This is an authoring check, never an invisible state-legality gate. See the [evidence review §§7–8](OBSERVATION_EVIDENCE_CONTRACT_REVIEW.md) for the criteria and current unchecked lighting status.

Mirrors/live feeds remain unsupported and require contract review before introduction. Numerical body-probe density and tolerance tuning belong to future authorized feasibility work; broad, reproducible hiding positions remain required. No probe or rendering change is implemented here.

## 5. Atomic transition contract

### 5.1 State sequence

1. X is observed. Current observation rearms one later release opportunity.
2. All current observation ends. The ordinary release interval begins.
3. Current observation returning cancels the interval and any pending candidate. Removing only one of several observers is insufficient.
4. When release matures, evaluate complete candidate states for the current passenger status. Choose one legal state for X as a whole.
5. Keep the pending state only while it remains legal for the hidden grace interval. Revalidate after observer, occupancy or passenger changes.
6. At one commit boundary, recheck all geometry, transforms, support, current observation and candidate safety.
7. Apply root/member placement and included passenger placement together, before another visible/physics result can use a mixture of states.
8. Consume the release opportunity. Signals, feedback and passive downstream responses occur after a complete successful commit.

No legal candidate means no movement. Conditions may be rechecked during the same unobserved period; failed checks do not consume it. There is no new chapter action that silently rearms a spent opportunity. The authored encounter must show how to observe every possible resting state again.

### 5.2 Safety at commit

The validation set includes:

- every structural member, secured payload, collider and direct-geometry observation envelope;
- the fixed member-to-root transforms and a single selected root placement;
- the passenger body, camera, local position, yaw and pitch;
- player support and any other actor's source support/clearance;
- destination overlap with fixed world, ordinary machinery, actors and separate assemblies;
- current direct observation, all enabled Beams and prospective observation;
- departing occluders removed only in the appropriate counterfactual query;
- the mapped passenger's first arrival view and safe fixed landing;
- currentness of the world snapshot through commit.

An ideal discontinuous relocation does not sweep through the space between berths. Test source and destination occupation and local boarding/departure safety, not a fictitious corridor between them. Passing through intermediate world volume is not walking, tunnelling physics or a new portal.

Overlapping authored static parts within X may be valid joins; overlap with an unrelated occupant is not. Being in the middle of a doorway is never sufficient reason to force a player aside.

If any validation fails, no member moves, no passenger moves, no completion is emitted, and the opportunity remains unconsumed. Never show one-frame split configurations or half a relocation effect.

Initialization must not supply a special finale hold. For the proposed encounters, author a real observer holding the initially accessible assembly, or require an actual observation/release cycle before its first transition as the current behavior does. Do not present an artificially frozen unobserved A as evidence of the law. A future decision to let never-observed assemblies start relocating immediately would be a separately identified lifecycle change, not implicit in this review.

### 5.3 Other moving objects and simultaneous assemblies

Separate assemblies have separate release opportunities. A Beam can hold both only by actually covering their geometry; that is shared observation, not shared identity.

Treat every other assembly as ordinary occupied world geometry during X's validation. Two pending transitions cannot reserve the same space or swap through occupied berths by relying on each other's uncommitted departure. Commit in a stable order and revalidate the second against the first result. No global simultaneous-relocation puzzle is proposed.

Ordinary moving machinery may change LOS or block a destination. It remains ordinary machinery and can move while watched. If it exposes a current member before commit, X's release cancels; if it blocks a candidate, that candidate becomes invalid.

## 6. Supported-passenger contract

### 6.1 Acquisition and readable support

The player is a passenger only while their CharacterBody is grounded and **fully, directly supported by structural bearing surfaces of one assembly**.

A designated support is not an invisible patch. All physically walkable, load-bearing surfaces of the authored cradle/chassis must follow the same rule. Any nonboarding ledge must be physically inaccessible or clearly non-supporting, not visually identical geometry with a different tag.

“Fully” means the grounded body's support footprint is contained within that assembly's bearing surface, without relying on ordinary floor, another assembly, a loose object, or a side wall. It does not require a feet animation or a player model with two tracked feet. A capsule's resolved contact plus its footprint, rather than one downward ray or its center point alone, must represent the rule.

Tiny collision tolerances are numerical robustness, not a dwell-time mechanic or a secret safe zone. Boarding decks must have generous walkable width and explicit docking gaps, with no toe-balance challenge.

Passenger status is derived from current support after movement/collision resolution. There is no E action, consent prompt, research unlock, charge meter or persistent “entangled” flag. It is re-evaluated through release and immediately before commit.

### 6.2 Cancellation and changes during release

Leaving full support cancels passenger inclusion immediately. It does **not** make the whole assembly permanently unable to relocate empty.

If support changes during release or candidate grace:

- discard any candidate validation that assumed the old passenger status;
- preserve the assembly's one-opportunity budget;
- re-evaluate source safety, observation and complete candidate safety;
- require a fresh candidate grace under the new status;
- do not teleport from the old boarding position or restart all observation semantics merely because the player stepped away.

The assembly may subsequently move empty if its source is clear and no observer holds it. If the player is straddling the fixed landing and the cradle, departure must wait until the player is either fully supported as a passenger or safely on independent support. That wait is a physical safety veto, not a new observer.

A player must never fall because the algorithm abruptly reclassified their last remaining support as “not passenger.” This source-safety requirement is an additional assembly contract, not behavior claimed for today's Cube.

### 6.3 Mapping the passenger

Let Tq and Tr be the assembly root placements before and after transition, and Tp the player's world pose at commit.

Proposed destination pose: **Tp' = Tr × inverse(Tq) × Tp**.

Use the pose at commit, not a saved pose from first boarding. Preserve the player's local position, camera pitch and relative heading. A yaw-rotated berth produces the same yaw rotation of the player; do not independently rotate their head toward the reveal. Pitch/roll and scale-changing configurations are outside this proposal.

Movement velocity should preserve its relation to the support, with no impulse or launch. Exact CharacterBody handling belongs to future validation. The contract is that ordinary walking remains ordinary walking, and idle boarding does not become a momentum exploit.

If the passenger body, camera, standing support, safe dismount or concealed arrival view is invalid, reject that candidate for the complete assembly. If another fully legal state exists it remains available; otherwise wait. Never drop the rider as a fallback.

### 6.4 Passenger examples

| Situation | Passenger? | Consequence |
| --- | --- | --- |
| Grounded CharacterBody fully on cradle | Yes | Travel is possible only if observation and complete state safety also permit |
| Both illustrated feet appear on deck, but capsule still relies on fixed landing | Not yet | Source safety holds departure until fully aboard or safely off; art does not override collision |
| Airborne above cradle | No | No midair capture; if disappearance would remove a required safe landing from the actor, source safety rejects it |
| Jumping | No while airborne | Jump is not a current ability and is not added; any future jump requires retesting departure safety |
| Touching side wall | No | Ordinary contact does not attach; current LOS can still hold X |
| Leaning against member from fixed floor | No | The player remains on the floor; reject only actual overlap/pinching, not mere contact |
| Standing on a loose object on the cradle | No under direct-support rule | No recursive support transport; reject departure that would remove safe support; do not author this as a required state |
| Standing on permanently strapped nonstructural equipment | No unless that surface is itself a visibly structural bearing part | Payload travels, but passenger support is not arbitrarily inherited through a crate; this distinction is a major comprehension risk |
| Standing on ordinary floor that touches cradle | No | Empty transition is allowed if floor support and body clearance remain safe |
| Crouching | No special category | Crouch does not exist; no proposed solution requires it |
| Stepping off during release | Cancel passenger status | Revalidate; empty transition only after safe separation |
| Footprint partly on two independent assemblies | No valid single passenger attachment | Both must reject departure that would endanger the player; no domain merging |
| Body partly intersected by a support/arrival member | Invalid configuration | No forced inclusion, crush, clipping or corrective snap; reject departure/arrival |
| Fully aboard while watching any member | Yes, but observation holds X | Boarding never turns the player's eyes off |

The direct-support restriction is intentionally narrow, but may be too arbitrary to players when a strapped crate is visibly capable of bearing weight. Do not call this solved. Test it without explanation; revise the contract or exclude those ambiguous layouts from the approved content before implementation.
## 7. Darkness and perceptual-visibility fork

### 7.1 Contract A — geometric observation

As amended by TASK-034.3/S2, direct player observation uses geometric view and LOS for actual body/payload surfaces, including direct silhouettes, regardless of illumination. Guarded sampling is an implementation approximation. Cast shadows on independent surfaces supply no observation. Beam observation is independent and OR-combined.

Advantages for this mystery:

- The player can transfer an established spatial rule from Cube to structure to passenger without learning a second form of blindness.
- Fixed architecture matters. Separating the moving frame from a fixed hood is itself evidence that the player understands the assembly boundary.
- Ordinary power loss and quantum release remain distinguishable.
- Instruments and local lighting can support atmosphere without constantly changing candidate legality.
- A known hide position is repeatable across displays and visual settings.

Design costs:

- A player staring at a completely black object may reasonably expect not to observe it; geometric observation can contradict visual intuition.
- Requiring every ride to face a tiny blank ceiling patch would turn a conceptual discovery into camera choreography.
- Peripheral participating geometry still requires broad cover. The singleton implementation's historical shadow-only probes have been removed; conspicuous cast-shadow popping remains a separate authoring risk. Future assemblies still need their own adequate body/payload sampling.

Mitigation is an authoring obligation: do not make inaccessible blackness the apparent solution; give traversable quantum spaces enough persistent ordinary illumination to read their participating surfaces; use genuine, generous cover with a clear independent structural boundary. A dark facility can still have readable emergency illumination. These are future content requirements, not changes to Awakening lighting.

### 7.2 Contract B — perceptual visibility

Historical, **deferred and not selected**: B below bundled perceptibility and shadow-as-observation. TASK-034.3 selects geometric A with S2 instead. Its shadow rows are hypothetical costs of that older fork, not operative requirements for S2; any reconsideration must explicitly revisit both axes.

A future perceptual contract would require both geometric access **and sufficient visible evidence of the quantum body or its state-dependent silhouette/shadow**. This is a different global contract, not a special entanglement option.

It needs a defined, repeatable notion of “perceptible”: visible surface radiance, contrast against background, projected size and temporal stability. Engine luminance alone is insufficient; a dark silhouette against a bright wall can reveal the object. The thresholds must track what players can actually distinguish without making gamma settings or single pixels into tools.

Required consequences:

| Question | Required answer under B | Design consequence |
| --- | --- | --- |
| Unlit Cube in direct LOS | It ceases to be directly observed only when no readable surface, silhouette or state-dependent shadow remains | “Unlit” is not automatically “invisible”; a bright background can still hold it |
| Emissive material | A perceptible emissive edge or face holds the whole assembly | Emissive decoration becomes gameplay-critical and cannot pulse through observation thresholds accidentally |
| Shadows | A readable state-dependent shadow can still hold the object; no readable shadow supplies no evidence | Fixed geometric shadow probes alone are insufficient; dark surface and lit floor must be distinguished |
| A hypothetical future flashlight | When its light makes participating geometry perceptible within player LOS, it restores direct observation | No flashlight exists now; adding one later would change every quantum encounter and the passenger model |
| Every light switch as a quantum control | Any switch removing the last perceptual evidence can release direct observation, though Beams or silhouettes may still hold | The shortcut is a systemic consequence, not an exploit to patch only in the finale |
| External Beam in darkness | It continues observing when enabled, geometrically covering the target and unoccluded, even if the player sees no light | Artificial observation must remain clearly distinguishable from ordinary illumination; darkness is never a universal override |
| Candidate states | Test the candidate's hypothetical illuminated body, emission, silhouette and shadow, not brightness of the currently empty point | An empty dark spot may become a visible destination when an emissive part arrives; lighting the source alone is not enough |
| Self-light or carried light | Include it in prospective appearance without exempting it because it moves | A self-lit assembly may be impossible to release until a real change removes its visible evidence |
| Partial darkness | One perceptible member holds the whole assembly | A dark Cube does not release a still-readable collar |
| Light flicker/exposure | Transient visual changes need a coherent release/grace policy and robust perceptibility thresholds | Otherwise visual effects accidentally create relocations or inexplicable timer cancellation |
| Display settings and accessibility | The rule cannot change unpredictably with monitor brightness, tonemapping or quality presets | A single hidden render threshold that disagrees with player perception fails the contract |
| Awakening | “Seeing holds” can remain true, but geometric seeing is now an incomplete statement | Every old experiment needs auditing; future darkening may change answers even when no layout or code path looks different |

B's strongest payoff is a familiar structure disappearing from perception around a supported player, followed by a changed exterior on return of light. It can make the player's own vulnerability to the phenomenon immediate.

Its largest danger is replacing spatial investigation with “turn off lights and wait.” A game can choose that law, but must then allow it everywhere applicable, including places where it bypasses planned occlusion experiments. Adding unmotivated emergency bulbs only where the designer wants to prevent release would recreate arbitrary puzzle exceptions.

**Recommendation: A now / B deferred.** “Now” selects the law for continued design, not implementation approval. The reason is the desired mystery: the player must discover which physical structure they belong to, which observer constrains it, and how a missing route is a possible placement. Geometric occlusion directly exercises those relationships. B currently introduces more competing hypotheses about power and visibility than the ending needs.

Do not use darkness as shorthand for passenger release in evidence, concept art, paper instructions or the finale while evaluating A. If a later B trial demonstrates a materially stronger mystery, reopen the whole observation contract and all earlier teaching evidence. Never apply B only inside a transport hood.

## 8. Counterexample matrix

This is a logical desk review, not a report of implemented behavior or human testing.

### Reading the table

- X has three configurations: A internal inspection, B internal return, C exterior transfer.
- Unless a row says otherwise, all three have valid rigid transforms, clear collision volumes, safe landings, no directly visible participating geometry at either rider view, and reachable fixed recovery positions. Indirect evidence receives the separate presentation check, not an observation veto.
- “Legal candidates” means geometrically/safely eligible alternatives before the **current-observation and release-budget gate**. A nonempty candidate set cannot override a currently observed assembly.
- P = player sight, I = aimable inspection Beam, R = fixed Beam covering B's envelope.
- Unspecified Beams are off. Unspecified P views are toward independent opaque architecture.
- Every successful transition assumes the release and hidden-grace intervals completed and all conditions were revalidated.
- Previous-state exclusion is disabled for this proposed assembly policy. No clue flags exist.
- Recovery always uses ordinary movement, observation and Beam controls. It never means resetting a room.

| Case / current state | Observers | Legal candidates | Expected result | Why | Recovery |
| --- | --- | --- | --- | --- | --- |
| 01. A; one member visible | P sees one cradle edge | B, C | Stay A | Any member makes current O true | Hide that member and all remaining participating geometry |
| 02. A; one member Beam-observed | I covers collar only | B, C | Stay A | Artificial and direct observation use OR | Redirect/disable I, retain desired exclusions |
| 03. A; Cube hidden, collar visible | P sees collar | B, C | Stay A | Cube is not the privileged member | Move behind fixed cover hiding collar too |
| 04. A; future Cube at B hidden, future collar at B visible | P sees B collar envelope, no current member | C | Transition C | One visible candidate member excludes all B | Reobserve at C; normal return available |
| 05. A; future collar at B Beam-covered | R covers B collar envelope | C | Transition C | Candidate artificial observation excludes B | Inspect R if B was intended |
| 06. A; supported player watches assembly | P sees current Cube | B, C with rider | Stay A with passenger | Support does not disable observation | Look into fixed cover |
| 07. A; supported player sees only fixed hood; R on B | R observes prospective B, no current observer | C with rider | Passenger and X reach C together | Full support plus a sole legal alternative | Safe fixed landing at C |
| 08. A; supported player sees only fixed architecture; no candidate exclusions | None | B, C with rider | One randomly chosen complete configuration | Looking away is not destination selection | Both landings must be safe; reobserve for another release |
| 09. A; passenger safely steps onto fixed landing during release | R on B; P hides X | C, now empty | Discard rider-dependent validation, then X can move empty | Inclusion is current support, not a sticky flag | Recall from C using case 24 |
| 10. A; player straddles landing and cradle | R on B; P hides X | None until source support is safe | Stay A | Cannot depart under a partial, nonpassenger stance | Finish boarding or step fully onto fixed landing |
| 11. A; C fits X but passenger would hit a lintel; R on B | R excludes B | None with rider | Stay A; do not drop rider | Whole candidate includes passenger body/camera | Clear/avoid the obstruction or use another safe configuration |
| 12. A; same C passenger problem, B unobserved and safe | None | B with rider | Transition B only | Unsafe C does not prohibit another complete safe candidate | Safe internal arrival, then reconfigure |
| 13. A; C fits passenger, collar intersects fixed pipe; R on B | R excludes B | None | Stay A | One colliding member invalidates all C | Resolve that candidate geometry/obstruction; no clipping |
| 14. A; X and separate Y; P watches Y only | P observes Y, not X | X: B, C if clear | X can transition; Y stays | Separate membership; similarity is irrelevant | Observe X to hold it |
| 15. A; adjacent ordinary machinery turns while watched | P sees machinery, not X | B, C unless machinery blocks them | Machinery continues; X follows its own rule | Ordinary motion is not quantum membership | Inspect actual member/LOS, not nearby activity |
| 16. A; every alternative observed | R on B, I on C; no current observer | None | Stay A | Removing current observation alone is insufficient | Remove one candidate exclusion |
| 17. A; no alternatives observed | None | B, C | One legal random alternative, never both | One assembly-level choice | Reobserve and use exclusion if a specific state matters |
| 18. A; current inspection still active | I on A, R on B | C | Stay A | C's availability does not release current A | Remove I from A while preserving R |
| 19. A; player tries body-blocking I | I still reaches A | B, C | Stay A | Player collision does not occlude Beam | Use actual source controls or fixed geometry |
| 20. A; accidental exterior result with passenger | No current observer; B and C unobserved | B, C | If C selected, valid escape | The game cannot require a correct spoken hypothesis | Accept success; assess comprehension separately |
| 21. A; empty assembly goes exterior | R on B; no rider/current observer | C | X goes C, player stays safely inside | Passenger status was false | C must be inspectable/rearmable and recallable: case 24 |
| 22. A; preparing to board while observing | P or I on A; R on B | C | Hold A; no transport command required | Current observation is useful preparation | Board while watching, then remove last current observer |
| 23. B; recall to A | First R observes B to rearm; I observes C; then R off and P hides B/A | A | Transition A, with rider only if fully supported | C excluded; B is current; previous-state return permitted | Reach A via fixed walkway or ride; maintain view before boarding again |
| 24. C; empty recall to A from inside | I aimed at C first observes/rearms; R on B; then I off and P hides C/A | A | Empty X returns A | Real observation rearms a spent opportunity; B excluded | Approach A while observing; fixed access never depended on X |
| 25. C; player already dismounted outside | Optional P observes X | A, B if clear, but current sight holds | Player remains safe on fixed landing regardless of later X movement | Leaving the assembly is not an inventory loss or death state | Walk out; no forced return required |
| 26. A; only a cast shadow visible, every member/payload body hidden | No direct or artificial observer | B, C | Release may choose B or C under the ordinary budget/safety gates | S2: indirect shadow neither holds nor rearms | Actual member/Beam observation rearms later; audit shadow continuity as presentation |
| 27. A; participating hood hides Cube, hood interior visible | P sees hood member | B, C | Stay A | A moving cover is itself a visible part | Use independently fixed cover; redesign if none exists |
| 28. A; secured load visible, every structural member hidden | P sees restrained equipment | B, C | Stay A | Transported payload cannot visibly pop away | Hide full payload envelope |
| 29. A; completely dark but in LOS | Geometric P still observes A | B, C | Stay A under recommended contract | Illumination is not an A predicate | Real cover/looking away; do not add a darkness exception |
| 30. A; dark/unseen current assembly, I enabled on it | I observes A | B, C | Stay A under both A and B | Artificial observation survives darkness | Remove I; assess direct observation under selected contract |
| 31. A; passenger jumping/falling above support | No current observer; R on B | None if departure removes necessary safe support; otherwise C empty | Never capture an airborne rider | Grounded full support required; source safety still applies | Land fully while X is held, or reach fixed support |
| 32. A; player touches side while on fixed floor | No current observer; R on B | C empty if no overlap | X departs without player | Side contact is not support | Walk onto actual structural deck |
| 33. A; player stands on loose crate on cradle | No current observer | None while departure would remove safe support | Stay; no recursive attachment or dumping | Unsupported source occupancy is unsafe | Step off; this ambiguous arrangement is not approved authored content |
| 34. A; player stands on fixed floor touching cradle | No current observer; R on B | C empty if clear | X moves; player stays | Independent floor still supports player | Board if travel intended |
| 35. A; candidate surrounds player left on fixed floor | No current observer | Exclude that candidate; others only if safe | No teleporting geometry around/clipping the player | Nonpassenger occupancy remains in candidate world | Player leaves volume or uses another candidate |
| 36. A; departing member currently masks B envelope | No current observation; after vacating, P or R sees B | C if safe | B excluded | Departing geometry cannot be used as permanent candidate cover | Use genuinely fixed occlusion if B is intended |
| 37. A; fixed wall masks B | No current observation; fixed wall blocks P and Beam rays | B, C if clear | Either may be selected | Unrelated fixed wall remains a valid occluder | Reconfigure observation, not invisible tags |
| 38. A; B visually hidden before travel but mapped rider view sees participating B geometry | No current observer; C otherwise safe | C; B fails proposed arrival-safety check | Do not send rider to B in that pose | Conservative passenger arrival rule, not an existing global observer | Broader fixed arrival cover; unexplained rejection is a design defect |
| 39. A; two assemblies want the same vacant berth | No relevant observation | First may reserve legal berth; second must revalidate to none/other | No overlap or simultaneous swap assumption | Independent atomic commits share real occupancy | Wait or free the occupied berth |
| 40. A; ordinary machine uncovers current collar just before commit | P now sees A | Candidate set immaterial to release | Cancel, stay A | Current observation must be true at commit too | Reestablish full concealment and release interval |
| 41. A; another actor occupies C during grace; R on B | No current observer; R excludes B | None | Pending C discarded; no partial move | Candidate safety is live, not sampled once | Occupant leaves; fresh valid grace required |
| 42. A; visible member stays at same coordinates between two authored states | P sees that member | Other states may be spatially safe | Stay A | Membership is permanent, not selected by per-state displacement | Hide member; reject contrived invariant fragments during authoring |
| 43. C; X already used this uninterrupted unobserved period | No observer; R on B | A spatially legal | Stay C until real reobservation and later release | One successful move per release | Observe C directly or with I, then remove observation |
| 44. A; only one tiny exposed member edge missed by sparse probes | Player can actually see moving evidence | That authored envelope is invalid | Must not permit movement as a designed solution | Sampling must implement, not redefine, the readable rule | Repair proposed probe coverage/cover in future feasibility work |
| 45. A; passenger acquires full support after release timer already matured | R on B; no current view | Recompute C with passenger; fresh grace required | Never use stale empty-candidate clearance | Passenger status changed before commit | Keep X observed while boarding for predictable control |
| 46. B or C; recall controls reachable only across absent cradle | Any | No acceptable authored recovery configuration | NO-GO layout, not a new rule or reset action | Systemic recovery requires fixed access and reobservation paths | Revise the spatial plan before implementation |

The matrix exposes a limit of purely symbolic review: it cannot establish that actual sightlines, support margins and emitters will satisfy these assumptions simultaneously. That spatial proof and the player's understanding remain open.
## 9. Assembly identity evidence vocabulary

The primary evidence is a readable physical boundary plus reproducible shared behavior. Visual motifs alone cannot establish identity.

| Evidence | Strength | What it supports | Misuse to avoid |
| --- | --- | --- | --- |
| Continuous bearer from Cube mounting through cradle and collar | Strong physical evidence | A particular structure is one bounded object | Letting the bearer disappear into ordinary architecture without a visible break |
| Inspectable structural joints plus clear isolation at docking interfaces | Strong boundary evidence | Which adjacent pieces belong and which remain fixed | Using identical joints for connected and unconnected pieces |
| Holding different members in separate experiments holds the same assembly | Strong behavioral evidence | Observing any part constrains the whole | A hidden power switch masquerading as shared observation |
| A distinctive fracture spans two joined parts and preserves alignment between sightings | Strong identity corroboration | These are the same integrated parts across placements | Copy-pasting the exact damage onto unrelated assemblies |
| Several distinctive features preserve relative spacing/orientation across sightings | Strong combined evidence | Rigid identity rather than replacement by arbitrary lookalikes | Requiring ruler-level comparison or changing internal arrangement between states |
| Restrained equipment and its unique wear travel with the bearer | Strong corroboration of transported extent | The apparent object is larger than the Cube | Visible payload omitted from observation |
| Fixed docking scars align with moving bearing feet | Strong evidence of possible placement, not membership of the floor | The assembly occupied another real berth | Glowing footprints or destination pads that announce the solution |
| Shared unusual fabrication method | Suggestive | A technology family worth investigating | Claiming every similarly made machine is one assembly |
| Matching alloy, bolts or paint | Weak/suggestive | Common construction | Using color as a secret domain identifier |
| Flexible cable/hose | Evidence of service connection only | Power, fluid or signals may pass between separate systems | Treating it as an entanglement tether |
| Synchronized ordinary instrument response | Suggestive, causally ambiguous | A configuration may connect a service | Treating correlated output as proof of shared quantum membership |
| Plans, labels or photographs | Corroborative only | Where to compare physical evidence | Requiring a technical paragraph to define the assembly boundary |
| Adjacent wear marks or resting contact | Insufficient | Two objects have been near each other | Inferring that the ordinary floor or plate must travel too |

Use few recurring cues: continuous bearer, contrasting *construction* of isolation joints, distinctive damage, and fixed docking wear. Color can serve material plausibility but never be the only identifier. No HUD tags, selection outline, magic tether or animated instruction.

The player cannot watch a lawful transition happen. Identity evidence must survive **before-and-after comparison**. A valid behavioral test can leave an existing Beam on one participating member while the player inspects another, then remove that observation and compare the later state. Do not stage a visible transformation to make the rule easier to teach.

Every critical assembly must expose at least one traceable physical boundary and one independent identity comparison. If only a designer's scene hierarchy tells the story, it fails.

## 10. Simplified finale recommendation

### 10.1 Understanding is not a list of operations

The player must infer C's existence, the shared assembly, support-based inclusion, current observation and empty-position exclusion. They do not need to repeat a separate control gesture to prove each inference at the final berth.

Break TASK-031's sequence into:

- **Understanding:** recognize exterior C, recognize the assembly, know why B is unavailable and why a supported rider can travel.
- **Persistent physical conditions:** a real Beam observes B; C is safe and hidden; docking geometry provides fixed cover and a fixed exit landing.
- **Execution:** release current inspection if necessary, board, turn toward fixed cover, then walk out after arrival.

Waiting is an automatic world response. Arrival and reobservation are consequences of looking around, not buttons or required timing actions.

### 10.2 Recommended normal starting condition

B is an internal berth kept under a real inspection Beam R as part of ordinary facility operations. Its source, actual field coverage and service purpose must be inspectable earlier. It does not become enabled because an area was “completed.”

A is held by an accessible inspection Beam I. That hold makes the cradle reliably available before the player arrives. The source's ordinary power/aim control lies on a fixed approach from which the player can continue seeing A.

C has physical exterior receiving evidence and a safe landing. The player can leave the survey sightline and approach A without observing C. The hood is fixed structure, not a moving canopy.

Default informed execution:

1. **Remove I's current observation while keeping A in sight.** R continues to exclude B without requiring another control-panel visit.
2. **Walk fully onto the cradle and turn toward the broad fixed hood/wall.** The player removes their own last observation while remaining supported.
3. **After the ordinary transition, walk onto the fixed exterior landing.**

If earlier exploration has already left I off and the player currently observes A, the minimum is **board → turn toward fixed cover → walk out**. This is conditional on actual source state and occupancy, not a promise that the game will secretly restore a ready state.

An approach must preserve the view of A while boarding, so there is no race against the release interval. The hide position must be broad enough for normal looking, not an exact pitch/yaw coordinate. Same-orientation berths are preferred initially.

### 10.3 Why all essential knowledge still matters

| Knowledge | Causal role despite fewer gestures |
| --- | --- |
| Current observation holds | Explains why the player can keep A available after disabling I |
| Beam observation is real | Explains both I's hold and R's persistent effect |
| Observed empty positions are excluded | Explains why keeping R on makes C the sole alternative |
| Collar, cradle and Cube are one assembly | Explains why the arriving structure also aligns the physical route |
| Full support includes the player | Explains why boarding matters and touching a wall does not |
| Residual exterior evidence | Makes C an inferred destination rather than a blind gamble |

The I control is not an escape button. Operating it while continuing to observe X does nothing to configuration; releasing X without boarding can send it outside empty; removing R too admits B. Ordinary operations expose the existing laws.

No control condition is installed when the player has read a clue. Earlier restoration may really power R, but its current physical power/aim/occlusion must remain observable and reversible. If R is off, the player must deliberately restore its exclusion or accept both candidates. Do not secretly preserve its observation after its light/field has gone off.

### 10.4 No final reobservation choreography

One transition consumes the uninterrupted unobserved opportunity, so a rider need not instantly look at the Cube to keep the arrived cradle from bouncing away. Looking back naturally holds and rearms it. The landing must allow dismount without a precision timer, and source-support safety protects a partial step if the player rearms then looks away again.

This does not add a “stay until player exits” finale flag. The same release budget and support/occupancy rules apply in every proposed assembly encounter.

### 10.5 Recoverability remains physical

- **Empty C:** from a fixed internal position, aim I at actual C to reobserve/rearm, keep R on B, then remove I while A and C are outside player view. A is the only remaining alternative.
- **B:** fixed walkways keep controls reachable. Use R to observe/rearm actual B, aim I through a real aperture to exclude C, then turn R off and remove player observation. A is the sole alternative.
- **A:** seeing or inspecting A holds it for boarding. If a release was previously consumed, observing A legitimately rearms it.
- **C with player aboard/outside:** the fixed landing is safe regardless of later assembly state. Returning is optional to escape; inside recall must not depend on a player stranded outside operating a switch.

Those are logical requirements, not demonstrated architectural sightlines. A single emitter's real available aims and every fixed control position must satisfy the recovery table in the later paper test. If that cannot be arranged without hidden rays, inaccessible controls or walking over absent geometry, revise the layout.

### 10.6 What this cannot prove

No legal action sequence can guarantee a player's mental understanding: a novice may board, look away and receive C by chance. Rejecting that success would require the hidden knowledge check this design forbids.

The finale should **reward and express** understanding, not authenticate it. In a future test, ask the player to predict the result and explain what disabling R would change before revealing the outcome. Accept legal accidental escapes; report them separately from demonstrated understanding.

The compressed ending risks being too easy to stumble into. That is a content/evidence risk, not grounds to add tokens, a timed sequence, extra Beam stations or a finale-only rule.

## 11. Final truth test

Each statement below needs learnable nonmandatory-text evidence. “Proposed evidence” is not a claim that the current playable build supplies it.

| Intended statement | Experiment or environmental evidence | Assessment |
| --- | --- | --- |
| “The Cube was never merely moving inside the facility.” | The preserved Awakening Cube relocates as a singleton; it currently supplies no structural linkage evidence | **FAIL as an unqualified claim about the opening Cube.** Do not retrofit an unseen historical membership or deny the player's correct opening model |
| “It was the most visible member of a larger transport assembly.” | For a later demonstrably integrated Cube, follow its bearer; hold the collar with observation and compare Cube states; compare distinctive joints across placements | Conditionally learnable for that particular assembly. Not established merely because it resembles the opening Cube |
| “Some apparent architecture belongs to the same state.” | Participating frame carries unique damage to another fixed opening; observing it alone holds the same Cube; surrounding dock scars stay put | Conditionally learnable without text; depends on physical boundary and paired observations |
| “Observation has been holding those assemblies in internal configurations.” | Current internal inspection Beam prevents a change; removing it permits alternatives; fixed inspection hardware and wear corroborate long-running use | Present causal claim is experimentally learnable. Exact incident chronology or human intention remains an inference; do not require it as a puzzle rule |
| “A supported person can travel with them.” | Safe intentional boarding with repeatable departure/return, alongside secured-load evidence | Learnable by direct experience if support/arrival rules are readable; do not substitute a log saying people used it |
| “The apparent missing exit is an existing exterior configuration.” | Real exterior docking geometry and matching scars are visible from a fixed survey position; matching assembly identity can be compared after empty C arrival and recall; personal arrival confirms an ordinary exit | Conditionally learnable without a map solution; requires a survey/recovery sightline and distinctive spatial evidence |

Recommended truth wording:

> What I first encountered as a moving object is also a way this facility was built. This Cube, its cradle and its structural frame are one transport assembly. Observation has kept it in the internal berths. I can travel with it because I can stand on it. The outside landing was already one of its possible configurations.

“This Cube” must refer to the visibly integrated apparatus being investigated, not silently rewrite Awakening's singleton. The reveal is the scale and application of a trustworthy law, rather than “your first observation was false.”

The exact history of the whole facility cannot be proven by operating one device. Preserve the distinction between a mechanically demonstrated truth and a plausible historical reconstruction. If the player needs mandatory exposition to identify C, discover membership or learn support, the design fails. Optional records may deepen who did what and why.

## 12. Open risks and required design revisions

| Risk | Why unresolved | Required evidence before implementation |
| --- | --- | --- |
| Structural identity is still too obscure | Ordinary engineered equipment shares bolts and alloys | Unbriefed people distinguish one bearer from a cable-linked neighbor and a dock; no color coding |
| Strapped payload versus passenger support | A load can travel, yet standing on its nonstructural surface does not qualify | Players predict both cases or the rule/layout is revised; no invisible deck tag |
| Source-support safety feels like a new hidden lock | Partial boarding can hold an unobserved assembly | Draw the support footprint and independent landing for boundary cases; show the constraint follows physical safety, not a secret trigger |
| Airborne/source occupancy is under-specified for future movement abilities | Existing player cannot jump, but falling is possible | Use a conservative source volume: a body's vertical footprint onto a departing support must not lose its only safe landing; exclude acrobatic boarding from content, revisit before adding jump |
| Counterfactual sightline mismatch | Existing direct and Beam candidate queries do not share all exclusions | Paper diagrams explicitly remove only departing geometry; later feasibility must test both rather than reuse an incorrect shortcut |
| Mapped camera safety silently removes candidates | A future arrival view is not an observer the player can inspect from the source | Berth cover makes the extra veto redundant; if players cannot predict rejection, revise it before approving |
| Rigid model may not deliver the imagined scale of the mystery | A large object shifting placements can still read as a lift | Evidence must change the perceived identity of architecture and explain the missing connection; test the player's interpretation |
| Over-large assemblies never become fully hidden | Peripheral participating frames remain visible; cast-shadow popping is a separate presentation risk | Full current/candidate body-envelope drawings with broad hide positions, plus actual-light presentation review under S2 |
| Geometric observation in blackness feels unfair | Players equate darkness with blindness | No required encounter makes an unreadable object the relevant holding cause; validate readable contrast under intended display conditions |
| Recall geometry is only symbolic | I must actually reach A/C, R must reach B, and fixed walkways must remain available | Complete current/candidate views and control access for A, B and C, including empty arrivals and a spent release opportunity |
| Initial state or persistence becomes a hidden flag | A might be kept ready by an unexplained consumed timer or reset | Show the real observer holding A; retain actual power/aim/state through the encounter; no clue-dependent preparation |
| Simplified finale becomes a lucky ride | Fewer gestures also mean fewer opportunities to expose misunderstanding | Ask for predictions and explanations, not just completion; accept lucky success and redesign evidence if it dominates |
| Opening-revelation wording contradicts preserved content | Awakening does not show a moving chassis | Use the qualified truth above; do not assert absent membership |
| Historical certainty exceeds environmental evidence | Device operation does not prove all personnel outcomes | Keep essential conclusion physical; treat optional chronology as inference and identify corroboration later |

### Go/no-go recommendations

**GO, narrowly:** the logical statement “observe any member, hold the rigid whole; observe any candidate member, exclude that placement” is consistent with the core current-state and destination principles. It is suitable for further design testing, with the explicit candidate-query distinction above.

**REVISE — overall verdict:** do not approve implementation yet. Resolve direct support versus payload, source safety, concealed arrival, physical membership readability, the reduced finale's actual recovery geometry, and the opening-Cube wording. The recommended next design work must test these assumptions rather than treat them as established.

**NO-GO:** internal observers ceasing to count; a visible frame moving because its Cube is hidden; arbitrary remote membership; unrelated member transforms rolling separately; dropping passengers to pass collision checks; light-off release only in the finale; chapter/clue flags selecting configurations; inaccessible recall controls; or denying an otherwise legal accidental escape.

A future GO for implementation requires:

1. A complete noncontradictory state/observer/support table, including blocked and spent-release states.
2. Paper geometry showing all candidate, current and arrival views and safe returns with the same emitters.
3. Evidence that unbriefed participants can identify boundaries and predict the relevant cases without receiving the rule text.
4. A finale that uses ordinary movement/observation and at most the real preparation its current instrument states require.
5. An explicit approved choice of observation contract and acknowledgement of any new assembly-specific safety/query requirements.

No human sessions or new gameplay tests were performed for this review. It establishes definitions, conditional deductions and rejection criteria. It does not establish that the laws are intuitive or that the proposed sightlines fit a real scene.

## 13. Consequences for the task roadmap

TASK-033's assumptions materially change: distinguish the singleton opening from visibly integrated apparatus; provide evidence of rigid structural boundaries, payload extent and ordinary persistent Beam state; do not use darkness as release evidence or promise articulated/remote assemblies.

TASK-034 must compare the compressed finale against the earlier sequence, challenge support/payload predictions, and prove recall including real reobservation of empty exterior C. It must test A's geometric observation explicitly; a future B experiment belongs to a separately approved fork, not an unnoticed variation inside the same test.

These are acceptance constraints for future assignments. TASK-033 is not begun by this review.
