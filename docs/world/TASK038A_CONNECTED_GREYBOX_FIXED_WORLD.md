# TASK-038A — Connected Facility Fixed-World Greybox

**Verdict: GO TO ASSEMBLY WORLD INTEGRATION.** This is a fixed-world technical gate only. No final-world Coherent Assembly, passenger transition, escape, active I/R Beam, or new puzzle rule was integrated. Human mystery readability is **UNVALIDATED**.

## Authored structure and access

`awakening_chamber.tscn` remains the F5 world and instances `operations_atrium.tscn`; the latter now instances `connected_facility.tscn`. The new facility scene owns static corridor continuations, a shared covered work apron J, D inspection screen, A/B/C fixed receivers, V/S survey boundary, exterior C landing/yard, I/R physical reservations, and work lighting. `fixed_receiver.tscn` is a reusable *stationary* bed/hood/contact fixture, not an assembly member.

All coordinates below are **Operations Atrium local** (+z toward the rear). Its world translation remains `(0,0,6)`. The fixed graph is:

`Awakening ↔ vestibule ↔ H ↔ {Records, Power, Containment, Signal} ↔ J ↔ {A landing, B landing, V ↔ S}`.

Records additionally reaches D, Power reaches the R work area, and all four approaches can return by fixed floor. The east side of the existing atrium circulation plant is the tested J-to-H return. There is no fixed walking edge S→C. Exterior C has its own landing, west-side empty-bed ramp, and onward yard ground, which are not connected to interior floor. A/B recesses are not required as floor for any internal route.

The four formerly sealed approach instances share a parked side gate and have neither a rear wall nor the old gate collision. Their original entry framing remains. The obstructing ordinary equipment was relocated to side/recess positions: Records archive cabinets, Power exchangers, the **fixed** Containment transfer cradle/guards, and Signal racks. The Containment prop is still ordinary equipment, not part of the future quantum boundary. The 3.82 m minimum unobstructed approach lane at the parked gate exceeds the 2 m planning threshold. The longer Records/Power continuations are deliberately sparse greybox service corridors; the occupational equipment and lighting distinguish their approaches/workfaces without four new chambers.

## Fixed geometry and measured dimensions

| Relationship | Authored / verified result |
| --- | --- |
| Player sample | Actual player capsule 0.80 m diameter × 1.80 m height; standing base y≈0.92, eye y≈1.52; no jump/crouch in route tests. Interaction ray range is 3.0 m. |
| Main J circulation | 3.20 m deep continuous apron, 44.2 m overall width; roof underside y=5.275. Route samples include side approaches and return. |
| A / B / C roots | `(-6,0,38)`, `(6,0,38)`, `(-6,0,50)`, all identity rotation and scale. Same fixed receiver instanced at each. |
| Receiver bed / separation | 4.3 × 4.3 m bed top y=-0.55; reserved future 4 × 4 m deck bottom y=-0.20, leaving 0.35 m vertical bed/deck separation. Bed sides remain independent of the member envelope. |
| Receiver hood | Side supports centered local x=±2.4, inner faces at ±2.3, starting z=1.6; rear wall inner face z=2.6; roof underside y=2.4. Candidate deck, Cube, posts and lintel query clear at A/B/C. The planned deck-to-side inner-face margin is 0.30 m. |
| Boarding / empty bed | Side crossing near local z=0.8 passes an actual capsule sweep. A/B front and C west fixed maintenance ramps allow actual controller walking from empty bed to ordinary floor without jump or recess drop. They are not required for main circulation. |
| D | Screen x=-8.6; opening z=35.4..36.3 (0.90 m) and y=1.8..2.65 (0.85 m). From 3×3 natural eye samples at x=-11.5..-10.5, z=34.6..35.4, y=1.5, all 9 see a reserved A upper-collar point while reserved Cube, bearer and deck points hit the screen. This is a geometric test of **hypothetical** members, not a rendered final assembly proof. |
| S | Boundary z=43, aperture x=-5..-2.6 (2.4 m) and y=1.15..3.10 (1.95 m), with a real sill and missing floor beyond. Player capsule cannot cross; no bridging collision/floor exists. S sees the future C upper-post position and independently supported exterior ground. |
| Exterior | C has a west landing connected to onward yard ground, a buttress, and a distant retaining wall. The retaining wall/fill light were added after player-height capture exposed a featureless black exterior; no route or puzzle rule changed. |
| I/R | Physical cabinets, masts, housings and marker origins only. I standing/control near `(-1.8,32)`, emitter marker `(-1.5,2.6,34)`; R standing/control near `(10.7,32)`, emitter marker `(10.7,2.6,34)`. Both are on fixed, unobstructed floor and the proposed cabinet reach is within the 3 m interaction ray. Actual switch E-interaction and active Beam behavior are **not tested** because no final-world switches/Beams exist here. |

### Beam field gate

The validator casts center, four edge and four corner rays across a 0.62 m-wide field against actual fixed colliders. All 9 rays clear on each intended relationship:

| Corridor | Marker-to-marker length | Fixed-world result |
| --- | ---: | --- |
| I→A | 3.400 m | clear, 9/9 |
| I→C | 14.268 m | clear, 9/9; **0.360 m** minimum full-field margin past A east hood and **0.364 m** at S aperture east edge |
| R→B | 3.564 m | clear, 9/9 |

The I emitter marker is x=-1.5, approximately **0.3 m east** of TASK-036's paper x=-1.8. The earlier real fixture fit gave only ~0.205 m I→C clearance; moving the fixed mount produced the measured practical margin above. Its housing terminates before the marker and does not intersect any tested corridor. No gameplay field was shrunk or Beam special case added. These are static field reservations, not a test of the real final Beam against moving members.

## Rendered player-height audit

Temporary 1280×720 first-person captures used the actual player camera (default FOV) at standing eye height, with the existing bulkhead temporarily lifted **in the capture process only**. Inspected Awakening→atrium arrival; atrium approaches; each opened approach; Records/Power→J; D; A/B receiver/hood/landings; V; first S; S→C/yard; and return via the east passage and vestibule. The apron roof and local work lights replaced a black, unframed work surface. S shows real separation, a fixed C receiver, exterior buttress and onward ground; the yard retaining edge makes the ground/receiver relation legible against the unbuilt dark horizon. There is no EXIT marker, glowing destination pad, visible broken-bridge objective, or newly exposed puzzle label.

The D opening is plainly an inspection slit rather than a full glass wall. Its collar-only selectivity passes geometry, but whether an unbriefed player notices/uses it cannot be inferred from an empty-receiver render. At this greybox stage Records/Power long runs still share simple construction; function-specific equipment is strongest at their entrances and workfaces. No final art or explanatory UI was added. Capture files were temporary and removed after review.

## Validation and remaining gates

`tests/world/connected_facility_validation.gd` loads the **formal Awakening world** and checks capsule/support routes in ≤0.35 m steps, S separation, D sight samples, S exterior LOS, Beam volume rays and margins, planned member-envelope collision queries, side crossings, and actual controller-driven empty-bed egress. All checks passed in the final authored geometry. The protected Awakening and Beam/plate suites, headless editor/import, F5 main-scene launch, and `git diff --check` also passed after the scene edits. Godot printed user-profile log/telemetry, Windows certificate-store, and editor-settings write warnings in the restricted test environment; no scene parser or gameplay assertion failed.

Before TASK-038B can claim its own success, it must integrate the *real* assembly and switches and recheck probe-edge coverage, real member/Beam interactions, passenger support and downlook, comfortable full concealment, all candidate/rearm/recovery states, safe arrival/dismount, and actual traversal. Human C recognition, D evidence, mystery readability, and escape remain **UNVALIDATED** without unbriefed playtests. This GO verdict authorizes only the next technical integration stage; it does not certify passenger or mystery experience.
