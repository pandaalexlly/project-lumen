# Project Lumen — Canonical Spatial Rulebook

**Status: design canon, not an implementation or human-readability claim.** This document fixes the three-facility geography, the four quantum-room identities, the sole room exchange, and the player access distinction. It does not add a mechanic, specify a puzzle solution, or assert that the complete layout is playable. Items not established by the current brief are marked **UNRESOLVED**.

For this core mystery, the geography below supersedes incompatible *proposed geography* in [Spatial Topology Design](PROJECT_LUMEN_SPATIAL_TOPOLOGY_DESIGN.md) and [Three-Facility Discovery Architecture](PROJECT_LUMEN_THREE_FACILITY_DISCOVERY_ARCHITECTURE.md): their single-H0/P–Q/M–N branch and their use of three "facilities" as perspectives within one fixed site are not this map. Do not import their lower-lift or exterior-route topology into this rulebook. The general direct-observation, candidate-exclusion, release/rearm, atomic-exchange, and safety constraints in [Spatial Quantum Rules](PROJECT_LUMEN_SPATIAL_QUANTUM_RULES.md) remain applicable where they do not conflict with an item explicitly flagged below. Neither older proposed geography nor this design document establishes final runtime integration.

## 1. Canonical physical map

Each facility has its **own fixed vertical stack**. The three stacks coexist; they are not states, copies loaded in place of one another, or interchangeable names for one atrium.

```text
Facility 1                 Facility 0                 Facility 2
QER1                       QER0                       QER2
  |                          |                          |
 H1                         H0                         H2
  |                          |                          |
Awakening 1              Awakening 0               Awakening 2
```

The declared horizontal relationship has four fixed positions, named here only for designer reference: outer-left (`OL`), inner-left (`IL`), inner-right (`IR`), and outer-right (`OR`). These position labels are not additional rooms or player-facing terminology. H1 lies between `OL` and `IL`; H0 between `IL` and `IR`; H2 between `IR` and `OR`.

```text
                         OL      IL       IR       OR
State A, west → east:  [Left′]—H1—[Left]—H0—[Right]—H2—[Right′]
State B, west → east:  [Left′]—H1—[Right]—H0—[Left]—H2—[Right′]
```

| Fixed position | State A occupant | State B occupant | Adjacent fixed atrium or atria |
| --- | --- | --- | --- |
| `OL` | Left Room′ | Left Room′ | H1 |
| `IL` | Left Room | Right Room | H1 and H0 |
| `IR` | Right Room | Left Room | H0 and H2 |
| `OR` | Right Room′ | Right Room′ | H2 |

The diagrams show physical order and adjacency. **Adjacency does not grant atrium-to-room entry** and does not, by itself, specify which face contains a usable internal exit door. No other horizontal route is established by this rulebook.

## 2. Fixed and movable identities

| Entity | Spatial status | Identity and state rule |
| --- | --- | --- |
| H0, H1, H2 | Fixed, distinct, simultaneous atria | None becomes another atrium or moves during a room exchange. |
| QER0, QER1, QER2 | Fixed; each belongs only to its corresponding facility | They are not one shared room or a direct QER-to-QER teleport network. |
| Awakening 0, 1, 2 | Fixed; each belongs only to its corresponding facility | They do not exchange or follow a quantum room. |
| `OL`, `IL`, `IR`, `OR` and their fixed interfaces | Fixed positions | Position/address is distinct from the room occupying it. |
| Left Room′ and Right Room′ | Fixed quantum rooms | Left′ stays at `OL`; Right′ stays at `OR`. The word *quantum* does not imply that either has spatial movement. |
| Left Room and Right Room | The **only** rooms with spatial exchange behavior | They retain separate material identities while reciprocally occupying `IL` and `IR`. |

The mobile room is a whole bounded spatial object, not just a doorway. Its authored participating structure, orientation, attached components, and current internal state remain with that room. Fixed atrium structure and fixed interface hardware remain at their positions. Spatial exchange is not a reset to an older room state and does not create a fresh copy.

**UNRESOLVED — internal-object boundary.** The new canon says "internal objects move together with the room." The existing room-scale safety contract guarantees carriage for participating/attached members but does **not** silently carry loose, unbound physics objects or people. Attached structure and current attached state are the common, established case. Whether every loose internal item is included is a direct wording conflict requiring a separate decision; no future puzzle may rely on either interpretation until resolved. Player carriage is governed separately by K4 below.

## 3. Sole spatial exchange

The only room-position transition is the reciprocal `Left Room ↔ Right Room` exchange between `IL` and `IR`, in either direction between State A and State B. Left′ and Right′ do not participate. There is no half-swap, room rotation, hub swap, or simultaneous transformation of the three facilities.

The existing observation and safety contract constrains this exchange:

1. **Whole-room identity.** Both mobile rooms, including participating walls, floors, doors, and attached members, change placement atomically. Their local orientation and current internal conditions persist.
2. **Current observation.** A player's direct view of any participating surface or sliver of either room holds the reciprocal pair. Direct view from an enabled Beam or a live camera counts under the same source-based rule. Looking only at fixed scenery, a shadow, or stored imagery does not.
3. **Candidate observation.** Both candidate room placements must be unobserved from the present observer configuration. Candidate geometry is evaluated as a joint exchange after vacating the two departing room poses and any included passenger's old collision pose, without treating a departing shell as a magical occluder. That passenger's **pre-commit view** still counts against candidate visibility. An observed candidate vetoes the whole exchange.
4. **Release and rearm.** The established cancellable unobserved interval and actual-reobservation rearm apply to the pair. After an exchange, **both** Left and Right must be actually reobserved/rearmed before another reciprocal exchange is eligible; reobserving only one is insufficient. A previous safe state is not permanently forbidden, and the pair does not repeatedly shuffle during one uninterrupted release opportunity.
5. **Safety.** Both complete candidate rooms, their current door and equipment poses, fixed interfaces, and any qualified passenger must have a safe, nonintersecting result and safe dismount. If the joint candidate is not legal, neither room moves.
6. **No direct witness.** The player cannot see the exchange taking place. A watched participating face, including a face that looks like an ordinary wall, prevents it. The player can inspect a lawful before-and-after result.

Observation constrains *placement*, not a room's material identity. It does not independently open a door, solve an internal puzzle, or move a fixed prime room.

## 4. Player access and the two distinct forms of movement

The only declared entry route into **any** of the four quantum rooms is:

```text
Awakening/atrium area → that facility's QER
                    → quantum entanglement movement
                    → arrival inside one quantum room
                    → solve that room's internal puzzle
                    → open its internal door
                    → enter the atrium connected to that door
```

The player never enters Left, Right, Left′, or Right′ **from an atrium**, in either state. A room can be physically adjacent to an atrium without being an ordinary walk-through corridor. A QER belongs to its own facility and does not directly deliver the player into another QER or atrium. The canonical destination set for QER-mediated arrival is the four quantum rooms; destination selection and source-specific eligibility remain **UNRESOLVED**.

Do not merge QER transfer with **K4 passenger movement**:

- **QER transfer** starts from a fixed Quantum Entanglement Room and ends inside a quantum room. It is a stated, separate access mechanism. Its transfer conditions and arrival mapping have not been specified. It cannot be derived from the Left/Right exchange or from K4.
- **K4 carriage** applies only when the player is already fully supported by the travelling object's structural floor or cradle—not merely touching a wall or standing on an unbound item. The player's own sight still counts: seeing its participating floor, wall, or door can hold it. Complete relevant observation loss, safe candidate placement, and safe mapped arrival with support and dismount are required. Merely being inside, closing a door, or standing in darkness grants no exemption. Left′ and Right′ have no spatial move for K4 to carry a player on.

Whether the player is riding Left/Right during a particular exchange and whether a QER arrival occurs before or after that exchange are separate questions. This rulebook does not force either sequence.

**UNRESOLVED — doors and one-way access.** The horizontal map and nonrotation rule do not establish each room's door-bearing face or the exact atrium reached by Left/Right in each state. The physical means by which a door permits room-to-atrium exit but never atrium-to-room entry is also unspecified, especially after that door is opened and its state persists with the room. Do not infer a hidden lock, a rotating room, or an invisible player barrier to fill this gap.

## 5. What the player can observe

The player may see a doorway where a wall-like frontage was previously seen, or the reverse, at a **fixed atrium-facing position**. This describes the player's visual result, not the literal transformation of H0/H1/H2 or of a fixed wall. The exact material boundary between mobile room frontage and fixed interface must be authored consistently with the observation rule.

The player can also, in principle, compare a room's persistent identity and current condition at different inner positions while fixed atrium/interface details remain in place. The fixed Left′/Right′ rooms are comparison identities, not additional movers. A changed frontage alone proves neither which room moved nor which atrium the player occupies.

A QER-mediated trip into Left′ or Right′ could lead onward to H1 or H2 **without any Left/Right exchange**. Conversely, an arrival inside Left or Right does not itself prove that room has moved. The first cross-facility experience and the first moving-room demonstration need not be the same event. Exact exits from the inner rooms remain subject to the unresolved door-face contract.

## 6. False and true spatial interpretations

**Intended reasonable false model:** one facility has one atrium, one QER, and one Awakening area; quantum phenomena alter the atrium's apparent internal connections. A familiar atrium after a QER/room passage is therefore mistaken for a return to the original place. Similar construction and the interrupted line of sight make that inference plausible, while persistent differences must remain available for later correction.

**Canonical true model:** three fixed, materially distinct vertical facility units coexist. The player's QER-mediated arrival inside a quantum room and subsequent exit can place them in a different unit without their recognizing it. Left and Right can additionally exchange inner positions while preserving identity; the fixed units themselves do not transform. Shared architectural design is not shared material identity.

This rulebook states that truth; it does **not** declare that a changed doorway or differently damaged atrium alone proves it to an unbriefed player. The physical evidence that demonstrates simultaneous facility identity is **UNRESOLVED**. The solution must not depend on a final assertion replacing an observable contradiction.

## 7. Established player knowledge (K1–K6)

These are player-knowledge summaries, not extra permissions to bypass the detailed observation and safety contract:

| Knowledge | Established meaning in this spatial model |
| --- | --- |
| K1 | An unobserved quantum object's placement may change when a legal transition exists; loss of *player* sight alone is insufficient if another valid observer still sees it. |
| K2 | A currently observed candidate placement cannot become that object's destination. |
| K3 | An enabled Beam with direct sight observes like player vision. |
| K4 | A player fully supported by a moving object's structural floor or cradle may travel with it only under complete relevant observation loss and safe mapped arrival. This is not QER transfer. |
| K5 | A live camera with actual direct sight can observe; a camera merely present or a stored image does not. |
| K6 | Movement preserves the object's current identity and internal condition; it does not restore an older snapshot. |

Recognition that spatial structures possess persistent identity is a **potential later player discovery**, not an additional numbered mechanic established here. The material identity of Left and Right already exists whether or not the player understands it.

## 8. Known facts at a glance

- Three distinct facility units and their QER–atrium–Awakening stacks coexist and remain fixed.
- Four quantum rooms exist. Left′ and Right′ remain fixed; only Left and Right reciprocally exchange the two inner positions.
- A moving room retains its material identity, orientation, and current attached condition. Its destination address is not its identity.
- A player enters a quantum room only by QER-mediated transfer, solves its internal puzzle before opening its exit, and never enters it from an atrium.
- QER-mediated transfer is separate from K4 carriage. Neither is a direct transformation of an atrium or a QER-to-QER connection.
- The room exchange must obey direct current/candidate observation, atomicity, release/rearm, and safety constraints. It cannot be directly witnessed.
- The intended false interpretation is one changing facility; the canonical truth is three coexisting fixed facilities whose connections can differ through bounded quantum rooms.

These facts define a **design contract**, not a claim that final geometry, technical integration, or unbriefed-player comprehension has passed validation.

## 9. Explicitly unresolved decisions

The following are not license to invent an answer inside a puzzle or scene:

1. **QER transfer contract:** which source QER can reach which of the four rooms; how a destination is selected or predicted; transfer observation conditions, arrival pose/safety, retry, and recovery. The existence of QER-mediated arrival is canon; these details are not.
2. **Room frontage and doors:** the unrotated door-bearing faces of all four rooms, the exact A/B exit-to-atrium table, and the participating-room versus fixed-interface boundary visible at each atrium.
3. **One-way threshold behavior:** how room-to-atrium egress remains physically consistent with a categorical ban on atrium-to-room entry, including after a door has been opened and its state persists.
4. **Internal-object membership:** whether "internal objects move together" includes loose unbound props and people, in light of the existing safety contract's narrower rule.
5. **Authored exchange geometry:** actual sightlines from all atria and other observer sources, broad passenger concealment if carriage is used, candidate collision envelopes, and recovery from both states. The logical predicates above are established; their final geometry is not.
6. **Opening occupation and first arrival:** whether State A or B is initially occupied and which quantum room the player first reaches. Neither is implied by the map.
7. **Extent of each facility:** "complete facility unit" canonically includes its own QER–atrium–Awakening stack. Whether each unit also contains matching research wings is unspecified; no triplication of other areas is implied.
8. **Proof of coexistence:** the fixed physical evidence by which a player can rule out one atrium with several persistent states and infer three simultaneously existing units. The truth is canon; the player-facing proof is not yet authored or validated.

Until these decisions are recorded, future design may rely on the fixed three-stack map, the single Left/Right reciprocal exchange, fixed primed rooms, and the access distinction—but not on a particular destination algorithm, doorway orientation, loose-object rule, or final reveal geometry.
