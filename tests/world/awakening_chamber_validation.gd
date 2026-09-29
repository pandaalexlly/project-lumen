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


func _run() -> void:
	check(ProjectSettings.get_setting("application/run/main_scene") == CHAMBER, "F5 opening scene changed")
	var chamber := load(CHAMBER).instantiate() as Node3D
	root.add_child(chamber)
	current_scene = chamber
	await settle()
	if not chamber.has_node("OperationsAtrium"):
		push_error("Hub scene failed to instantiate")
		quit(1)
		return
	var player := chamber.get_node("Player") as CharacterBody3D
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var ray := camera.get_node("InteractionComponent") as InteractionComponent
	var cube := chamber.get_node("QuantumCube") as QuantumRelocator
	var control := chamber.get_node("Shell/ServiceControl") as Interactable
	var release := chamber.get_node("BulkheadLoadRelay") as Interactable
	var presentation := root.get_node("PresentationUI") as CanvasLayer
	player.set_physics_process(false)
	check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Bulkhead must contain player before restoration")
	check(not presentation.visible, "Prototype HUD visible in chamber")
	check(chamber.find_children("*", "Label", true, false).is_empty(), "Chamber contains UI labels")
	check(chamber.find_children("*", "Label3D", true, false).is_empty(), "Chamber contains text instructions")
	var beam := chamber.get_node("StabilizationBeam") as StabilizationBeam
	var plate := chamber.get_node("AwakeningLoadPlate") as PressurePlate
	var sources := get_nodes_in_group(ArtificialObservationSource.SOURCE_GROUP)
	var facility := chamber.get_node("OperationsAtrium/ConnectedFacility") as Node3D
	check(
		sources.size() == 3 and sources.has(beam)
		and sources.has(facility.get_node("InspectionBeam"))
		and sources.has(facility.get_node("ReturnBeam")),
		"Unexpected artificial observer in chamber or connected facility"
	)
	check(not beam.enabled, "Beam must be unpowered at arrival")
	var sensor_light := chamber.get_node("Lighting/RelocationSensorLight") as OmniLight3D
	var sensor_needle := chamber.get_node("StoryDressing/Workspaces/Containment/TransducerNeedle") as Node3D
	var needle_rest_rotation := sensor_needle.rotation.z
	root.get_node("AudioManager").call("notify_cube_relocation")
	await process_frame
	check(sensor_light.light_energy > 0.0, "Relocation event did not register on the local instrument")
	check(not is_equal_approx(sensor_needle.rotation.z, needle_rest_rotation), "Relocation event did not move the analogue needle")
	await create_timer(0.65).timeout
	check(is_zero_approx(sensor_light.light_energy), "Relocation instrument pulse did not settle")
	check(is_equal_approx(sensor_needle.rotation.z, needle_rest_rotation), "Relocation needle did not return to rest")
	await create_timer(3.2).timeout
	check(cube.successful_move_count == 0 and cube.directly_observed, "Cube must remain still at spawn")

	# The initial Cube closes the walkable service approach. Side and rear views
	# belong to independent fixed equipment rather than teleportable viewpoints.
	var service_entry := Vector3(0, 0.92, 2.25)
	var service_turn := Vector3(-0.24, 0.92, -1.45)
	var service_handle_view := Vector3(0.55, 0.92, -1.75)
	check(
		player.test_move(Transform3D(Basis.IDENTITY, service_entry), service_turn - service_entry),
		"Initial Cube must block the maintenance approach"
	)
	for outside_view in [
		service_entry,
		Vector3(-1.65, 0.92, 0.8),
		Vector3(2.05, 0.92, 0.8),
	]:
		player.position = outside_view
		camera.look_at(control.global_position)
		await settle()
		check(ray.get_focused_interactable() != control, "Handle visible from ordinary room approach")
		ray.try_interact()
		check(not chamber.get("restored"), "Restore possible without entering maintenance side")

	player.position = Vector3(0, 0.92, 4.35)
	camera.look_at(cube.global_position)
	await settle()
	camera.rotation.y += PI
	await create_timer(0.1).timeout
	camera.look_at(cube.global_position)
	await create_timer(0.4).timeout
	check(cube.successful_move_count == 0, "Short glance away should cancel relocation")
	camera.rotation.y += PI
	await create_timer(0.8).timeout
	check(cube.successful_move_count == 1, "Sustained look-away must relocate the Cube")
	check(cube.current_destination_index != 0, "Initial state did not change")

	# Relocation reveals an approach, not a control face from the room.
	player.position = service_entry
	camera.look_at(control.global_position)
	await settle()
	check(ray.get_focused_interactable() != control, "Relocation presented the handle as the room's direct answer")
	for index in range(1, cube.destination_paths.size()):
		cube.get_node("MoveTimer").stop()
		cube.call("_clear_pending_destination")
		cube.set("_current_destination_index", index)
		cube.call("_place_at_destination", index)
		await settle()
		var pocket_path := [service_entry, Vector3(-0.24, 0.92, 0), service_turn, service_handle_view]
		for step in range(pocket_path.size() - 1):
			check(
				not player.test_move(
					Transform3D(Basis.IDENTITY, pocket_path[step]),
					pocket_path[step + 1] - pocket_path[step]
				),
				"Destination %d blocks maintenance route segment %d" % [index, step]
			)
	for outer_approach in [
		Vector3(-1.65, 0.92, -1.75),
		Vector3(2.05, 0.92, -1.75),
		Vector3(0, 0.92, -3.05),
	]:
		check(
			player.test_move(
				Transform3D(Basis.IDENTITY, outer_approach),
				service_handle_view - outer_approach
			),
			"Maintenance pocket has an unguarded rear or side entrance"
		)

	# Enter the pocket and activate through the existing E/raycast path.
	player.position = service_handle_view
	camera.look_at(control.global_position)
	await settle()
	check(ray.get_focused_interactable() == control, "Maintenance-side handle cannot be focused")
	var press := InputEventAction.new()
	press.action = "interact"
	press.pressed = true
	Input.parse_input_event(press)
	await settle()
	press = InputEventAction.new()
	press.action = "interact"
	press.pressed = false
	Input.parse_input_event(press)
	check(chamber.get("restored"), "E did not restore the chamber")
	check(beam.enabled and chamber.get_node("BeamBreaker").get("supplied"), "Service isolator did not start the powered Beam")
	check(not chamber.get_node("OperationsAtrium").get("services_online"), "Handle opened the bulkhead without a load")
	check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Bulkhead opened on handle use")
	await create_timer(2.6).timeout
	check(not presentation.visible, "Restoration exposed HUD guidance")
	for light in chamber.get_node("Lighting/RestoredWorkLights").get_children():
		check(is_equal_approx(light.light_energy, chamber.get("restored_light_energy")), "Work light failed to restore")
	check(chamber.get("_fan_speed") > 0.0, "Ventilation did not restart")
	for face in chamber.get_node("Infrastructure/LiveInstrumentFaces").get_children():
		check(face.material_override.emission_energy_multiplier > 1.0, "Instrument supply failed to restore")
	var handle := control.get_node("Handle") as Node3D
	ray.try_interact()
	await settle()
	check(is_equal_approx(handle.rotation.y, PI * 0.5), "Repeated interaction toggled restored state")
	beam.set_enabled(false)

	# Fixture every resting state, then exercise the real observation/timer behavior.
	for index in range(cube.destination_paths.size()):
		cube.get_node("MoveTimer").stop()
		cube.call("_clear_pending_destination")
		cube.set("_current_destination_index", index)
		cube.set("_previous_destination_index", -1)
		cube.call("_place_at_destination", index)
		player.position = cube.position + Vector3(0, 0, 1.9)
		player.position.y = 0.92
		camera.look_at(cube.global_position)
		await settle()
		check(cube.directly_observed, "State %d cannot be found and observed" % index)
		var moves := cube.successful_move_count
		await create_timer(0.5).timeout
		check(cube.successful_move_count == moves, "Observed state %d moved" % index)
		camera.rotation.y += PI
		await create_timer(0.8).timeout
		check(cube.successful_move_count == moves + 1, "State %d cannot relocate after restoration" % index)

	# Capsule sweeps verify walkable routes into and out of the search pockets.
	cube.set_physics_process(false)
	cube.get_node("MoveTimer").stop()
	cube.call("_place_at_destination", 0)
	await settle()
	var route := [
		Vector3(0, 0.92, 4.35), Vector3(-3.6, 0.92, 3.0),
		Vector3(-4.1, 0.92, 0), Vector3(-4.1, 0.92, -3.8),
		Vector3(-4.1, 0.92, 0), Vector3(-3.6, 0.92, 3.0),
		Vector3(2.0, 0.92, 2.2), Vector3(3.7, 0.92, 0),
		Vector3(3.7, 0.92, -3.7), Vector3(3.7, 0.92, 0),
		Vector3(2.5, 0.92, 2.0), Vector3(2.5, 0.92, 4.6),
		Vector3(0, 0.92, 4.6),
	]
	for index in range(route.size() - 1):
		var from := Transform3D(Basis.IDENTITY, route[index])
		check(not player.test_move(from, route[index + 1] - route[index]), "Walking route segment %d blocked" % index)
	var exploration_loop := [
		Vector3(-4.1, 0.92, 0), Vector3(-4.1, 0.92, -5.1),
		Vector3(-1.5, 0.92, -5.1), Vector3(-1.5, 0.92, -1.0),
		Vector3(-1.5, 0.92, 2.4), Vector3(-3.1, 0.92, 3.85),
		Vector3(-4.1, 0.92, 3.0), Vector3(-4.1, 0.92, 0),
	]
	for index in range(exploration_loop.size() - 1):
		var from := Transform3D(Basis.IDENTITY, exploration_loop[index])
		check(not player.test_move(from, exploration_loop[index + 1] - exploration_loop[index]), "Exploration loop segment %d blocked" % index)
	# A physical load powers a separate release; it never opens the door by itself.
	cube.call("_place_at_destination", 1)
	cube.set("_current_destination_index", 1)
	beam.set_enabled(true)
	await settle()
	check(plate.is_active, "West-bay load plate did not detect the Cube")
	await create_timer(0.5).timeout
	check(release.get("release_powered") and not release.get("latched"), "Physical load did not enable the release")
	check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Load alone opened bulkhead")
	player.position = Vector3(1.95, 0.92, 4.28)
	camera.look_at(release.global_position)
	await settle()
	check(ray.get_focused_interactable() == release, "Powered release cannot be focused")
	ray.try_interact()
	await create_timer(3.5).timeout
	check(release.get("latched") and not player.test_move(Transform3D(Basis.IDENTITY, Vector3(0, 0.92, 4.6)), Vector3(0, 0, 3)), "Interacted bulkhead did not open")
	var hub := chamber.get_node("OperationsAtrium")
	check(hub.get("services_online"), "Hub did not receive restoration")
	for light in hub.get_node("RestoredLights").get_children():
		check(is_equal_approx(light.light_energy, hub.get("restored_light_energy")), "Hub circulation light did not restore")
	check(chamber.get_node("Shell/SealedBulkhead").has_node("JammedBulkheadBrace"), "Door dressing did not follow moving bulkhead")
	# A full hub loop, all four approaches, and a return to the opening use the same capsule.
	var hub_route: Array[Vector3] = [
		Vector3(0, 0.92, 4.6), Vector3(0, 0.92, 12),
		Vector3(-6, 0.92, 16), Vector3(-15, 0.92, 16),
		Vector3(-6, 0.92, 16), Vector3(-4, 0.92, 22),
		Vector3(-4, 0.92, 27), Vector3(-6, 0.92, 27), Vector3(-6, 0.92, 33),
		Vector3(-6, 0.92, 27), Vector3(6, 0.92, 27), Vector3(6, 0.92, 33),
		Vector3(6, 0.92, 27), Vector3(7, 0.92, 23), Vector3(6, 0.92, 16),
		Vector3(15, 0.92, 16), Vector3(6, 0.92, 16),
		Vector3(0, 0.92, 12), Vector3(0, 0.92, 4.6),
	]
	for index in range(hub_route.size() - 1):
		var from := Transform3D(Basis.IDENTITY, hub_route[index])
		check(not player.test_move(from, hub_route[index + 1] - hub_route[index]), "Hub traversal segment %d blocked" % index)
		var distance := hub_route[index].distance_to(hub_route[index + 1])
		for step in range(ceili(distance * 2.0) + 1):
			var sample := hub_route[index].lerp(hub_route[index + 1], minf(float(step) / (distance * 2.0), 1.0))
			var floor_ray := PhysicsRayQueryParameters3D.create(sample, sample - Vector3.UP * 1.1)
			floor_ray.exclude = [player.get_rid()]
			check(not player.get_world_3d().direct_space_state.intersect_ray(floor_ray).is_empty(), "Hub route has a floor gap at " + str(sample))
	for wing_name in ["Records", "Power", "Containment", "Signal"]:
		var wing := hub.get_node("WingApproaches/" + wing_name) as Node3D
		var from := Transform3D(wing.global_basis, wing.to_global(Vector3(0, 0.92, 2.7)))
		check(not player.test_move(from, wing.global_basis * Vector3(0, 0, 2)), wing_name + " approach blocks the continuous route")
		# The open approaches remain ordinary circulation without new controls.
		check(wing.find_children("*", "Interactable", true, false).is_empty(), wing_name + " adds a control")

	chamber.queue_free()
	await process_frame
	check(presentation.visible, "Chamber failed to restore prototype HUD on exit")
	for path in ["observation_lab", "stabilization_lab_discovery", "stabilization_lab_destination", "stabilization_lab_combined", "field_observation_site"]:
		check(load("res://scenes/prototype/%s.tscn" % path) is PackedScene, "Preserved prototype scene failed to load: " + path)
	print("AWAKENING VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
