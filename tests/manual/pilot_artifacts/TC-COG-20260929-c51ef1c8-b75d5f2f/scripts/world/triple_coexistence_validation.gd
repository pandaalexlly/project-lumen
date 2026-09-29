extends SceneTree

const PROBE := "res://scenes/tests/triple_coexistence_probe.tscn"
const MAIN_SCENE := "res://scenes/world/opening/awakening_chamber.tscn"
const PLAYER_OFFSET := Vector3(0, 0.92, 0)

var failures: Array[String] = []
var scene: Node3D
var player: CharacterBody3D
var camera: Camera3D


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func _run() -> void:
	scene = load(PROBE).instantiate() as Node3D
	root.add_child(scene)
	current_scene = scene
	await physics_frame
	await physics_frame
	player = scene.get_node("Player") as CharacterBody3D
	camera = player.get_node("Head/Camera3D") as Camera3D
	player.set_physics_process(false)
	_check(absf(player.position.x) < 5.2 and absf(player.position.z) < 4.0, "player does not start inside H0's Atrium")
	_check(ProjectSettings.get_setting("application/run/main_scene") == MAIN_SCENE, "F5 opening scene changed")
	_check(scene.get_script().resource_path == "res://scripts/world/triple_coexistence_probe.gd", "probe script is not isolated under scripts/world")
	_validate_stacks()
	await _validate_viewpoints()
	_validate_access()
	await _validate_live_walk()
	_validate_separation()
	_validate_no_screen_substitute(scene)
	await physics_frame
	await _validate_fixed_transforms()
	if failures.is_empty():
		print("PASS triple coexistence: fixed stacks, A/B sightlines, 3D parallax, H0 access, separation, isolation")
		quit(0)
	else:
		print("FAIL triple coexistence: %d issue(s)" % failures.size())
		quit(1)


func _validate_stacks() -> void:
	var facilities := scene.get_node("FixedFacilities") as Node3D
	_check(facilities.get_child_count() == 3, "expected exactly three facility stacks")
	var expected := {
		"H0": Vector3(0, 0, 0),
		"H1": Vector3(-18, 0, -8),
		"H2": Vector3(18, 0, -8),
	}
	for stack_name in ["H0", "H1", "H2"]:
		var stack := facilities.get_node(stack_name) as Node3D
		_check(stack.position.is_equal_approx(expected[stack_name]), stack_name + " fixed position changed")
		for part_name in ["Atrium", "QER", "Awakening", "IdentityCue"]:
			_check(stack.has_node(part_name), stack_name + " missing " + part_name)
		for target_name in ["Identity", "QER", "Awakening"]:
			_check(stack.get_node_or_null("ProofTargets/" + target_name) is Marker3D, stack_name + " missing " + target_name + " target")
		_check(stack.get_node("IdentityCue").get_child_count() >= 3, stack_name + " identity cue does not recur through the stack")
	_check(facilities.get_node("H0").global_position.distance_to(facilities.get_node("H1").global_position) > 18.0, "H0/H1 are not physically separated")
	_check(facilities.get_node("H0").global_position.distance_to(facilities.get_node("H2").global_position) > 18.0, "H0/H2 are not physically separated")
	print("STACKS: three distinct fixed QER/Atrium/Awakening assemblies")


func _validate_viewpoints() -> void:
	var viewpoints := scene.get_node("Viewpoints") as Node3D
	var a := viewpoints.get_node("A_InternalGallery") as Marker3D
	var b := viewpoints.get_node("B_ExternalOblique") as Marker3D
	_check(a.global_position.distance_to(b.global_position) > 15.0, "A and B are not meaningfully different viewpoints")
	for name in ["A_InternalGallery", "B_ExternalOblique"]:
		var marker := viewpoints.get_node(name) as Marker3D
		var eye_samples: Array[Vector3] = []
		if name.begins_with("A_"):
			for x in [-0.4, 0.0, 0.4]:
				eye_samples.append(marker.global_position + Vector3(x, 0, 0))
		else:
			for x in [12.0, 13.0, 14.0]:
				eye_samples.append(Vector3(x, marker.global_position.y, marker.global_position.z))
		for floor_position in eye_samples:
			player.global_position = floor_position + PLAYER_OFFSET
			player.rotation = Vector3.ZERO
			player.get_node("Head").rotation = Vector3.ZERO
			await physics_frame
			for stack_name in ["H0", "H1", "H2"]:
				var stack := scene.get_node("FixedFacilities/" + stack_name) as Node3D
				var identity := stack.get_node("ProofTargets/Identity") as Marker3D
				_check(camera.is_position_in_frustum(identity.global_position), "%s at %s cannot frame %s identity" % [name, str(floor_position), stack_name])
				for target_name in ["Identity", "QER", "Awakening"]:
					var target := stack.get_node("ProofTargets/" + target_name) as Marker3D
					var blocker := _first_hit_name(camera.global_position, target.global_position)
					_check(blocker.is_empty(), "%s at %s lacks real sightline to %s/%s (blocked by %s)" % [name, str(floor_position), stack_name, target_name, blocker])
					if name.begins_with("B_"):
						_check(camera.is_position_in_frustum(target.global_position), "%s cannot frame full %s/%s stack" % [name, stack_name, target_name])
		print("VIEW %s: three identities simultaneously framed; nine direct 3D sightlines across broad standing samples" % name)
	# The nearer H0 posts must shift against H1/H2 with lateral motion.
	var near_post := scene.get_node("H0Access/GalleryPost7") as Node3D
	var far_post := scene.get_node("FixedFacilities/H2/Atrium/FrontLeftPier") as Node3D
	var left_eye := Vector3(12.0, b.global_position.y + 1.52, b.global_position.z)
	var right_eye := Vector3(14.0, b.global_position.y + 1.52, b.global_position.z)
	var relative_left := _bearing(left_eye, near_post.global_position) - _bearing(left_eye, far_post.global_position)
	var relative_right := _bearing(right_eye, near_post.global_position) - _bearing(right_eye, far_post.global_position)
	_check(absf(relative_left - relative_right) > deg_to_rad(2.0), "external lateral walk provides negligible real parallax")
	print("PARALLAX: H0/H2 post relationship changes %.2f degrees across B" % rad_to_deg(absf(relative_left - relative_right)))


func _bearing(origin: Vector3, target: Vector3) -> float:
	return atan2(target.x - origin.x, origin.z - target.z)


func _first_hit_name(origin: Vector3, target: Vector3) -> String:
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [player.get_rid()]
	var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return ""
	return (hit["collider"] as Node).get_path()


func _validate_access() -> void:
	# A continuous floor-support sweep checks H0 ground, ramp, gallery,
	# return route and separate exterior apron. No jump is assumed.
	var route: Array[Vector3] = [
		Vector3(0, 0.92, 0),
		Vector3(0, 0.92, 5.5),
		Vector3(-7, 0.92, 6),
		Vector3(-7, 0.92, 24),
		Vector3(-4, 0.92, 24),
		Vector3(-4, 0.92, 23),
		Vector3(-4, 1.67, 20.5),
		Vector3(-4, 2.42, 18),
		Vector3(-4, 3.17, 15.5),
		Vector3(-4, 3.92, 13),
		Vector3(-3.5, 3.92, 11.9),
		Vector3(-4, 3.92, 13),
		Vector3(-4, 2.42, 18),
		Vector3(-4, 0.92, 23),
		Vector3(-4, 0.92, 24),
		Vector3(-7, 0.92, 24),
		Vector3(-7, 0.92, 6),
		Vector3(3, 0.92, 6),
		Vector3(3, 0.92, 28),
		Vector3(12, 0.92, 28),
	]
	var support_samples := 0
	for index in range(route.size() - 1):
		var start := route[index]
		var finish := route[index + 1]
		var steps := maxi(1, ceili(start.distance_to(finish) / 0.4))
		for step in range(steps + 1):
			var position := start.lerp(finish, float(step) / steps)
			var ray := PhysicsRayQueryParameters3D.create(position + Vector3.UP * 0.1, position - Vector3.UP * 1.2)
			ray.exclude = [player.get_rid()]
			var hit := player.get_world_3d().direct_space_state.intersect_ray(ray)
			_check(not hit.is_empty(), "H0 access unsupported near " + str(position))
			if not hit.is_empty():
				var floor_y: float = (hit["position"] as Vector3).y
				_check(absf(position.y - floor_y - 0.92) < 0.38, "H0 route needs a step or jump near %s (floor y %.2f)" % [str(position), floor_y])
				var clearance := PhysicsShapeQueryParameters3D.new()
				clearance.shape = (player.get_node("CollisionShape3D") as CollisionShape3D).shape
				# Lift the query slightly off the support surface so the sloped ramp
				# does not count its own floor as a capsule obstruction.
				clearance.transform = Transform3D(Basis.IDENTITY, Vector3(position.x, floor_y + 1.08, position.z))
				clearance.exclude = [player.get_rid()]
				_check(player.get_world_3d().direct_space_state.intersect_shape(clearance, 1).is_empty(), "H0 player capsule lacks clearance near " + str(position))
			support_samples += 1
	print("ACCESS: %d H0 floor/ramp/apron support samples from spawn through A to B" % support_samples)


func _validate_live_walk() -> void:
	player.global_position = Vector3(0, 0.92, 0)
	player.velocity = Vector3.ZERO
	player.set_physics_process(true)
	await physics_frame
	for target in [
		Vector2(0, 5.5),
		Vector2(-7, 6),
		Vector2(-7, 24),
		Vector2(-4, 24),
		Vector2(-4, 11.9),
		Vector2(-3.5, 11.9),
		Vector2(-4, 13),
		Vector2(-4, 23),
		Vector2(-4, 24),
		Vector2(-7, 24),
		Vector2(-7, 6),
		Vector2(3, 6),
		Vector2(3, 28),
		Vector2(12, 28),
	]:
		var reached := await _walk_to(target)
		_check(reached, "existing player controller cannot walk to " + str(target))
		if not reached:
			break
	Input.action_release("move_forward")
	player.set_physics_process(false)
	_check(player.global_position.y > 0.75 and player.global_position.y < 1.15, "player did not finish on the ground-level exterior apron")
	print("LIVE WALK: existing PlayerController traversed H0 ramp, A, return route, and B")


func _walk_to(target: Vector2) -> bool:
	var delta := Vector2(target.x - player.global_position.x, target.y - player.global_position.z)
	player.rotation.y = atan2(-delta.x, -delta.y)
	Input.action_press("move_forward")
	var max_frames := ceili(delta.length() / player.movement_speed * 90.0) + 90
	for frame in range(max_frames):
		await physics_frame
		var remaining := Vector2(target.x - player.global_position.x, target.y - player.global_position.z)
		if remaining.length() < 0.42:
			Input.action_release("move_forward")
			await physics_frame
			return true
		if player.global_position.y < -1.0:
			break
	Input.action_release("move_forward")
	print("WALK STOP near %s while targeting %s" % [str(player.global_position), str(target)])
	return false


func _validate_separation() -> void:
	for x in [-10.0, -9.0, -8.0, 8.0, 9.0, 10.0]:
		var query := PhysicsRayQueryParameters3D.create(Vector3(x, 2, -2), Vector3(x, -1, -2))
		query.exclude = [player.get_rid()]
		_check(player.get_world_3d().direct_space_state.intersect_ray(query).is_empty(), "walkable deck bridges H0 to a neighbor at x=%.1f" % x)
	_check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(4.2, 0.92, 0)), Vector3(4, 0, 0)), "H0 east wall allows a direct H2 shortcut")
	_check(player.test_move(Transform3D(Basis.IDENTITY, Vector3(-4.2, 0.92, 0)), Vector3(-4, 0, 0)), "H0 west wall allows a direct H1 shortcut")
	print("SEPARATION: open gaps and H0 walls prevent ordinary walking between fixed stacks")


func _validate_no_screen_substitute(node: Node) -> void:
	_check(not (node is SubViewport or node is Sprite3D or node is VideoStreamPlayer), "proof contains a screen/viewport substitute: " + node.name)
	if node is MeshInstance3D:
		_check((node as MeshInstance3D).mesh is BoxMesh, "proof uses non-greybox mesh: " + node.name)
	if node is Camera3D:
		_check(node == camera, "proof contains an extra camera feed: " + node.name)
	for child in node.get_children():
		_validate_no_screen_substitute(child)


func _validate_fixed_transforms() -> void:
	var bodies: Array[StaticBody3D] = []
	_collect_static(scene.get_node("FixedFacilities"), bodies)
	_collect_static(scene.get_node("H0Access"), bodies)
	var before: Dictionary = {}
	for body in bodies:
		before[body.get_path()] = body.global_transform
	await physics_frame
	await physics_frame
	for body in bodies:
		_check(body.global_transform.is_equal_approx(before[body.get_path()]), "fixed greybox piece moved: " + str(body.get_path()))
	print("FIXED: %d structural transforms stayed unchanged across physics frames" % bodies.size())


func _collect_static(node: Node, bodies: Array[StaticBody3D]) -> void:
	if node is StaticBody3D:
		bodies.append(node as StaticBody3D)
	for child in node.get_children():
		_collect_static(child, bodies)
