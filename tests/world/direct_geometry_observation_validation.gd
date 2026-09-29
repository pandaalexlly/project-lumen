extends SceneTree

# Uses the production Cube, ObservationManager, and Beam paths. The offset
# point is the former Cube floor-footprint sample, not a new observer flag.
const CUBE_SCENE := preload("res://scenes/prototype/quantum_cube.tscn")
const BEAM_SCENE := preload("res://scenes/prototype/stabilization_beam.tscn")
const FORMER_FOOTPRINT := Vector3(-0.85, -0.54, -0.3)

var failures: Array[String] = []


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func settle() -> void:
	await physics_frame
	await physics_frame
	await process_frame


func _run() -> void:
	var fixture := Node3D.new()
	fixture.name = "ContractFixture"
	var camera := Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, 0, 6)
	fixture.add_child(camera)
	var manager := ObservationManager.new()
	manager.name = "ObservationManager"
	manager.primary_camera_path = NodePath("../Camera3D")
	fixture.add_child(manager)
	var start := Marker3D.new()
	start.name = "Start"
	fixture.add_child(start)
	var candidate := Marker3D.new()
	candidate.name = "Candidate"
	candidate.position = Vector3(3, 0, 0)
	fixture.add_child(candidate)
	var cube := CUBE_SCENE.instantiate() as QuantumRelocator
	cube.name = "QuantumCube"
	cube.observation_manager_path = NodePath("../ObservationManager")
	cube.destination_paths = [NodePath("../Start"), NodePath("../Candidate")]
	cube.avoid_immediate_return = false
	cube.debug_output = false
	fixture.add_child(cube)
	var transparent_player := CharacterBody3D.new()
	transparent_player.name = "BeamTransparentPlayer"
	transparent_player.position = Vector3(20, 0, 0)
	var player_collision := CollisionShape3D.new()
	var player_box := BoxShape3D.new()
	player_box.size = Vector3(0.5, 1.5, 0.5)
	player_collision.shape = player_box
	transparent_player.add_child(player_collision)
	fixture.add_child(transparent_player)
	var beam := BEAM_SCENE.instantiate() as StabilizationBeam
	beam.name = "StabilizationBeam"
	beam.player_path = NodePath("../BeamTransparentPlayer")
	beam.debug_output = false
	fixture.add_child(beam)
	root.add_child(fixture)
	current_scene = fixture
	await settle()

	# A: a directly visible Cube surface holds the current state.
	camera.look_at(start.global_position)
	await settle()
	check(cube.directly_observed and cube.currently_observed, "A: direct Cube geometry did not hold")
	var initial_moves := cube.successful_move_count
	await create_timer(0.4).timeout
	check(cube.successful_move_count == initial_moves, "A: directly observed Cube moved")
	cube.set_physics_process(false)
	cube.get_node("MoveTimer").stop()

	# C: only the actual candidate body is in view.
	camera.look_at(candidate.global_position)
	await settle()
	check(cube.call("_is_destination_probe_group_visible", cube.get_node("BodyVisibilityProbes"), candidate), "C: prospective body not visible")
	check(cube.call("_is_destination_envelope_unsafe", candidate), "C: directly visible candidate not excluded")

	# A real opaque fixed panel conceals the candidate body, while a former
	# footprint point to its side remains visible on independent space.
	var panel := StaticBody3D.new()
	panel.name = "FixedOccluder"
	panel.position = Vector3(2.7, 0, 1)
	var panel_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(1.6, 2.4, 0.2)
	panel_shape.shape = box
	panel.add_child(panel_shape)
	fixture.add_child(panel)
	await settle()
	panel.position = Vector3(-0.3, 0, 1)
	camera.look_at(start.global_position)
	await settle()
	check(not manager.is_target_position_directly_visible_with_margin(cube, cube.global_position, cube.destination_viewport_margin), "A: center remained visible through corner occluder")
	check(cube.directly_observed, "A: exposed Cube corner did not hold")
	panel.position = Vector3(2.7, 0, 1)
	camera.look_at(candidate.global_position)
	await settle()
	var old_candidate_footprint := candidate.global_transform * FORMER_FOOTPRINT
	check(manager.is_position_directly_visible_with_margin(old_candidate_footprint, cube.destination_viewport_margin), "D: former shadow footprint is not visible in fixture")
	check(not cube.call("_is_destination_probe_group_visible", cube.get_node("BodyVisibilityProbes"), candidate), "D: panel failed to conceal candidate body")
	check(not cube.call("_is_destination_envelope_unsafe", candidate), "D: shadow-only candidate was excluded")

	# E: put the same physical Cube behind that panel. The indirect footprint
	# remains visible, but it cannot hold or rearm an unobserved state.
	cube.call("_place_at_destination", 1)
	cube.set("_current_destination_index", 1)
	cube.get_node("MoveTimer").stop()
	cube.call("_clear_pending_destination")
	cube.set("_moved_this_unobserved_period", true)
	cube.set_physics_process(true)
	await settle()
	check(not cube.directly_observed and not cube.currently_observed, "E: indirect footprint held current Cube")
	check(cube.get("_moved_this_unobserved_period"), "E: indirect footprint rearmed spent release")
	check(manager.is_position_directly_visible_with_margin(cube.global_transform * FORMER_FOOTPRINT, cube.destination_viewport_margin), "E: indirect footprint lost visibility")

	# B: after genuine body observation, fully hide the Cube and allow the
	# ordinary shared lead-in/grace to relocate it.
	panel.position = Vector3(20, 0, 1)
	await settle()
	check(cube.directly_observed, "B: body reobservation did not rearm")
	camera.look_at(Vector3(3, 0, 12))
	await create_timer(0.65).timeout
	check(cube.successful_move_count == initial_moves + 1, "B: sustained direct-geometry loss did not release")
	check(cube.current_destination_index == 0, "B: released Cube did not reach sole candidate")
	var moved_once := cube.successful_move_count
	await create_timer(0.45).timeout
	check(cube.successful_move_count == moved_once, "B: Cube moved twice in one release")

	# F/G: the real Beam still holds a current Cube and excludes a vacant
	# destination. The candidate query must ignore the Cube's old collider.
	beam.position = Vector3(0, 0, -4)
	beam.aim_at(start.global_position)
	beam.set_enabled(true)
	await settle()
	check(cube.artificially_observed and cube.currently_observed, "F: Beam did not hold current Cube")
	beam.set_enabled(false)
	beam.position = Vector3(3, 0, -4)
	beam.aim_at(candidate.global_position)
	beam.set_enabled(true)
	await settle()
	check(cube.call("_is_destination_artificially_observed", candidate), "G: Beam did not observe empty candidate")
	check(cube.call("_is_destination_envelope_unsafe", candidate), "G: Beam did not exclude empty candidate")
	# A prospective point behind the old Cube must be queried as though the
	# old Cube has departed. A player standing in the Beam also stays transparent.
	beam.set_enabled(false)
	beam.position = Vector3(0, 0, -4)
	candidate.position = Vector3(0, 0, 3)
	transparent_player.position = Vector3(0, 0, 1.5)
	beam.aim_at(candidate.global_position)
	beam.set_enabled(true)
	await settle()
	check(cube.call("_is_destination_artificially_observed", candidate), "G: old Cube or player blocked hypothetical Beam candidate")

	fixture.queue_free()
	await process_frame
	print("DIRECT-GEOMETRY OBSERVATION VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
