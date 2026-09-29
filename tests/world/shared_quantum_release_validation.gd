extends SceneTree

const FIXTURES := [
	["res://scenes/prototype/observation_lab.tscn", "DiscoveryChamber/DiscoveryCube"],
	["res://scenes/prototype/stabilization_lab_discovery.tscn", "QuantumCube"],
	["res://scenes/prototype/stabilization_lab_destination.tscn", "QuantumCube"],
	["res://scenes/prototype/stabilization_lab_combined.tscn", "QuantumCube"],
	["res://scenes/prototype/field_observation_site.tscn", "FieldQuantumCube"],
]

var failures: Array[String] = []


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func _run() -> void:
	for fixture in FIXTURES:
		var scene := (load(fixture[0]) as PackedScene).instantiate() as Node3D
		root.add_child(scene)
		current_scene = scene
		var cube := scene.get_node(fixture[1]) as QuantumRelocator
		var player := scene.get_node("Player") as CharacterBody3D
		var camera := player.get_node("Head/Camera3D") as Camera3D
		player.set_physics_process(false)
		cube.set_physics_process(false)
		if scene.has_node("StabilizationBeam"):
			(scene.get_node("StabilizationBeam") as StabilizationBeam).set_enabled(false)
		if scene.has_node("FacilityStabilizationBeam"):
			(scene.get_node("FacilityStabilizationBeam") as StabilizationBeam).set_enabled(false)
			player.position = cube.global_position + Vector3(0, 0.4, 2.5)
		await physics_frame
		await physics_frame
		check(is_equal_approx(cube.unobserved_delay, 0.05), "%s overrides shared release timing" % fixture[0])
		check(is_equal_approx(cube.destination_hidden_grace, 0.2), "%s lost hidden grace" % fixture[0])
		if scene.has_node("QuantumDoor"):
			var door := scene.get_node("QuantumDoor") as QuantumDoor
			check(is_equal_approx(door.unobserved_delay, 0.05), "QuantumDoor did not inherit shared release timing")
			check(is_equal_approx(door.destination_hidden_grace, 0.2), "QuantumDoor lost hidden grace")
		if scene.has_node("EntryQuantumDoor"):
			var entry_door := scene.get_node("EntryQuantumDoor") as QuantumDoor
			check(is_equal_approx(entry_door.unobserved_delay, 0.05), "Field gate did not inherit shared release timing")
		# Verify a reobserved short break cancels the timer in a real prototype scene.
		camera.look_at(cube.global_position)
		cube.set_physics_process(true)
		await physics_frame
		await physics_frame
		if cube.directly_observed:
			var before := cube.successful_move_count
			camera.rotation.y += PI
			await create_timer(0.1).timeout
			camera.look_at(cube.global_position)
			await create_timer(0.4).timeout
			check(cube.successful_move_count == before, "%s moved after brief occlusion and reobservation" % fixture[0])
			if fixture[0].ends_with("stabilization_lab_discovery.tscn") or fixture[0].ends_with("field_observation_site.tscn"):
				camera.rotation.y += PI
				await create_timer(0.8).timeout
				check(cube.successful_move_count == before + 1, "%s did not relocate after genuine release" % fixture[0])
		else:
			print("Visibility setup unavailable in %s; timing defaults and scene load checked" % fixture[0])
		scene.queue_free()
		await process_frame
	print("SHARED QUANTUM RELEASE VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
