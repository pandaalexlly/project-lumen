# Awakening Chamber — Development Pass

## Playable scope

TASK-028 established the workplace detail, rear maintenance loop, and practical lighting. See [the humanization pass](AWAKENING_HUMANIZATION.md) for that environmental foundation. The later pacing pass made Cube relocation open a maintenance approach rather than reveal a handle directly. The Beam/load integration preserves that opening discovery and extends the physical consequences of using the handle.

F5 opens `scenes/world/opening/awakening_chamber.tscn`, the 14 m by 12 m research chamber with its booth, equipment bay, recovery corner, and shared test floor. Its bulkhead leads continuously to the Operations Atrium. Four wing approaches remain sealed; no final escape puzzle is implemented. See [the hub foundation](CENTRAL_HUB_FOUNDATION.md).

The first consequential interaction restores the room's work lights, instrument supplies, ventilation, Beam, and door-release circuitry through a fixed service isolator inside the damaged maintenance side. The Cube's initial position closes the walkable approach; any ordinary relocated position leaves it open. The isolator is not visible down the initial approach. Local restoration starts the Beam **on**, aimed at the empty west-bay plate, but leaves the bulkhead **closed**. Service power plus physical Cube occupancy on the plate enables a separate release at the bulkhead; only player interaction with that live control opens the door. There is no knowledge flag, prescribed move count, or opening-only relocation rule.

## Intended discovery sequence

| Likely phase | Environmental invitation | Player's possible inference |
| --- | --- | --- |
| Arrival, roughly 0–2 minutes | Neutral inspection light frames the Cube and damaged apparatus. Workspaces offer other interests; emergency light reveals a jammed bulkhead behind the player. | This equipment was used for something; something interrupted it. |
| First search, roughly 2–4 minutes | Recorder spools behind the rack, a disrupted booth, and a recovery gurney invite turns and changes in sight line. The Cube can leave its starting position using its ordinary rules. | The object was there a moment ago. |
| Experiments, roughly 4–7 minutes | Four distinct, reachable places allow finding it again, circling it, hiding behind equipment, and returning. | Watching keeps it still; breaking sight lets its state change. |
| Maintenance discovery | The Cube's vacated mount leaves a route through displaced racks. Past the turn, the player can inspect an ordinary rotary isolator on a fixed service wall. | That space was inaccessible before; I should see what the equipment contains. |
| Partial restoration | The handle turns; work lights, instruments, ventilation, and the Beam come on. Its field falls on the empty west-bay plate, which the Cube cannot then occupy. The bulkhead stays shut. | I supplied a subsystem, not the exit itself. |
| Experimentation | Turning the fixed breaker off frees the plate candidate. The plate visibly responds when the Cube occupies it, and a bulkhead-side release gains power. Without observation the Cube can leave and that release loses power. | Something must hold this condition while I move away. |
| Consequence | Beam observation keeps the loaded Cube in place. The player can walk to the still-powered release and operate it; only then does the bulkhead lift and Atrium circulation light up. | The Beam can hold the same object I can hold by looking. |

These are possible inferences, not a required sequence or measured timings. A player may reach the plate early. Do not add forced loops or hidden prerequisites to ensure a particular play duration.

## Spatial and story functions

- **Central apparatus:** a low mount and restrained overhead equipment give the initial Cube a distinct silhouette. Bent storage racks, displaced trays, and a fallen frame frame the maintenance approach without covering the Cube. The Cube physically closes its entrance at the initial position. The isolator is mounted on the rear fixed utility wall, behind the inner turn and connected to the ventilation-side service chase. There is no invisible software lock.
- **West equipment bay:** the diagnostic rack occludes the test floor. A heavy, unmarked load platform sits amid measurement equipment; the mounted inspection Beam and its fixed breaker face that existing Cube destination. Recorder spools, loose tape, stored parts, and an open service panel still imply research and repair.
- **Observation booth:** the broken frame, fallen workstation, displaced cover, and vacant seat imply a hurried interruption. There is enough clearance to walk around the equipment and inspect the Cube's booth state.
- **Recovery corner:** a worn gurney, folded sheet, storage cases, and wall wear provide a human scale and a distinct landmark. No collectible or inventory is implied.
- **Ceiling and rear wall:** torn ductwork and stationary ventilation connect the room's degraded state to the service restoration payoff.
- **Bulkhead:** the worn reinforcing brace, exposed piston, split seam, and damaged lintel describe degraded equipment. A guarded round release button is mounted on the wall to the player's left of the doorway, separate from the door and joined to its frame by a short conduit. Its small analog needle and indicator show live state. The button remains visibly present but dark and non-interactive without both service power and Cube weight on the plate. It does not open automatically. Successful use starts the existing motor lift and permanently latches the door open for safe return.

The inspection cameras have dark lenses and interrupted/disconnected cabling. They are scenery, with no observer registration, camera feed, tracking, or stabilization behavior. They stay inactive when other room services return.

## Presentation boundaries

No room title, tutorial, objective marker, destination pad, world text, completion banner, notification, or interaction prompt is shown in this chamber. The prototype PresentationUI is hidden only for this scene's lifetime, and its previous visibility is restored on exit. Shared interaction and presentation scripts are unchanged.

The service handle, Beam breaker, and powered bulkhead release are physical controls: E uses the existing interaction ray. The inactive release has no interaction ray target or misleading interaction feedback. Supply standard movement, mouse-look, E, and Escape controls outside the game when testing; do not explain the Cube or desired action. Whether players discover the maintenance side, understand partial restoration, and connect the Beam to observation are explicit test questions.

The Cube's four states use ordinary surfaces and equipment clearings. Only the west-bay marker was raised slightly to meet the load platform. Visibility probes, destination selection, and post-restoration quantum behavior are unchanged. The shared `QuantumRelocator` release lead-in is now 0.05 seconds, followed by the retained 0.2-second destination-hidden grace, across world and prototype scenes. The plate uses physical Cube-body occupancy, not the Cube's destination index.

## Environmental asset usage

`awakening_dressing.tscn` holds authored incident evidence and repeated shell details. It composes the existing facility block and crate assets with a reusable passive inspection-camera prop. The chamber continues to use dead consoles, door framing, emergency lights, and structural units from the greybox kit.

`service_control.tscn` provides the one-shot maintenance handle and, with a local breaker script, a separate fixed Beam control. The chamber script handles local restoration, starts the supplied Beam on, and supplies the release circuit. `awakening_load_plate.tscn` reuses the generic `PressurePlate` occupancy query with a restrained mechanical surface and dial response. The local bulkhead release derives `release_powered = service_power_on && plate_loaded`; its `interact()` rechecks actual occupancy before signaling the existing hub controller. The hub controller lifts the bulkhead and fades circulation lighting once, permanently. None of these scripts selects a Cube destination.

## Designer-facing causal contract

The west-bay load platform is Cube destination 1. After the handle is used, the Beam starts ON and aimed there. While the platform is empty, its candidate envelope is observed and excluded. Turning the Beam OFF at the fixed breaker makes the candidate legal again. From walkable viewpoints near `(0.5, 2.5)` for a Cube at the initial mount, `(-5, 0)` for a Cube in the booth, or `(1.5, 2.5)` for a Cube on the gurney, the player can directly see the unwanted candidate bodies while the current Cube and west platform are not observed. The platform is then the only legal candidate. These positions and angles are validation examples, not marked stations or required exact spots; each has a broad sightline range. If the Cube has just left the platform, normal immediate-return exclusion requires an intervening genuine reobservation/release before it can return.

The fixed breaker can be focused while the loaded Cube is still in the player's view. Turning the Beam back ON then supplies artificial observation before the player turns away. If the Beam stays OFF, the Cube leaves the plate under its normal release rule when a legal alternative is available; the plate and bulkhead release visibly reset. A Cube already on the plate before service restoration may be stabilized by Beam startup, but this still cannot open the door automatically. Once the player operates the powered release, the bulkhead follows its existing motor travel and stays open even if the load later changes.

The later shared observation-contract conformance pass removed the historical floor/shadow-footprint samples from current and candidate gameplay queries. Direct Cube-body samples and the existing Beam still determine observation; cast-shadow continuity is an authored presentation concern only. The three documented west-platform selection sightlines were checked using **body probes alone**, so their candidate exclusion remains valid without a shadow-only hold or exclusion. This is a global shared-law correction, not an Awakening-specific exception.

## Validation and external observation

Run `godot --headless --path . --script res://tests/world/awakening_chamber_validation.gd` for maintenance access, real E interaction, observed/unobserved behavior, partial restoration, all-four-state routes, powered release, Atrium traversal, absence of instructional labels, and HUD restoration. Run `godot --headless --path . --script res://tests/world/awakening_beam_plate_validation.gd` for automatic Beam startup and empty-plate exclusion, real breaker E interaction, deterministic body-visibility selection from each nonplate state, Beam-OFF plate loss and recovery, early plate occupation, explicit release interaction, and safe latched door return. Run `tests/world/shared_quantum_release_validation.gd` for shared timing defaults, interrupted-occlusion cancellation, and a genuine Discovery prototype release.

The shared timing regression also exercises the Observation Lab, both Beam teaching rooms, Combined, Field Site, and inherited QuantumDoor defaults. Discovery and Field Site Cubes relocated after genuine release; short reobserved breaks were cancelled where a direct view was established. Each prototype scene launched headlessly. This verifies the stable law and scene integrity, not whether the faster response remains comfortable in unbriefed hands or every full prototype solution is equally legible.

The discovery-pacing pass checked player-height rendered views from spawn, the Cube's side, the vacated mount, the service approach, the handle, and the restored room. These establish visual geometry, not first-time-player understanding. The relocation remains systemic and may happen during ordinary exploration; no comprehension gate was added. See [the manual playtest protocol](../../tests/manual/AWAKENING_FIRST_PLAYER_PLAYTEST.md) for the nine pacing checks and remaining human questions.

TASK-027 validation completed in Godot 4.7.2: the regression script passed, including short-glance cancellation, covered-control rejection from four sides, all four relocation states after restoration, repeat-interaction safety, route sweeps, and preserved prototype scene loads. Rendered 1280 × 720 views of the arrival, west bay, booth, exposed control, and restored chamber were inspected. The ambient source was corrected to color fill so inactive equipment remains readable. Fixture faces illuminate with their work lights; fan blades remain visible behind the guard. Protected observation/interaction scripts, prototype scene files, and F5 configuration were hash-checked against the start of this task and were unchanged.

For a first external playtest, record first Cube notice, first relocation noticed, first deliberate repeat, service approach entry, handle use, Beam/breaker inspection, plate occupation and loss, deliberate Beam stabilization, and bulkhead release. Ask the player to describe what they think happened before asking about observation.

Watch for these unresolved human factors:

- Does the player attribute disappearance to looking away or to walking near equipment?
- Do dark cameras look broken, or imply that observation should already hold the Cube still?
- Does the vacated access invite investigation, and can the player recognize and operate the physical handle inside without an on-screen prompt?
- Are the search pockets interesting enough to explore without repeatedly losing the Cube in frustration?
- Does the handle's partial restoration invite new experimentation rather than read as a failed exit button?
- Do players understand the Beam's two effects as the same observation rule?
- Can players deliberately produce and maintain west-bay load without random retries?
- Does the plate/relay/bulkhead response feel physically causal, and does the opening lead naturally into the hub?
- How long is the actual first session? Report the distribution; do not infer duration from an automated test.
