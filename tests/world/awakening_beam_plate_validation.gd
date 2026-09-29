extends SceneTree

const CHAMBER := "res://scenes/world/opening/awakening_chamber.tscn"

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


func fixture_cube(cube: QuantumRelocator, index: int, previous: int = -1) -> void:
	cube.get_node("MoveTimer").stop()
	cube.call("_clear_pending_destination")
	cube.set("_current_destination_index", index)
	cube.set("_previous_destination_index", previous)
	cube.set("_moved_this_unobserved_period", false)
	cube.call("_place_at_destination", index)


func _run() -> void:
	var chamber := load(CHAMBER).instantiate() as Node3D
	root.add_child(chamber)
	current_scene = chamber
	var player := chamber.get_node("Player") as CharacterBody3D
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var ray := camera.get_node("InteractionComponent") as InteractionComponent
	var cube := chamber.get_node("QuantumCube") as QuantumRelocator
	var beam := chamber.get_node("StabilizationBeam") as StabilizationBeam
	var breaker := chamber.get_node("BeamBreaker") as Interactable
	var plate := chamber.get_node("AwakeningLoadPlate") as PressurePlate
	var relay := chamber.get_node("BulkheadLoadRelay") as Interactable
	var hub := chamber.get_node("OperationsAtrium") as Node3D
	player.set_physics_process(false)
	cube.set_physics_process(false)
	await settle()
	check(not beam.enabled and not breaker.get("supplied"), "Beam equipment powered before maintenance restoration")
	check(not relay.get("supplied") and not hub.get("services_online"), "Interlock powered at arrival")
	player.position = Vector3(1.95, 0.92, 4.28)
	camera.look_at(relay.global_position)
	await settle()
	check(ray.get_focused_interactable() != relay, "Dark release offers an interaction before supply")
	check(not plate.is_active, "Empty load plate registered a Cube")
	check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Bulkhead open at arrival")

	# The first legitimate move can leave the Cube at any noninitial state.
	# State 3 here keeps the load plate empty when the handle supplies the system.
	fixture_cube(cube, 3, 0)
	chamber.get_node("Shell/ServiceControl").interact()
	await settle()
	check(chamber.get("restored") and beam.enabled, "Service isolator did not auto-start the Beam")
	check(not hub.get("services_online"), "Handle alone opened the bulkhead")
	check(not plate.is_active, "Empty load plate registered after restoration")
	check(breaker.get("supplied") and relay.get("supplied"), "Beam breaker or relay not supplied")
	player.position = Vector3(-4.82, 0.92, -3.72)
	await settle()
	check(not plate.is_active, "Player weight incorrectly satisfies Cube-specific load plate")

	# From this open floor viewpoint the west plate itself remains unobserved.
	# The automatically started Beam, not a hidden index rule, excludes its empty candidate.
	player.position = Vector3(1.5, 0.92, 2.5)
	player.rotation.y = 0.0
	camera.rotation = Vector3.ZERO
	await settle()
	var plate_destination := cube.call("_get_destination", 1) as Node3D
	check(cube.call("_is_destination_envelope_unsafe", plate_destination), "Powered Beam did not exclude empty plate")
	check(cube.call("_choose_safe_destination") == -1, "All observed alternatives should leave Cube in place")
	player.position = Vector3(-4.1, 0.92, -2.4)
	camera.look_at(breaker.global_position)
	await settle()
	check(ray.get_focused_interactable() == breaker, "Powered Beam breaker cannot be focused")
	var press := InputEventAction.new()
	press.action = "interact"
	press.pressed = true
	Input.parse_input_event(press)
	await settle()
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = false
	Input.parse_input_event(press)
	check(not beam.enabled, "E did not turn the startup Beam off")
	player.position = Vector3(1.5, 0.92, 2.5)
	player.rotation.y = 0.0
	camera.rotation = Vector3.ZERO
	await settle()
	check(not cube.call("_is_destination_envelope_unsafe", plate_destination), "Beam OFF did not free the plate candidate")

	# Each nonplate state has a broad, reachable sightline that observes the
	# other candidates while the current Cube and west plate stay out of view.
	var selection_views := {
		0: [Vector3(0.5, 0.92, 2.5), 285.0],
		2: [Vector3(-5.0, 0.92, 0.0), 240.0],
		3: [Vector3(1.5, 0.92, 2.5), 0.0],
	}
	for current_index in [0, 2, 3]:
		fixture_cube(cube, current_index, 2 if current_index == 0 else 0)
		player.position = selection_views[current_index][0]
		player.rotation.y = deg_to_rad(selection_views[current_index][1])
		camera.rotation = Vector3.ZERO
		await settle()
		check(not cube.call("_evaluate_current_observation"), "Selection view watches current state %d" % current_index)
		check(cube.call("_is_destination_eligible", 1), "Plate is not eligible from state %d" % current_index)
		check(not cube.call("_is_destination_envelope_unsafe", plate_destination), "Selection view watches plate from state %d" % current_index)
		for other_index in [0, 2, 3]:
			if other_index == current_index or not cube.call("_is_destination_eligible", other_index):
				continue
			check(
				cube.call("_is_destination_probe_group_visible", cube.get_node("BodyVisibilityProbes"), cube.call("_get_destination", other_index)),
				"State %d relies on shadow-only exclusion of candidate %d" % [current_index, other_index]
			)
		check(cube.call("_choose_safe_destination") == 1, "State %d does not make plate uniquely legal" % current_index)
		check(not player.test_move(Transform3D(Basis.IDENTITY, Vector3(-4.1, 0.92, 0)), Vector3(0, 0, -2.4)), "Beam breaker route blocked from state %d" % current_index)

	# Exercise the real release from the booth state. The player first
	# genuinely observes that Cube, then uses the west sightline to select load.
	fixture_cube(cube, 2, 0)
	player.position = Vector3(3.2, 0.92, -2.1)
	camera.look_at(cube.global_position)
	cube.set_physics_process(true)
	await settle()
	check(cube.directly_observed, "Booth Cube could not be reobserved")
	player.position = Vector3(-5.0, 0.92, 0.0)
	player.rotation.y = deg_to_rad(240.0)
	camera.rotation = Vector3.ZERO
	await settle()
	check(not cube.currently_observed and cube.call("_choose_safe_destination") == 1, "Intentional plate selection not established")
	await create_timer(0.8).timeout
	check(cube.current_destination_index == 1, "Ordinary release did not place Cube on unique plate candidate")
	await settle()
	check(plate.is_active, "Physical plate did not respond to Cube occupancy")
	check(relay.get("release_powered"), "Physical plate failed to power release")
	check(not hub.get("services_online"), "Interlock opened without sustained load")

	# Reobserve the loaded Cube while focusing the fixed breaker. No timing race
	# is needed to establish the Beam before walking away.
	player.position = Vector3(-4.1, 0.92, -2.4)
	camera.look_at(breaker.global_position)
	await settle()
	check(cube.directly_observed, "Breaker use forces loss of player observation")
	check(ray.get_focused_interactable() == breaker, "Fixed Beam breaker cannot be focused")
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = true
	Input.parse_input_event(press)
	await settle()
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = false
	Input.parse_input_event(press)
	check(beam.enabled, "E did not turn the Beam on")
	player.position = Vector3(0, 0.92, 4.6)
	camera.rotation = Vector3.ZERO
	player.rotation = Vector3(0, PI, 0)
	await create_timer(0.8).timeout
	check(cube.current_destination_index == 1 and plate.is_active, "Beam failed to hold loaded Cube after player left")
	check(relay.get("release_powered") and not relay.get("latched") and not hub.get("services_online"), "Loaded plate opened door without release interaction")
	player.position = Vector3(1.95, 0.92, 4.28)
	camera.look_at(relay.global_position)
	await settle()
	check(ray.get_focused_interactable() == relay, "Powered door release cannot be focused")
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = true
	Input.parse_input_event(press)
	await settle()
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = false
	Input.parse_input_event(press)
	await create_timer(3.5).timeout
	check(relay.get("latched") and hub.get("services_online"), "E on powered release did not open bulkhead")
	check(not player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Released bulkhead still blocks Atrium")
	beam.set_enabled(false)
	await create_timer(0.8).timeout
	check(cube.current_destination_index != 1 and not plate.is_active, "Turning Beam off after release made Cube immune")
	check(hub.get("services_online"), "Open bulkhead reclosed and could trap a returning player")
	chamber.queue_free()
	await process_frame

	# If the Cube had already reached the plate before the handle was found,
	# startup Beam may hold it, but the bulkhead still requires a release press.
	var early_chamber := load(CHAMBER).instantiate() as Node3D
	root.add_child(early_chamber)
	var early_player := early_chamber.get_node("Player") as CharacterBody3D
	var early_camera := early_player.get_node("Head/Camera3D") as Camera3D
	var early_cube := early_chamber.get_node("QuantumCube") as QuantumRelocator
	var early_ray := early_camera.get_node("InteractionComponent") as InteractionComponent
	early_player.set_physics_process(false)
	early_cube.set_physics_process(false)
	fixture_cube(early_cube, 1, 0)
	early_player.position = Vector3(-4.1, 0.92, -2.4)
	early_camera.look_at(early_cube.global_position)
	early_cube.set_physics_process(true)
	await settle()
	check(early_cube.directly_observed, "Early-loaded Cube could not be directly observed")
	early_chamber.get_node("Shell/ServiceControl").interact()
	await settle()
	check((early_chamber.get_node("AwakeningLoadPlate") as PressurePlate).is_active, "Early plate load not physically detected")
	var early_beam := early_chamber.get_node("StabilizationBeam") as StabilizationBeam
	check(early_beam.enabled, "Restoration failed to auto-start Beam for early plate load")
	var early_release := early_chamber.get_node("BulkheadLoadRelay") as Interactable
	check(early_release.get("release_powered") and not early_release.get("latched"), "Early physical load did not power inactive release")
	check(not early_chamber.get_node("OperationsAtrium").get("services_online"), "Early plate load opened door automatically")
	early_player.position = Vector3(1.95, 0.92, 4.28)
	early_camera.look_at(early_release.global_position)
	await settle()
	check(early_cube.artificially_observed, "Startup Beam did not observe early plate load")
	await create_timer(0.8).timeout
	check(early_cube.current_destination_index == 1, "Startup Beam failed to hold early plate load")
	check(early_release.get("release_powered") and not early_chamber.get_node("OperationsAtrium").get("services_online"), "Early plate load opened door without interaction")
	check(early_ray.get_focused_interactable() == early_release, "Early loaded plate did not make wall release usable")
	early_beam.set_enabled(false)
	await create_timer(0.8).timeout
	check(early_cube.current_destination_index != 1, "Unobserved Cube stayed on plate with Beam off")
	check(not (early_chamber.get_node("AwakeningLoadPlate") as PressurePlate).is_active, "Plate failed to release when Cube moved")
	check(not early_release.get("release_powered"), "Door release remained powered after load left")
	check(early_ray.get_focused_interactable() != early_release, "Failed load left a misleading interaction target")
	early_release.interact()
	check(not early_chamber.get_node("BulkheadLoadRelay").get("latched"), "Interlock latched after an interrupted load")
	check(not early_chamber.get_node("OperationsAtrium").get("services_online"), "Interrupted load opened the bulkhead")
	# Immediate return is ordinarily excluded. Reobserve, let the Cube take one
	# other legal state, then use that state's direct-geometry selection view.
	var failed_state := early_cube.current_destination_index
	early_player.position = early_cube.position + Vector3(0, 0, 1.9)
	early_player.position.y = 0.92
	early_camera.look_at(early_cube.global_position)
	await settle()
	check(early_cube.directly_observed, "Failed load could not be reobserved for recovery")
	early_player.position = Vector3(0, 0.92, 4.6)
	early_camera.rotation = Vector3.ZERO
	var intermediate_view_found := false
	for angle_step in range(24):
		early_player.rotation.y = float(angle_step) * TAU / 24.0
		if not early_cube.call("_evaluate_current_observation") and early_cube.call("_choose_safe_destination") != -1:
			intermediate_view_found = true
			break
	check(intermediate_view_found, "No rearmed nonplate move available after failed load")
	if intermediate_view_found:
		await create_timer(0.8).timeout
		var intermediate_state := early_cube.current_destination_index
		check(intermediate_state != failed_state and intermediate_state != 1, "Failed load could not take an intervening legal state")
		if intermediate_state in selection_views:
			early_player.position = early_cube.position + Vector3(0, 0, 1.9)
			early_player.position.y = 0.92
			early_camera.look_at(early_cube.global_position)
			await settle()
			check(early_cube.directly_observed, "Intermediate recovery state could not be reobserved")
			early_player.position = selection_views[intermediate_state][0]
			early_player.rotation.y = deg_to_rad(selection_views[intermediate_state][1])
			early_camera.rotation = Vector3.ZERO
			await settle()
			check(early_cube.call("_choose_safe_destination") == 1, "Recovery view did not isolate plate")
			await create_timer(0.8).timeout
			check(early_cube.current_destination_index == 1, "Player could not recover plate after failed load")
	early_chamber.queue_free()
	await process_frame
	print("AWAKENING BEAM PLATE VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
