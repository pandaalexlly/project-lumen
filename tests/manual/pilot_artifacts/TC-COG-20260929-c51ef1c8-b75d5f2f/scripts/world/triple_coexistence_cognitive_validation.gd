extends SceneTree

const SCENE_PATH := "res://scenes/tests/triple_coexistence_cognitive_probe.tscn"
const MAIN_SCENE := "res://scenes/world/opening/awakening_chamber.tscn"
const STACK_NAMES := ["H0", "H1", "H2"]
const STACK_CENTERS := {
	"H0": Vector3(0, 0, 0),
	"H1": Vector3(-18, 0, -8),
	"H2": Vector3(18, 0, -8),
}
const PLAYER_HEIGHT := 0.92

var failures: Array[String] = []
var scene: Node3D
var proof: Node3D
var player: CharacterBody3D
var camera: Camera3D
var original_transforms: Dictionary = {}


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func _run() -> void:
	scene = load(SCENE_PATH).instantiate() as Node3D
	root.add_child(scene)
	current_scene = scene
	await physics_frame
	await physics_frame
	proof = scene.get_node("Proof") as Node3D
	player = proof.get_node("Player") as CharacterBody3D
	camera = player.get_node("Head/Camera3D") as Camera3D
	player.set_physics_process(false)
	_check(ProjectSettings.get_setting("application/run/main_scene") == MAIN_SCENE, "F5 main scene changed")
	_check(scene.get_script().resource_path == "res://scripts/world/triple_coexistence_cognitive_probe.gd", "cognitive script not isolated")
	_check(proof.get_script().resource_path == "res://scripts/world/triple_coexistence_probe.gd", "original proof script changed")
	_check(scene.visit_phase == 0 and scene.handoff_count == 0, "visit sequence did not begin at H0")
	_validate_stacks_and_pockets()
	_validate_no_player_facing_labels(scene)
	_record_fixed_transforms()
	_validate_early_occlusion()
	await _validate_visit_cues()
	await _validate_handoffs()
	await _validate_live_sequence()
	await _validate_final_views()
	await _validate_live_walk()
	_validate_no_bridges()
	_validate_fixed_transforms()
	if failures.is_empty():
		print("PASS triple cognitive probe: H0/H1/H2 visits, occluded handoffs, fixed identities, A/B proof, isolated F5")
		quit(0)
	else:
		print("FAIL triple cognitive probe: %d issue(s)" % failures.size())
		quit(1)


func _validate_stacks_and_pockets() -> void:
	var facilities := proof.get_node("FixedFacilities") as Node3D
	var staging := scene.get_node("TestOnlyStaging") as Node3D
	_check(facilities.get_child_count() == 3, "expected exactly three fixed proof stacks")
	_check(staging.get_child_count() == 3, "expected three visit pockets")
	for name in STACK_NAMES:
		var stack := facilities.get_node(name) as Node3D
		var pocket := staging.get_node(name + "VisitPocket") as Node3D
		_check(stack.position.is_equal_approx(STACK_CENTERS[name]), name + " original stack position changed")
		_check(pocket.position.is_equal_approx(STACK_CENTERS[name]), name + " pocket does not match its stack")
		for part in ["Atrium", "QER", "Awakening", "IdentityCue", "ProofTargets"]:
			_check(stack.has_node(part), name + " missing " + part)
		for part in ["FixedInteriorPartition", "QERSupportColumn", "QERFloorBracket", "InboardRepairRear", "ArrivalReceiver", "SourceReceiver", "OccludedHandoff"]:
			_check(pocket.has_node(part), name + " missing " + part)
		_check(pocket.get_node("OccludedHandoff") is Area3D, name + " handoff is not an Area3D")
		var rear_position := Transform3D(Basis.IDENTITY, STACK_CENTERS[name] + Vector3(0, PLAYER_HEIGHT, 1.45))
		_check(player.test_move(rear_position, Vector3(0, 0, 2.0)), name + " can walk directly into exterior proof access before reveal")
	_check(absf(player.global_position.x) < 0.1 and absf(player.global_position.z) < 0.1 and player.global_position.y > 0.75 and player.global_position.y < 1.0, "player does not start inside H0 rear pocket")
	print("STACKS: three original QER/Atrium/Awakening units and separate interior visit pockets")


func _validate_no_player_facing_labels(node: Node) -> void:
	_check(not (node is Label3D or node is Label or node is RichTextLabel or node is CanvasLayer or node is SubViewport or node is Sprite3D or node is VideoStreamPlayer), "player-facing label, UI, or screen substitute: " + str(node.get_path()))
	for child in node.get_children():
		_validate_no_player_facing_labels(child)


func _record_fixed_transforms() -> void:
	for root_node in [proof.get_node("FixedFacilities"), proof.get_node("H0Access"), scene.get_node("TestOnlyStaging")]:
		_record_static_bodies(root_node)
	print("FIXED BASELINE: %d static pieces recorded" % original_transforms.size())


func _record_static_bodies(node: Node) -> void:
	if node is StaticBody3D:
		original_transforms[node.get_path()] = (node as StaticBody3D).global_transform
	for child in node.get_children():
		_record_static_bodies(child)


func _validate_fixed_transforms() -> void:
	for path in original_transforms:
		var body := root.get_node_or_null(path)
		_check(body is StaticBody3D, "static proof piece vanished: " + str(path))
		if body is StaticBody3D:
			_check((body as StaticBody3D).global_transform.is_equal_approx(original_transforms[path]), "static proof piece moved: " + str(path))
	print("FIXED: %d original/staging pieces remained fixed after all handoffs" % original_transforms.size())


func _validate_early_occlusion() -> void:
	var rays_checked := 0
	var clear_samples := 0
	var capsule_shape := (player.get_node("CollisionShape3D") as CollisionShape3D).shape
	for name in STACK_NAMES:
		var center: Vector3 = STACK_CENTERS[name]
		var source_prefix := str(proof.get_node("FixedFacilities/" + name).get_path())
		var staging_prefix := str(scene.get_node("TestOnlyStaging/" + name + "VisitPocket").get_path())
		var eye_samples: Array[Vector3] = []
		for x in [-4.4, -3.8, -3.0, -2.2, -1.4, -0.7, 0.0, 0.7, 1.4, 2.2, 3.0, 3.8, 4.4]:
			for z in [-3.2, -2.55, -1.8, -1.0, -0.3, 0.5, 1.2, 1.7]:
				var root_position := center + Vector3(x, PLAYER_HEIGHT, z)
				var clearance := PhysicsShapeQueryParameters3D.new()
				clearance.shape = capsule_shape
				clearance.transform = Transform3D(Basis.IDENTITY, root_position)
				clearance.exclude = [player.get_rid()]
				if not player.get_world_3d().direct_space_state.intersect_shape(clearance, 1).is_empty():
					continue
				var floor_ray := PhysicsRayQueryParameters3D.create(root_position + Vector3.UP * 0.1, root_position + Vector3.DOWN * 1.2)
				floor_ray.exclude = [player.get_rid()]
				if player.get_world_3d().direct_space_state.intersect_ray(floor_ray).is_empty():
					continue
				eye_samples.append(root_position + Vector3.UP * 0.6)
		_check(eye_samples.size() > 10, name + " has too few reachable prior-view samples")
		clear_samples += eye_samples.size()
		for eye in eye_samples:
			for other_name in STACK_NAMES:
				if other_name == name:
					continue
				for target_name in ["Identity", "QER", "Awakening"]:
					var target := proof.get_node("FixedFacilities/" + other_name + "/ProofTargets/" + target_name) as Marker3D
					var hit_path := _first_hit_path(eye, target.global_position)
					_check(hit_path.begins_with(source_prefix) or hit_path.begins_with(staging_prefix), "%s prior pocket leaks %s/%s from %s (first hit %s)" % [name, other_name, target_name, str(eye), hit_path])
					rays_checked += 1
	print("PRE-REVEAL: %d rays from %d capsule-clear, floor-supported visit positions blocked" % [rays_checked, clear_samples])


func _validate_visit_cues() -> void:
	for name in STACK_NAMES:
		player.global_position = STACK_CENTERS[name] + Vector3(0, PLAYER_HEIGHT, 0)
		player.rotation.y = PI
		player.get_node("Head").rotation = Vector3.ZERO
		await physics_frame
		var repair := scene.get_node("TestOnlyStaging/" + name + "VisitPocket/InboardRepairRear") as Node3D
		for child in repair.get_children():
			var detail := child as Node3D
			if detail.name == "PostCap":
				player.get_node("Head").rotation.x = deg_to_rad(18.0)
				await physics_frame
			_check(camera.is_position_in_frustum(detail.global_position), name + " inboard repair is not framed from visit center: " + detail.name)
			player.get_node("Head").rotation = Vector3.ZERO
		player.rotation.y = 0.0
		player.get_node("Head").rotation.x = deg_to_rad(20.0)
		await physics_frame
		var overhead := scene.get_node("TestOnlyStaging/" + name + "VisitPocket/QERFloorBracket") as Node3D
		_check(camera.is_position_in_frustum(overhead.global_position), name + " upper QER floor support is not discoverable by looking up")
		player.get_node("Head").rotation = Vector3.ZERO
	print("IDENTITY: each visit frames its repair and can inspect an upper QER floor support")
	player.global_position = Vector3(0, PLAYER_HEIGHT, 0)


func _validate_handoffs() -> void:
	for index in range(STACK_NAMES.size()):
		var source: String = STACK_NAMES[index]
		var area := scene.get_node("TestOnlyStaging/" + source + "VisitPocket/OccludedHandoff") as Area3D
		_check(scene.visit_phase == index, "wrong phase before " + source + " handoff")
		player.global_position = area.global_position + Vector3(0, PLAYER_HEIGHT - 1.0, 0)
		player.velocity = Vector3.ZERO
		for frame in range(4):
			await physics_frame
		_check(scene.visit_phase == index + 1, source + " Area3D failed to advance the sequence")
		_check(scene.handoff_count == index + 1, source + " handoff count incorrect")
		var destination: Vector3
		if index + 1 < STACK_NAMES.size():
			destination = STACK_CENTERS[STACK_NAMES[index + 1]] + Vector3(-2.2, PLAYER_HEIGHT, -2.55)
		else:
			destination = Vector3(0, PLAYER_HEIGHT, 3.15)
		_check(player.global_position.distance_to(destination) < 0.1, source + " arrived at wrong fixed facility/receiver")
		_validate_safe_arrival(source)
	print("HANDOFFS: actual area triggers visited H0 -> H1 -> H2 -> H0 front pocket")


func _validate_live_sequence() -> void:
	scene.visit_phase = 0
	scene.handoff_count = 0
	player.global_position = Vector3(0, PLAYER_HEIGHT, 0)
	player.velocity = Vector3.ZERO
	player.set_physics_process(true)
	await physics_frame
	for index in range(STACK_NAMES.size()):
		var name: String = STACK_NAMES[index]
		var center: Vector3 = STACK_CENTERS[name]
		if index > 0:
			for local_point in [Vector2(-2.2, -0.3), Vector2(-3.8, -0.3), Vector2(-3.8, 1.2), Vector2(0, 1.2), Vector2(0, 0)]:
				var exit_point := Vector2(center.x + local_point.x, center.z + local_point.y)
				var exit_reached := await _walk_to(exit_point)
				_check(exit_reached, name + " receiver exit is not controller-traversable at " + str(exit_point))
				if not exit_reached:
					player.set_physics_process(false)
					return
		for local_point in [Vector2(0, 1.1), Vector2(2.2, 1.1), Vector2(2.2, -0.3), Vector2(3.8, -0.3)]:
			var source_point := Vector2(center.x + local_point.x, center.z + local_point.y)
			var source_reached := await _walk_to(source_point)
			_check(source_reached, name + " source approach is not controller-traversable at " + str(source_point))
			if not source_reached:
				player.set_physics_process(false)
				return
		var triggered := await _walk_until_phase_change(index, Vector2(center.x + 3.8, center.z - 2.55))
		_check(triggered, name + " source cell cannot trigger through controller movement")
		if not triggered:
			player.set_physics_process(false)
			return
		_validate_safe_arrival(name + " live")
	player.set_physics_process(false)
	_check(scene.visit_phase == 3 and scene.handoff_count == 3, "live route did not finish at H0 proof access")
	print("LIVE SEQUENCE: controller walked all three visit pockets and triggered H0 -> H1 -> H2 -> H0")


func _walk_until_phase_change(previous_phase: int, target: Vector2) -> bool:
	var delta := Vector2(target.x - player.global_position.x, target.y - player.global_position.z)
	player.rotation.y = atan2(-delta.x, -delta.y)
	Input.action_press("move_forward")
	for frame in range(180):
		await physics_frame
		if scene.visit_phase == previous_phase + 1:
			Input.action_release("move_forward")
			await physics_frame
			return true
		if player.global_position.y < -1.0:
			break
	Input.action_release("move_forward")
	return false


func _validate_safe_arrival(source: String) -> void:
	var eye := player.global_position + Vector3.UP * 0.2
	var floor_query := PhysicsRayQueryParameters3D.create(eye, eye + Vector3.DOWN * 1.4)
	floor_query.exclude = [player.get_rid()]
	var floor_hit := player.get_world_3d().direct_space_state.intersect_ray(floor_query)
	_check(not floor_hit.is_empty(), source + " destination has no floor")
	if not floor_hit.is_empty():
		_check(absf((floor_hit["position"] as Vector3).y) < 0.1, source + " destination floor is not at atrium level")
	var capsule := PhysicsShapeQueryParameters3D.new()
	capsule.shape = (player.get_node("CollisionShape3D") as CollisionShape3D).shape
	capsule.transform = player.global_transform
	capsule.exclude = [player.get_rid()]
	_check(player.get_world_3d().direct_space_state.intersect_shape(capsule, 1).is_empty(), source + " destination intersects player capsule")


func _validate_final_views() -> void:
	_check(scene.visit_phase == 3, "proof viewpoint unlocked before third handoff")
	for view_name in ["A_InternalGallery", "B_ExternalOblique"]:
		var marker := proof.get_node("Viewpoints/" + view_name) as Marker3D
		player.global_position = marker.global_position + Vector3(0, PLAYER_HEIGHT, 0)
		player.rotation = Vector3.ZERO
		player.get_node("Head").rotation = Vector3.ZERO
		await physics_frame
		for name in STACK_NAMES:
			var identity := proof.get_node("FixedFacilities/" + name + "/ProofTargets/Identity") as Marker3D
			_check(camera.is_position_in_frustum(identity.global_position), view_name + " cannot frame " + name + " identity")
			for target_name in ["Identity", "QER", "Awakening"]:
				var target := proof.get_node("FixedFacilities/" + name + "/ProofTargets/" + target_name) as Marker3D
				var hit_path := _first_hit_path(camera.global_position, target.global_position)
				_check(hit_path.is_empty(), view_name + " sightline to " + name + "/" + target_name + " blocked by " + hit_path)
	print("PROOF: A and B keep all three original identities and nine direct stack sightlines")


func _validate_live_walk() -> void:
	player.global_position = Vector3(0, PLAYER_HEIGHT, 3.15)
	player.velocity = Vector3.ZERO
	player.set_physics_process(true)
	await physics_frame
	for target in [
		Vector2(0, 5.5), Vector2(-7, 6), Vector2(-7, 24),
		Vector2(-4, 24), Vector2(-4, 11.9), Vector2(-3.5, 11.9),
		Vector2(-4, 13), Vector2(-4, 23), Vector2(-4, 24),
		Vector2(-7, 24), Vector2(-7, 6), Vector2(3, 6),
		Vector2(3, 28), Vector2(12, 28),
	]:
		var reached := await _walk_to(target)
		_check(reached, "controller cannot walk from H0 return through A/B via " + str(target))
		if not reached:
			break
	Input.action_release("move_forward")
	player.set_physics_process(false)
	print("LIVE WALK: existing controller traversed final H0 return -> A -> B")


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
	return false


func _validate_no_bridges() -> void:
	for x in [-10.0, -9.0, -8.0, 8.0, 9.0, 10.0]:
		var ray := PhysicsRayQueryParameters3D.create(Vector3(x, 2, -2), Vector3(x, -1, -2))
		ray.exclude = [player.get_rid()]
		_check(player.get_world_3d().direct_space_state.intersect_ray(ray).is_empty(), "unintended walkable cross-stack bridge at x=" + str(x))
	print("SEPARATION: no floor bridge between fixed stacks")


func _first_hit_path(origin: Vector3, target: Vector3) -> String:
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [player.get_rid()]
	var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return ""
	return str((hit["collider"] as Node).get_path())
