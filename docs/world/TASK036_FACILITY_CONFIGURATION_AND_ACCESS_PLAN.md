# TASK-036 — Facility Configuration and Access Plan

**Verdict: GO TO CONNECTED EXPLORATION PLANNING.** This is a paper spatial plan, not approval or implementation of final-world scenes. TASK-035's manual technical gates remain open. Human mystery readability is **UNVALIDATED**; no unbriefed sessions occurred.

## 1. Basis, precedence, and the implemented anchor

The proposal places one rigid object beyond the existing rear approaches, within a fixed inspection and service apron shared by the four research functions. The intended realization remains: “That apparent architectural frame belongs to the same object as the Cube. Its exterior placement was the way out.” The atrium, its plant, the opening chamber, receivers, observer mounts, and circulation never travel.

Read against the [core framework](CORE_MYSTERY_AND_KNOWLEDGE_FRAMEWORK.md), [law contract](COHERENT_ASSEMBLY_LAW_CONTRACT.md), [readability audit](COHERENT_ASSEMBLY_READABILITY_AUDIT.md), [evidence map](EVIDENCE_ARCHITECTURE_AND_MISINTERPRETATION_MAP.md), [world layout](WORLD_LAYOUT_AND_DISCOVERY_FLOW.md), [TASK-034 spatial proof](TASK034_SPATIAL_PROOF_AND_DECISION_GATE.md), [observation evidence contract](OBSERVATION_EVIDENCE_CONTRACT_REVIEW.md), [TASK-035 feasibility report](TASK035_COHERENT_ASSEMBLY_FEASIBILITY.md), and [architecture](../ARCHITECTURE.md). Later rigid-membership and direct-geometry decisions take precedence over the framework's broader historical proposals. Historical statements that assembly implementation is unapproved predate the authorized isolated TASK-035 work; they do not authorize world integration now.

Source inspection also covered the current [Awakening scene](../../scenes/world/opening/awakening_chamber.tscn), [atrium](../../scenes/world/hub/operations_atrium.tscn), [sealed approach](../../scenes/world/hub/sealed_wing_approach.tscn), opening/hub restoration scripts, and the actual assembly, Beam, Beam switch, and player implementations.

### Current coordinates and boundaries

All following coordinates use **atrium-local Godot axes**: x east, y up, z toward the rear approaches. Plan drawings put +z at the top. To obtain current Awakening world coordinates, add `(0,0,6)`. This explicitly replaces TASK-034's unrelated paper coordinates; no historical SVG is a measured plan of this hub.

| Implemented element | Observed geometry or behavior | Planning consequence |
| --- | --- | --- |
| Awakening | Floor 14 × 12 m around its own origin; bulkhead at world z=5.86 | Opening remains a separate truthful singleton experiment |
| Hub instance / vestibule | Hub root world `(0,0,6)`; vestibule local z=0..4, nominal width 3.6 m | Preserve level access and familiar return silhouette |
| Atrium shell | Nominal x=-12..12, z=4..24, ceiling about 7 m; floor extends slightly beyond shell | Existing hall is the fixed reference, not an assembly envelope |
| Circulation plant | Fixed maintenance base 4.8 × 4.6 m centered `(0,0,15)`, with manifold and risers | Retain both routes around it |
| Records / Power entries | `(-12,0,10)`, yaw -90° / `(12,0,10)`, yaw +90° | Reserve western/eastern continuations; do not rotate or swap the functions |
| Containment / Signal entries | `(-6,0,24)` / `(6,0,24)`, both yaw 0° | New shared apron belongs beyond these stubs, not inside the existing hall |
| Each approach | About 4.3 × 6.3 m; noninteractive gate at local depth 3.8 m; solid back wall at depth 6 m | Opening a gate alone would not produce a through-route |
| Existing equipment behind gates | Archive cabinets, exchangers, fixed `ContainmentTransferCradle`, Signal racks | These remain ordinary equipment. In particular, the existing transfer-cradle prop is not retrospectively a quantum member |
| Current restoration | Service handle powers local systems/Beam; load relay's activation drives hub bulkhead restoration; opened access stays open | The older TASK-030 description of a single service-handle signal is historical. No new wing unlock signal is proposed |

The current world ends at those four seals. The proposed connected version will require a separately authorized **static content edit** at each approach: park the gate clear, replace its rear closure with a passage, and put obstructing display equipment beside a continuous clear walking lane. Reserve at least 2 m clear width through the continuation. The Containment cradle and its guards currently obstruct that centerline; moving only the gate is specifically insufficient. Keep the display prop as fixed equipment in an adjacent work recess. Do not make these changes now or turn them into four gameplay restoration tasks.

## 2. Fixed facility and one travelling object

### Fixed facility

Reserve functional space, not four enclosed challenge rooms:

- Records continues west of the hall toward a live inspection view at `(-11,35)`.
- Power continues east toward B and R through an ordinary maintenance passage.
- Containment occupies the A workface beyond the rear-left approach.
- Signal occupies the survey/observer workface beyond the rear-right approach and shares access with both A and B. Its survey position extends west of the hub centerline; functional names do not define mechanical territories.
- A common apron centered near z=32 connects those approaches. A fixed passage east of A reaches the survey edge at z=42. Neither route crosses a receiver recess.
- A fixed pier at x=-0.5..0.5, z=36..41, at least 3.4 m high, supplies a near reference and separates oblique internal views. It does not span or obstruct the shared apron at z=32.
- The 4 m-high exterior boundary is at z=43. Exterior ground starts at z=46. Between them is a service separation with physical parapets, not an invisible wall or a repairable bridge.

The internal floor extends around A and B, except their explicitly recessed receiving beds. Clear circulation is reserved before dressing is added. The exterior is a separate fixed component: C connects a passenger to it, but never supplies its floor. There is no ordinary interior walking edge to C.

### Authored travelling boundary

Use TASK-035's one-root, four-member structure as the initial integration envelope:

| Member | Local envelope / evidence treatment |
| --- | --- |
| Cradle | Existing 4 × 4 m rectangular structural deck, x/z=-2..2, top y=0, bottom y=-0.2; direct bearing surface |
| Cube | Existing approximately 1 m body centered `(0,0.65,-1.2)`, structurally integrated into bearer |
| Bearer | Continuous front chassis near z=-1.9; expose its connection to Cube mount, deck and collar |
| Collar | Posts near x=±1.75, z=-2; lintel near y=2.9; fits the fixed receiving work opening without being welded to it |
| Travelling signature | An asymmetric gusset and repaired joint crossing the collar/bearer connection; keep these within the front member envelope and preserve their geometry at all placements |

The joint is relief and construction, not a painted symbol or a glowing clue. Do not duplicate its exact repair on a receiver. A low service line may approach a fixed contact housing, but no permanent cable ties the travelling bearer to the building. No active service-connection rule is needed.

On first encounter the collar aligns with ordinary jambs and reads plausibly as a threshold. The underside bearer, independent receiving feet, and side clearance are already inspectable. Nothing reveals a new seam later. The fixed pier's broken edge and receiver wear remain after departure; the repaired joint does not. Observing the joint or collar holds the same object as observing the Cube.

The broad deck, its visible thickness, and a 5 cm side docking gap distinguish support from adjacent floor. No transported rear canopy, railing, prop, or payload is added without extending current/candidate probes and repeating concealment checks. The hood's supports visibly descend into the fixed bed outside the deck.

## 3. Placement schedule

Origins are planning reservations, not edited scene transforms. All root bases remain identity: **no yaw, pitch, roll, or scale change**. The collar faces toward -z; the rear fixed concealment wall is toward +z.

| Relationship | A — internal inspection | B — internal return/service | C — exterior transfer |
| --- | --- | --- | --- |
| Root `(x,y,z)` | `(-6,0,38)` | `(6,0,38)` | `(-6,0,50)` |
| Collar front | Around z=36 | Around z=36 | Around z=48 |
| Fixed context | Containment work opening beside the shared Signal access; Records view on its west | Power/Signal service receiver, independently supported pipes and maintenance floor | Outside receiver beyond survey boundary, against an independent exterior buttress |
| Receiver | Recess below deck, independent side landing and hood; stationary pier to east | Same docking clearances; different fixed plant context, not an identical lobby | Same rigid fit and hood clearances; independent side landing joins onward exterior ground |
| Fixed approach | Hub rear-left → apron → east landing; also Records lateral access | Hub east/rear-right → apron → east landing; fixed walk back to A | Interior reaches survey/I only. Exterior receiving landing is reached as passenger; all inspection/recall controls stay inside |
| Passenger access | Cross east seam near local z=0.8; walk centrally to rear supported region | Same mapping and clear crossing; step onto fixed landing and walk to R/hub | Same arrival pose; turn back, cross west side seam to fixed ground; onward path starts immediately |
| Observation opportunity | Whole apparatus, collar-only window, fixed-pier comparison, direct inspection while boarding | Whole apparatus from independent maintenance floor; different view of same signature; vacant B under R | Early survey window shows receiver/landmark/onward ground; actual C can be directly reobserved or reached by I |
| Beam relationship | I in A aim holds/rearms actual A | R persistently covers actual or prospective B | I in C aim reaches actual or prospective collar through the real aperture |
| Recall | Actual sight/I holds A for inspection; release has B/C alternatives according to current constraints | R rearm/hold, I excludes C, then release R and own view → A | When empty: I rearm/hold C, R excludes B, then I off and hidden internal view → A |
| Initial reading | A fixed service frame beside a specimen machine | An idle plant interface or a second frame | Unused transfer hardware, possibly a missing connection |
| Reinterpretation | The frame is a member; the work opening merely receives it | One travelling signature fits different fixed machinery; power connection is not membership | The familiar bounded object has a real outside placement and ordinary ground beyond |

### Receiving section and access clearances

Retain a rectangular `BoxShape3D` bearing surface. TASK-034/P2's rounded tongue and its ±20° / down-15° proof are **not** implemented by TASK-035's box support evaluator and are not imported into this plan.

At each root, reserve fixed hood side panels at local x=±2.4 (inner faces ±2.3), local z=1.6..2.8; rear wall inner face z=2.6; roof underside y=2.4. These match the useful TASK-035 fixture relationships. Their supports are outside the moving member volumes. Surrounding equipment may differ by berth, but never intrudes on those clearances.

The fixed bed top is y=-0.55, leaving 0.35 m below the deck underside. Side landings begin at local |x|=2.05 and have at least 1.9 m of clear width. Ordinary boarding crosses near local z=0.8, before the hood's side panels start. Reserve a crossing center band z=0.65..0.95: even its rear edge has 0.25 m capsule clearance to the hood mouth for radius 0.4 m. The Cube ends near z=-0.7, well ahead of this crossing.

An empty recess must not trap a player with no jump. At A/B, provide a fixed front inspection ramp outside the assembly envelope, local x=-0.8..0.8 and z=-4.8..-2.8, descending from floor 0 to bed -0.55; a low bed extension joins it to the recess. At C put this maintenance egress on the **west** side, local x=-4.8..-2.8, z=-1.7..-0.3, with the equivalent low connection. A front C ramp would approach the service separation and is deliberately not used. None is a required investigation path or a boarding ramp. An occupant in a recess invokes ordinary candidate collision rejection.

## 4. Fixed access graph and state independence

All arrows in this section denote ordinary bidirectional walking unless stated otherwise. Graph vertices are work positions, not collectible checkpoints:

| Vertex | Approximate anchor `(x,z)` | Function |
| --- | --- | --- |
| H | Existing atrium loop | Return to vestibule/Awakening and all four approaches |
| W / E | Records / Power continuations | Alternate western/eastern working routes |
| J | Shared apron around `(0,32)` | A↔B comparison route, at least 2.4 m clear |
| I-control | Standing area `(-1.8,32)` | Power and aim of fixed I source |
| A-landing | Center near `(-3,38.8)` | Independent inspection, boarding and safe dismount |
| D | `(-11,35)` | Records/Containment collar-only view from fixed ground |
| V | Approximately `(-2,35)` to `(-2,42)` | Fixed survey passage east of A, west of central pier |
| S | `(-2.8,42)`, eye about y=1.5 | Early exterior view |
| R-control | Standing area `(10.7,32)` | Fixed R power control |
| B-landing | Center near `(9.2,38.8)` | Independent B inspection/dismount |
| C-landing / O | West side of C, then outward | Separate fixed exterior safe ground and onward route |

Edges: H–W–D–J–H; H–E–R-control–J; H–Containment–J; H–Signal–J/V; J–I-control–A-landing; J–R-control–B-landing; J–V–S. The apron passes south of the central pier. At I, the northbound route detours west of the emitter mount through approximately `(-3,34)`, joining V at `(-2,35)`; it does not walk through the source at `(-1.8,34)`. At R, the landing approach uses x≈9.2, away from the source at x=10.7. Controls have standing recesses outside through-lanes.

| Actual assembly position | Interior fixed component still reaches | State-dependent edge removed from required circulation? |
| --- | --- | --- |
| A | H, W, E, D, J, I, R, both internal landings, V and S | None; occupied A is beside the route |
| B | The same vertices, including empty A inspection | None; occupied B is beside the route |
| C | The same vertices, both empty internal receivers and C survey/rearm | None; no interior route uses the missing assembly |

Proof: the required edges avoid the union of all three member footprints and both internal receiving recesses. Removing the assembly from the drawing does not remove any listed floor edge. I/R controls are on the apron, not attached to X or on a receiver. The hub is reachable from either internal landing without a ride.

The exterior component has safe dismount and onward access for all later assembly states. It intentionally has no fixed walking return to H: otherwise an ordinary interior route could already reach outside. A passenger at C can return while still using the assembly (§8), but post-escape hub investigation is not a required fixed-world task. This is the explicit boundary of the state-independent interior-access claim.

## 5. Inspection Beam I and return Beam R

Use the existing Beam and the existing power/aim switch capabilities. No source selects a destination. Aim changes point one source at a different real envelope; it never observes A and C simultaneously.

| Source / mode | Emitter origin | Target point on collar | Fixed occlusion and clearance | Player access / absent object |
| --- | --- | --- | --- | --- |
| I → A | `(-1.8,2.6,34)` | `(-4.25,2.6,36)` | Short southeast-to-northwest ray reaches A's upper right post before hood; Records screen is west of it | Power/aim cabinet near `(-1.8,1.15,32.9)`; player stands at z≈32. Field continues through vacancy to ordinary fixed structure; a prospective post still excludes A |
| I → C | Same source | `(-4.25,2.6,48)` | East of A's entire hood; through boundary aperture, then to C's upper right post | Same fixed cabinet, no remote exterior button. Empty C can be excluded; occupied C can be held/rearmed |
| R → B | `(10.7,2.6,34)` | `(7.75,2.6,36)` | Reaches B's upper right post before its hood; central pier may stop the field farther along after the target | Cabinet near `(10.7,1.15,32.9)`. Vacant B remains under a visible inspection field; no arrival is commanded |

Normal authored state: X at A, I on/A aim, R on/B. The sources' physical service purpose is inspection of a held workpiece and a clear return interface. R's persistent state is visible and reversible; it is not enabled by completing Power. Ordinary pipes, lamps and gauges do not become observers.

Targets deliberately coincide with TASK-035's existing `RightPostUpper` probe at local `(1.75,2.6,-2)`. A narrow field at the older paper height 1.6 m could hit rendered post geometry but miss every current collar probe; that is not accepted as working observation. Raise the fixed source and aperture reservation to cover the actual probe, while keeping controls at normal interaction height. Probe coverage remains a later rendered audit, not player-facing lore.

Reserve a 0.62 × 0.62 m Beam volume and 20 m range, as in existing tunable parameters. I→C is about 14.21 m to the target. Its horizontal centerline is `x=-1.8-(2.45/14)*(z-34)`. Using a conservative ±0.32 m horizontal/vertical field allowance:

- Across A hood z=39.6..40.8, center x ranges -2.78..-2.99. The nearest field edge is x≈-3.31, clearing the hood's east outer face x=-3.5 by about **0.19 m** at the tight end.
- At boundary z=43, center x=-3.375. Reserve aperture x=-5..-2.6, y=1.15..3.1. Full field bounds x≈-3.695..-3.055, y=2.28..2.92 fit, with at least **0.18 m** vertical allowance and **0.45 m** horizontal allowance. The lower portion retains ordinary eye-height survey access above the protective sill.
- Through the A depth, the C ray is east of A's participating geometry, even when A is present. Removing source-pose member colliders therefore cannot reveal a previously unaccounted route through X.
- I→A misses B/C; R→B misses A/C. Beams can reach another part of their intended assembly before the target point without changing the result: any member counts.

These are paper clearances for reserved geometry. No later pipe, screen, curtain, emitter housing, or aperture trim may occupy the field corridor. Do not compensate for an obstruction by excluding fixed colliders from Beam queries. The larger TASK-035 hood is why I is farther east than in TASK-034/P2.

Changing I power while looking at its cabinet can leave A's upper post visible to the left: from the standing position its horizontal offset is approximately 32°. Preserve that open view throughout the control/boarding path. This is a geometry requirement for later rendering, not a promise that every gaze direction holds A. A player choosing to look away may lawfully send the assembly empty; recall is available.

## 6. Early exterior evidence and the diagnostic comparison

S is reachable directly through Signal or the shared apron before an assembly ride or any research visit. Its aperture shows C's receiving contact span, an asymmetric clearance fitting the bearer, an independent buttress near `(-10,0,54)`, and west-side onward ground. A physical sill/parapet prevents walking through the opening. The 3 m service separation is visible. Do not add broken bridge hinges, an item socket, or an inaccessible repair button that promises a conventional construction solution.

The C collar is about 6.2 m from S; the body and onward ground are approximately 6–11 m away. A roughly 0.45 m structural signature would subtend around 2.3–4.3° across that range. That is a paper scale check, not human recognition evidence. At S, actual C sight holds/rearms it; sight of its prospective members excludes it. Looking through a window is not exempt observation.

From S to C's right post, the line crosses z=43 at x≈-3.04 and eye height. A ray toward onward ground near `(-9,0,51)` crosses at x≈-3.49, y≈1.33. Both pass through the scheduled aperture. The exterior contacts and floor exist from the first connected-world visit. Occupied C supplies the unique repaired joint; the empty receiver supplies fit evidence but is not proof by itself.

For an isolated non-Cube comparison, reserve an independent west inspection screen at A-local x=-2.6, z=-3.8..2.8, y=0..3.4. Its opening is local z=-2.6..-1.7, y=1.8..2.65. From D=A+`(-5,1.5,-3)`, the ray to the upper left post A+`(-1.75,2.6,-2)` crosses the screen at local z≈-2.26, y≈2.31. The Cube, bearer and deck lie below eye height, so their rays cannot pass this raised sill. The opening presents a substantial upper collar segment without a reticle alignment.

Unlike a literal copy of P2's window, this opening accounts for TASK-035's closer Cube-to-collar spacing. The screen lies outside the assembly volume and is reached around its south end from J. B's high collar rays cross too far south of this aperture; lower members are below its sill. C is behind the fixed exterior wall west of its survey opening from D. With I off, R unchanged/on B, and C safe, looking at the collar holds/rearms A; turning west at the same fixed position hides all placements and permits empty C. No control or position trigger changes between those views. An unseen active I would invalidate the causal comparison and must be recorded as such.

## 7. Passenger preparation, release and arrival

Keep the existing rectangular bearing model and the full player's observer role. Cross A's east landing at local z≈0.8 while viewing a member, move centrally on the deck, and turn toward the independent rear hood. No stance or head coordinate is enforced by gameplay.

A conservative paper release region is local **x=-0.6..0.6, z=1.1..1.4**, facing +z with **yaw ±15° and pitch level through 25° upward**. This is an analytical region for validation, not a painted spot or a support trigger. The entire deck still provides passenger support wherever the current footprint checks succeed.

For the current radius-0.4, height-1.8 player, every center in that region has at least 0.2 m rear footprint reserve, 1.0 m lateral deck reserve, 0.8 m rear-wall body clearance, 1.3 m side-wall body clearance, and 0.6 m head clearance under the hood. A same-orientation translation gives the same support and clearance at every berth.

The provisional direct-geometry argument uses eye height 1.5 m, vertical FOV 75°, 16:9, and the existing 10% viewport guard. For level pitch, the nearest visible deck-plane intersection is at forward distance `1.5 / (1.2*tan(37.5°)) ≈ 1.629 m`. Across the whole stance/yaw range, the farthest deck projection in front of the eye is at most `2.6*sin(15°) + 0.9*cos(15°) ≈ 1.542 m`. Thus even the outer rear corners lie below the guarded view, with about **0.087 m** conservative reserve. Upward pitch increases that reserve. At the upper pitch/yaw extremes the guarded rays still point toward +z, while Cube, bearer and collar remain behind the eye. C is behind A's fixed rear hood, and the other internal placement is outside the forward guarded view. This uses actual member bounds, not missing probes.

From B's supported region, C is oblique to the northwest rather than directly behind its rear wall. Rays to C intersect either B's west hood panel within z=39.6..40.8 or its rear wall at z=40.6; their intersection heights remain below the 2.4 m wall tops. From C, both internal candidates are behind the +z-facing player. Those fixed occluders remain in source-vacated queries. This completes the candidate-view check for optional B/C rides as well as the normal A departure.

This paper window establishes a nonzero, usable family of poses. It does **not** establish comfortable walking or arbitrary downlook concealment. A deeper downlook can expose the rectangular deck and lawfully hold the assembly; P2's down-15° guarantee is not claimed. Normal downward inspection, adjacent stances, aspect ratios and rendered peripheral slivers belong to the manual gate. If ordinary play requires finding an exact posture, revise physical cover/geometry before integration; do not clamp the camera or exempt a passenger. A proposal to restore a compound tongue would require explicit support-evaluator work beyond current TASK-035 capability.

Normal informed final execution: retain R's B observation; remove I's current observation if needed while keeping a real member in view; board; conceal the whole current object while fully supported; arrive at C; look back and walk across the west seam onto fixed ground. C is the only legal alternative in that source state. There is no time limit, final control, clue flag, or final-only reveal. A lawful early/lucky supported C arrival remains valid.

On arrival the opportunity is spent, so the player can pause. Looking back then holds/rearms the assembly during ordinary dismount. Straddling the seam waits under partial-support rejection. Once fully off, the player's floor remains even if the empty assembly later departs. No extra cargo or receiver detail may intersect the mapped capsule or a member; the complete candidate must pass before either root or player moves.

## 8. Recovery and source-state table

In this table “hidden apron view” means facing toward -z from the I/R standing recess at z≈32, with A/B/C all north of the guarded view. It does **not** mean turning south at S, which can expose A. “Rear cover” means the supported region in §7. All assumed candidates are unoccupied and collision-clear.

| Situation | Fixed access / preparation | Genuine rearm and maintained exclusion | Release / result / safe next step |
| --- | --- | --- | --- |
| A current, player inside | Reach A/I from J in any state | Actual A sight or I→A holds/rearms; R on excludes B | Board and hide with I off → C; or stay on fixed floor for an empty experiment |
| B current, player inside | J reaches R and I without entering either receiver | R on actually observes B; then walk to I and set I on/C; R holds B during that walk | Return to R, switch it off, take hidden apron view → only A legal. See actual A afterward to hold/rearm |
| Empty C, player inside | J/V/S can inspect C; J reaches I and R | R on excludes B; I on/C actually reaches C and rearms it, including a spent C arrival | At I switch power off, then hidden apron view → only A legal. Do not leave I aimed/on A, which would instead exclude the desired return |
| Passenger arrives at B | Look back at real B, cross seam onto fixed landing, keep a member visible along approach to R | Turn R on while B remains in view; use the preceding B procedure | Walk back to A by fixed floor after empty recall. No forced second ride or fast interaction is needed |
| Passenger arrives at C | Pause, look back, then dismount to fixed exterior landing | Actual C sight rearms/holds while crossing; R/I remain whatever physical state allowed arrival | Walk onward safely. For a voluntary return, stay/reboard while C is present, reobserve actual C, then use rear cover; a legal internal alternative remains |
| Player on fixed ground, X elsewhere | Interior H/J/I/R/D/S graph is intact | Find actual B via direct view/R, or actual C via survey/I; an empty A view does not rearm either | Follow B/C recall above. No reset or inaccessible source is needed |
| All alternatives observed | Controls remain reachable on J | Maintain actual current sight/source while inspecting constraints if desired | Remove one actual exclusion, then remove current observation; no move is owed while all alternatives remain blocked |
| Split support or blocked passenger arrival | Complete boarding/dismount safely; fixed circulation remains | Support is a safety condition, not another observer | Wait/revalidate; do not drop rider, snap them, or consume the opportunity on a failed candidate |

For the optional C return, no exterior remote controls are assumed. An actual C arrival required its prior current placement to be unobserved at departure. With the same static world and unchanged I/R states, that now-vacant prior placement can be available again; the assembly has no previous-state ban. After actual C reobservation, the concealed supported pose admits a return to at least one safe internal placement. With I off/R on it is A; with I on/A and R off it can be B. Both internal landings offer fixed access to all controls. After dismounting and allowing the assembly to leave C empty, a guaranteed recall from outside is not supplied; the player already has the permanent onward exit and no required interior task.

No return procedure uses a source as a call button. With current sight retained, switching a Beam cannot move X. Watching a candidate excludes that place; it does not attract X there. Spent opportunities require actual-member or actual-Beam reobservation, never a remembered state or a photograph.

An inspection can itself enable an earlier return: viewing C from S rearms it, and leaving that view with I off/R on may send it back to A before the player reaches a control. That is already a successful empty recall. Inspect the actual new state and continue; do not demand the table's control gestures after their purpose has been achieved or silently hold C during the walk.

## 9. Editor-independent diagrams

These twelve author-facing diagrams describe one proposal. Coordinates and clearances above govern; diagrams are schematic and not to scale. No participant cards or in-game labels are created.

Legend used throughout: `F` fixed structure; `X` actual travelling assembly; `<A?>` etc. prospective envelope/receiver, not a second object; `P` player; `v-->` player view; `b==>` Beam; `O` fixed occluder; `r` independent receiver/landing; `===` fixed walking route. Dotted transport/sight annotations are never floor. +z is up in plans, +x right.

### D01 — Fixed facility circulation

```text
                  F outside ground === r C === onward
                              <C?>
              service separation: NO WALKING EDGE
 z43  F boundary -------- survey aperture -------- F
                           S
                           || V
              r A <A?>     || F pier       <B?> r B
              ||           ||                ||
 Records == D || == I ==== J ============== R == Power
    ||          Containment   Signal                ||
    ||               ||         ||                  ||
    ===== west === [ OPERATIONS ATRIUM ] === east ====
                     F plant / two routes
                             ||
                       F vestibule
                             ||
                        Awakening
```

### D02 — A inspection relationship

```text
 z40.8           O fixed hood, independent supports
                 +-------------------+
                 |     X rear deck   |    V === S
                 |       P           |    ||
                 |     X cradle =====r====||  fixed east landing
                 |     X Cube        |    ||
 D P v--> [O high | X collar/bearer    |    || F pier
           window]-------------------+    ||
               r recessed bed / front egress ramp
                  J ===== I-control ===== J
```

The window is west of the collar; the rear hood is independent fixed architecture. The deck is a side investigation choice, not the A↔B through-route.

### D03 — B service relationship

```text
                O fixed hood       F plant pipe supports
                +-------------+    (outside X)
                | X rear deck |          ||
                | X cradle ===r==========|| B landing
                | X Cube      |          ||
                | X collar    | <==b R source
                +-------------+          ||
                 r bed/ramp               ||
              J ===================== R-control === Power
```

This is B occupied, so R would hold it. For an allowed arrival R must not reach B; its control remains accessible either way.

### D04 — C exterior relationship

```text
 F buttress landmark                 O fixed hood
         |                      +-------------------+
 onward === fixed ground === r == X deck / cradle  |
                 west egress    | X Cube / collar   |
                                +-------------------+
 z46  --------- fixed exterior ground begins ----------------
                 open service separation
 z43  F parapet ===== [survey / Beam aperture] ===== F wall
                            P S v--> C
                            ||
                            V === interior apron
```

C is a receiver before it is occupied. No bridge appears across the separation; the whole rigid object acquires a different relationship to fixed ground.

### D05 — A ↔ B fixed walking access

```text
 <A?> rA                          rB <B?>
       ||                          ||
    A-landing                      B-landing
       ||       F pier north        ||
       ||       of this route       ||
       I ======== J ================ R
                 ||
          fixed return to H
```

The same edges exist with A occupied, B occupied, C occupied, or X erased from this drawing. The nearest boarding crossings are at z≈38.8; the shared apron is south at z≈32.

### D06 — A / C inspection relationship

```text
          <C?> at (-6,50) ---- F landmark / onward ground
               ^    ^
               |    : player view from S
 z43  F wall --[ aperture ]---------------------------------
               |     P S(-2.8,42)
      O A hood |     || V (fixed access)
       <A?>    |     ||
 D v--> collar |     || F pier
               |     ||
               I ====J
```

The C line runs east of A's hood. The survey view does not need A occupied. A broad vacant-receiver view and the collar-only window serve different comparisons.

### D07 — Beam I, two physically distinct aims

```text
 C upper post (-4.25,2.6,48)  <==b===================.
 z43 aperture [-5,-2.6], y[1.15,3.1]                |
     field center x=-3.375                           |
 O A hood east face x=-3.5   [clear corridor]         |
 A upper post (-4.25,2.6,36) <==b==.                  |
                                  I(-1.8,2.6,34) ---'
                                  || fixed mount
                            P / power + aim cabinet
                                  J
```

Only one aim is active. Full-width corridor checks are in §5; lines are not rays through a solid wall or remote coupled sources.

### D08 — Beam R, persistent B observation

```text
          O B hood
          r <B?> upper post (7.75,2.6,36)
                    ^
                    b
                    ║  clear field before any fixed backstop
                    R source (10.7,2.6,34)
                    |
          J === P / R power cabinet === Power
```

Actual B: hold/rearm. Empty B: exclusion. When nothing occupies B, the field still reaches the future post location and continues to fixed structure beyond; R does not summon an object.

### D09 — Boarding and fixed concealment, plan + section

```text
 PLAN (assembly local)                SECTION (looking along +x)
 z2.6 O rear wall                     y2.4  O fixed roof
      | X deck ends z2 |                        P eye -> O wall
      |  P release    |                y0   X structural deck  | O
      |  x +/-0.6     |                     visible air gap    | O
 z0.8 | <-- board ====r fixed landing  y-.55 F receiving bed ___| F
      | X Cube        |
 z-2  | X collar      |                hood support outside X
```

P crosses the side seam while looking at a member, then turns toward +z only after full structural support. The stance and view ranges in §7 are analysis bounds, never a snap zone.

### D10 — Final exterior arrival and dismount

```text
 A supported P, facing fixed hood
          . . . one atomic root + actual-relative-pose transfer . . .
 C: O hood <-v P on X cradle
              |
         turn back: v--> actual X holds/rearms
              |
       walk west across r seam === F onward ground === outside
              |
       partial support waits; fully off never carried
```

The arrival is concealed by ordinary geometry/orientation under the same view contract. No camera cut, head rotation, outside gate, or urgent dismount supplies success.

### D11 — B recall, controls reached on fixed floor

```text
 [actual X at B] <==b R ON  (genuine rearm + hold)
                        P at R
                        ||
                    J ===== I: ON, aim C  b==> <C?> excluded
                        ||
                    P returns to R on same fixed route
                        |
                    R OFF; P v--> south from z32
                        |
                 A only legal -> X at A, B receiver empty
                        |
                   fixed walk J === A; observe actual arrival
```

For a passenger at B, first dismount while viewing X and reach R; no invisible hold maintains B during preparation.

### D12 — Empty C recall

```text
 [actual X at C] <==b I ON/C through aperture (real rearm + hold)
 [empty r B]     <==b R ON                  (candidate exclusion)
                         P at I on fixed J
                                  |
                     I power OFF; P v--> south from z32
                                  |
                        A only legal -> empty return to A
                                  |
                    turn to see actual A; board or inspect
```

Turning away from the survey at S alone is not this proof: it may expose prospective A. Release is performed from the reachable south apron with all candidate body geometry out of the actual view.

## 10. Research functions and nonlinear discovery

| Function | Physical evidence / plausible first interpretation | Later revision and overlap |
| --- | --- | --- |
| Records | Live raised view of a frame beside a fixed screen/pier; optional past survey material | Collar-only hold challenges Cube-only control. Walk around to inspect its bearer; no reading supplies the rule. A and B repeat the identity evidence |
| Containment | Apparent architectural surround, continuous chassis, broad support and independent landing | A boundary within architecture explains shared observation. The inward repair invites boarding, but can also be inspected from fixed floor |
| Power | Fixed pipe supports, B receiving contacts, persistent R field, ordinary service control | A cable or service fitting is not membership; watching vacant B prevents its use. Signal-side access also exposes B/R, so touring Power is optional |
| Signal | A/C sightline, real Beam paths, early exterior contacts and landmark | A watched vacancy is constrained; the exterior fit belongs to the same object. Containment's shared apron offers the same essential survey and controls |

| Interpretive route | Viable fixed path and experiments | What can be skipped |
| --- | --- | --- |
| Architecture-first | H→Records/D→around screen via J→A; compare bearer and fixed pier, test non-Cube sight with I accounted for; J→B or V→S supplies changed context | Reading, Power work pocket, prescribed internal ride |
| Observation-first | H→Containment/J→I/A; distinguish I hold from own collar view, compare all alternatives excluded with one open; inspect B/R from shared apron; V→S | Records and any narrated history; no mandatory failure sequence |
| Exterior-first | H→Signal/V→S; inspect receiver and onward ground first, then I/A and B for fit; send C empty, actually reobserve and recall, then choose a supported experiment | Records, a full wing tour, and a forced B ride |

These are available evidence paths, not scheduled events. Every essential inference has live geometry on the shared workfaces. No visits, move counts, restore-all state, or correct hypothesis are checked. A person may reach C on their first supported release; record whether they predicted it rather than forcing an internal lesson first.

## 11. Anti-elevator audit

| Proposed relationship | What a conventional lift could reproduce | Required physical/causal distinction retained here |
| --- | --- | --- |
| A threshold and specimen | A platform carrying equipment | The apparent fixed collar alone holds the hidden Cube; a neighboring independent wall does not. The seam and continuous bearer were present before movement |
| B service interface | Another landing and a call control | R on at an empty receiver excludes it. R off cannot call B while current A remains seen; no button chooses a floor |
| C outside relationship | Transport outside | The receiver, landmark and onward ground were already visible. The same repaired object fits it; observation leaves C available rather than unlocking an exit |
| Supported travel | Standing on a moving deck | Boarding does not start movement or cancel sight. Fixed versus travelling cover matters, and the apparatus also moves empty |
| Research circulation | A sequence of transport lobbies | The entire internal investigation graph works without the assembly. Different functions provide overlapping views of one anomaly; no station owns a lesson or progression lock |

Paper result: “call → stand → choose outside” is insufficient to predict the planned comparisons. Calling it an elevator remains acceptable vocabulary. Whether players actually revise their earlier architectural boundary judgment is still a human test, not a deduction from these diagrams.

## 12. Implementation compatibility and manual gates

| Actual TASK-035 constraint | Planning response / future acceptance test |
| --- | --- |
| One rigid root, fixed member transforms | Same orientation at all origins; signature is authored once. Verify it does not acquire berth-specific art or collision |
| Full member current/candidate probes | Collar window, vacant B, and C survey obey the same envelope. A visible unsampled edge is a defect, not an allowed shortcut |
| Source-vacated candidate queries | All clearance claims keep the receiving wall, screen, hood and pier fixed. No source-pose member is required to hide a destination |
| One box bearing surface | Preserve rectangular support. P2 compound tongue needs different support handling and is not assumed supported |
| Grounded footprint and explicit fixed supports | Register every later fixed floor/ramp/support path; never classify a new floor as passenger by proximity. No loose cargo is required |
| Player remains observer / arrival view veto | Same local hood and release range makes ordinary mapped arrival concealed. No passenger visibility exemption or special C exception |
| Atomic root/player commit; collision rejection | Keep all mapped member/capsule volumes clear. Test a blocked rider-only arrival and ensure no partial movement |
| One successful move per release; previous state allowed | Pause and ordinary look-back suffice for safe dismount and later returns. Never add destination history or area progress restrictions |
| Existing Beam power/aim controls | I uses existing two-aim plus power capability; R uses existing power. No destination selector, camera observer, or extra source class |

Manual technical gates carried forward, **all unverified in this task**:

| Gate | Future test and acceptance evidence | Planning reduction of risk |
| --- | --- | --- |
| Rendered probe-edge coverage | Render fixed-ground/current/candidate views of every member, especially window lip, cradle edge and upper collar. Sweep normal camera positions, declared viewport aspects and guard margins; compare actual visible geometry with hold/exclusion. No visible unsampled sliver may move | Simple front members, unchanged rectangular deck, no rear props; no silhouette credit inferred from marker tests alone |
| Walking / concealment comfort | Walk approach, seam, deck, view region and dismount at A/B/C with ordinary controls and no coordinates. Include downlook, drift, partial support and empty-bed egress. Verify mapped pose and arrival veto across the usable range | Same orientation, broad crossing, fixed independent hood, generous capsule clearance; downlook risk explicitly retained |
| Switch reachability | Use real interaction ray/E at both I controls and R with X at each state. Check control surface is unobstructed, target view can be retained, source mounts do not block walking, and recall requires no timer race | Fixed standing recesses south of every envelope; route goes around source housings |
| Yaw-rotated passenger arrival | Not used by this first layout. Before any later yaw proposal, test mapped body/head/velocity, full support, arrival frustum and dismount at each rotation, including blocked candidate | Identity bases defer this unverified capability without claiming it passed |

A later rendered gate must also check actual authored lighting plus recorded view/light tolerances for conspicuous cast-shadow discontinuities. Shadow projections never hold, exclude, rearm, or veto. No hidden state delay or lighting shutdown may conceal an authoring failure.

## 13. Remaining risks and decision boundary

1. Reserved corridors are not built mesh clearances. Future opening of the approach seals must account for rear walls, guards, equipment and 2 m walking lanes; no current hub traversal test establishes those future links.
2. The I→C full-field clearance is plausible but only about 0.19 m at the nearest hood edge. Measure the real emitter origin, housing and aperture trim before dressing; preserve the whole volume, not just a center ray.
3. The rectangular deck has a smaller comfortable downlook envelope than P2's rounded tongue. The paper level/upward range is valid under stated assumptions, but manual comfort and support recognition can still reject it. Do not silently advertise P2's broader certificate.
4. Source controls, FOV/aspect limits and member-probe density need the manual gates above. Any additional rear structural feature invalidates the present concealment calculation until rechecked.
5. C's fit/signature might be too subtle at survey scale, or identical hoods might suggest a transport system too early. Actual viewing and unbriefed interpretation, rather than new labels or lore, decide that.
6. A first lawful supported release can reach C before the intended reinterpretation. This is accepted by the rules and remains a pacing/evidence question, never grounds for a hidden knowledge gate.
7. Exterior dismount is terminal-safe, not a promise of fixed walking return to the interior. Optional return requires C still present for reboarding; mandatory post-escape hub work is outside this plan.

The paper layout satisfies the requested planning gate: one bounded object fits A/B/C within a stable facility; interior investigation/control access survives every state; exterior evidence is early; Beam and recall paths are explicit; supported execution has a nonzero safe pose range; no new mechanic or sequential wing puzzle is needed. Further approval concerns connected exploration planning only. Final-world scene integration and TASK-037 were not started.

## 14. Artifact checks and scope record

This task adds only this document, including its twelve plain-text diagrams. Local links, diagram count, tables, coordinate arithmetic, Beam corridors, access/recovery cases, and whitespace were reviewed. No gameplay tests are represented as new results: no gameplay or scenes changed. TASK-035's earlier automated results remain attributed to TASK-035, and all manual/human results remain unvalidated.

No temporary scripts, captures or generated assets were needed. Existing working-tree changes were preserved. No commit or push occurred.
