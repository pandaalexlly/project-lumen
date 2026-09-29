extends SceneTree

const OPENING := "res://scenes/world/opening/awakening_chamber.tscn"
const PLAYER_HEIGHT := 0.92
const PROBE_STEP := 0.35
const BEAM_WIDTH := 0.62

var failures: Array[String] = []
var chamber: Node3D
var hub: Node3D
var facility: Node3D
var player: CharacterBody3D


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func world_point(x: float, z: float, y: float = PLAYER_HEIGHT) -> Vector3:
	return hub.to_global(Vector3(x, y, z))


func route(label: String, points: Array[Vector2]) -> void:
	var tested := 0
	for index in range(points.size() - 1):
		var start := world_point(points[index].x, points[index].y)
		var finish := world_point(points[index + 1].x, points[index + 1].y)
		var length := start.distance_to(finish)
		var subdivisions := maxi(1, ceili(length / PROBE_STEP))
		for step in range(subdivisions):
			var from := start.lerp(finish, float(step) / subdivisions)
			var to := start.lerp(finish, float(step + 1) / subdivisions)
			if player.test_move(Transform3D(Basis.IDENTITY, from), to - from):
				check(false, "%s blocked near %s" % [label, str(hub.to_local(from))])
				return
			var ray := PhysicsRayQueryParameters3D.create(from + Vector3.UP * 0.2, from - Vector3.UP * 1.3)
			ray.exclude = [player.get_rid()]
			var floor_hit := player.get_world_3d().direct_space_state.intersect_ray(ray)
			if floor_hit.is_empty() or absf((floor_hit.get("position", Vector3.ZERO) as Vector3).y - hub.global_position.y) > 0.16:
				check(false, "%s unsupported near %s" % [label, str(hub.to_local(from))])
				return
			tested += 1
	check(tested > 0, label + " had no walking samples")
	print("ROUTE %s: %d capsule/support steps" % [label, tested])


func ray_hit(origin: Vector3, target: Vector3, ignore_assembly := false) -> Dictionary:
	var query := PhysicsRayQueryParameters3D.create(hub.to_global(origin), hub.to_global(target))
	query.exclude = [player.get_rid()]
	if ignore_assembly:
		var exclusions: Array[RID] = query.exclude
		exclusions.append_array((facility.get_node("CoherentAssembly") as CoherentAssembly).call("_assembly_collision_rids"))
		query.exclude = exclusions
	return player.get_world_3d().direct_space_state.intersect_ray(query)


func beam_corridor(label: String, origin_name: String, target_name: String) -> void:
	var origin := (facility.get_node("BeamTargets/" + origin_name) as Marker3D).global_position
	var target := (facility.get_node("BeamTargets/" + target_name) as Marker3D).global_position
	var direction := (target - origin).normalized()
	var side := Vector3(-direction.z, 0, direction.x).normalized()
	var tested := 0
	for horizontal in [-0.31, 0.0, 0.31]:
		for vertical in [-0.31, 0.0, 0.31]:
			var offset: Vector3 = side * float(horizontal) + Vector3.UP * float(vertical)
			var query := PhysicsRayQueryParameters3D.create(origin + offset, target + offset)
			var exclusions: Array[RID] = [player.get_rid()]
			exclusions.append_array((facility.get_node("CoherentAssembly") as CoherentAssembly).call("_assembly_collision_rids"))
			query.exclude = exclusions
			var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
			check(hit.is_empty(), "%s full-volume ray blocked by %s" % [label, str(hit.get("collider", "none"))])
			tested += 1
	print("BEAM %s: %d corridor rays, length %.3f m" % [label, tested, origin.distance_to(target)])


func candidate_envelopes() -> void:
	var parts: Array[Dictionary] = [
		{"name": "deck", "offset": Vector3(0, -0.1, 0), "size": Vector3(4, 0.2, 4)},
		{"name": "cube", "offset": Vector3(0, 0.65, -1.2), "size": Vector3(1, 1, 1)},
		{"name": "left post", "offset": Vector3(-1.75, 1.45, -2), "size": Vector3(0.2, 2.9, 0.2)},
		{"name": "right post", "offset": Vector3(1.75, 1.45, -2), "size": Vector3(0.2, 2.9, 0.2)},
		{"name": "lintel", "offset": Vector3(0, 2.9, -2), "size": Vector3(3.7, 0.2, 0.2)},
	]
	for receiver_name in ["A", "B", "C"]:
		var receiver := facility.get_node("Receivers/" + receiver_name) as Node3D
		for part in parts:
			var shape := BoxShape3D.new()
			shape.size = part["size"]
			var query := PhysicsShapeQueryParameters3D.new()
			query.shape = shape
			var offset: Vector3 = part["offset"]
			query.transform = Transform3D(Basis.IDENTITY, receiver.global_position + offset)
			var exclusions: Array[RID] = [player.get_rid()]
			exclusions.append_array((facility.get_node("CoherentAssembly") as CoherentAssembly).call("_assembly_collision_rids"))
			query.exclude = exclusions
			var hits := player.get_world_3d().direct_space_state.intersect_shape(query, 32)
			check(hits.is_empty(), "%s reserved %s overlaps fixed geometry: %s" % [receiver_name, part["name"], str(hits)])
		var bed := receiver.get_node("ReceivingBed") as StaticBody3D
		check(is_equal_approx(bed.global_position.y + bed.scale.y * 0.5, hub.global_position.y - 0.55), receiver_name + " receiving bed top changed")
	print("CANDIDATES: A/B/C deck, Cube, posts and lintel queried against real fixed collision")


func measure_i_to_c() -> void:
	var origin := (facility.get_node("BeamTargets/IOrigin") as Marker3D).global_position
	var target := (facility.get_node("BeamTargets/ICTarget") as Marker3D).global_position
	var hood := facility.get_node("Receivers/A/EastHoodSide") as StaticBody3D
	var hood_east := hood.global_position.x + hood.scale.x * 0.5
	var hood_north := hood.global_position.z + hood.scale.z * 0.5
	var t := (hood_north - origin.z) / (target.z - origin.z)
	var field_center_x := lerpf(origin.x, target.x, t)
	var side_x := absf((target.z - origin.z) / origin.distance_to(target)) * BEAM_WIDTH * 0.5
	var clearance := field_center_x - side_x - hood_east
	var wall_t := (hub.to_global(Vector3(0, 0, 43)).z - origin.z) / (target.z - origin.z)
	var wall_x := lerpf(origin.x, target.x, wall_t)
	var east_bound := -2.6 + hub.global_position.x
	var aperture_clearance := east_bound - (wall_x + side_x)
	print("I_C_CLEARANCE hood=%.3f m aperture_east=%.3f m" % [clearance, aperture_clearance])
	check(clearance >= 0.3, "I->C A-hood clearance below practical 0.30 m gate")
	check(aperture_clearance >= 0.3, "I->C aperture east clearance below practical 0.30 m gate")


func validate_d_standing_region() -> void:
	var passing := 0
	for eye_x in [-11.5, -11.0, -10.5]:
		for eye_z in [34.6, 35.0, 35.4]:
			var eye := Vector3(eye_x, 1.5, eye_z)
			var collar_open := ray_hit(eye, Vector3(-7.75, 2.6, 36), true).is_empty()
			var hidden := true
			for target in [Vector3(-6, 0.65, 36.8), Vector3(-6, 1.35, 38), Vector3(-6, 0, 38)]:
				var hit := ray_hit(eye, target, true)
				if hit.is_empty() or not str((hit.get("collider") as Node).name).begins_with("DScreen"):
					hidden = false
			if collar_open and hidden:
				passing += 1
	check(passing >= 6, "D collar-only sight depends on a narrow standing/camera position")
	var low := facility.get_node("Inspection/DScreenLow") as StaticBody3D
	var high := facility.get_node("Inspection/DScreenHigh") as StaticBody3D
	var south := facility.get_node("Inspection/DScreenSouth") as StaticBody3D
	var north := facility.get_node("Inspection/DScreenNorth") as StaticBody3D
	var opening_height := (high.position.y - high.scale.y * 0.5) - (low.position.y + low.scale.y * 0.5)
	var opening_width := (north.position.z - north.scale.z * 0.5) - (south.position.z + south.scale.z * 0.5)
	print("D_REGION: %d/9 standing samples, opening %.2f m horizontal x %.2f m vertical" % [passing, opening_width, opening_height])
	check(opening_width >= 0.85 and opening_height >= 0.8, "D opening below planned physical size")


func validate_fixed_dimensions() -> void:
	var approach := hub.get_node("WingApproaches/Records") as Node3D
	var left := approach.get_node("LeftWall") as StaticBody3D
	var right := approach.get_node("RightWall") as StaticBody3D
	var gate := approach.get_node("ParkedGate") as StaticBody3D
	var clear_width := gate.position.x - gate.scale.x * 0.5 - (left.position.x + left.scale.x * 0.5)
	check(clear_width >= 2.0, "Opened approach walking width under 2 m")
	var apron := facility.get_node("WalkingFloors/SharedApron") as StaticBody3D
	var sill := facility.get_node("Survey/SurveySill") as StaticBody3D
	var header := facility.get_node("Survey/ApertureHeader") as StaticBody3D
	var s_open_height := (header.position.y - header.scale.y * 0.5) - (sill.position.y + sill.scale.y * 0.5)
	var capsule := player.get_node("CollisionShape3D") as CollisionShape3D
	var body := capsule.shape as CapsuleShape3D
	print("DIMENSIONS: opened approach %.2f m; J %.2f m deep; S aperture %.2f x %.2f m; player capsule %.2f diameter x %.2f height" % [clear_width, apron.scale.z, sill.scale.x, s_open_height, body.radius * 2, body.height])
	check(apron.scale.z >= 3.0 and s_open_height >= 1.8, "Fixed apron or survey dimensions changed")
	check(body.radius <= 0.41 and body.height <= 1.81, "Player dimensions changed; route sample assumptions need revision")
	for name in ["InspectionPower", "InspectionAim", "ReturnPower"]:
		var control := facility.get_node(name) as StabilizationBeamSwitch
		var stand := control.position + Vector3(0, -0.13, -1.2)
		check(control.position.distance_to(stand + Vector3.UP * 0.13) < 3.0, name + " control exceeds interaction ray range")


func sweep_boarding_clearance(receiver_name: String, start: Vector3, finish: Vector3) -> void:
	var receiver := facility.get_node("Receivers/" + receiver_name) as Node3D
	var from := Transform3D(Basis.IDENTITY, receiver.to_global(start))
	check(not player.test_move(from, receiver.global_basis * (finish - start)), receiver_name + " reserved side crossing blocks the player capsule")


func walk_empty_bed_egress(name: String, start_local: Vector3, yaw: float, exit_axis: String, limit: float) -> void:
	player.position = hub.to_global(start_local)
	player.rotation.y = yaw
	player.velocity = Vector3.ZERO
	player.set_physics_process(true)
	await physics_frame
	await physics_frame
	Input.action_press("move_forward")
	var reached := false
	for frame in range(110):
		await physics_frame
		var local := hub.to_local(player.global_position)
		if local.y < -1.3:
			check(false, name + " empty-bed egress dropped player below the recess")
			break
		if (exit_axis == "z" and local.z <= limit) or (exit_axis == "x" and local.x <= limit):
			reached = true
			break
	Input.action_release("move_forward")
	player.set_physics_process(false)
	check(reached, name + " empty-bed egress cannot be walked without jump")
	if reached:
		check(absf(hub.to_local(player.global_position).y - PLAYER_HEIGHT) < 0.14, name + " egress did not reach ordinary floor height")
	print("EGRESS %s: reached=%s local=%s" % [name, str(reached), str(hub.to_local(player.global_position))])


func _run() -> void:
	chamber = load(OPENING).instantiate() as Node3D
	root.add_child(chamber)
	current_scene = chamber
	await physics_frame
	await physics_frame
	hub = chamber.get_node("OperationsAtrium") as Node3D
	facility = hub.get_node("ConnectedFacility") as Node3D
	player = chamber.get_node("Player") as CharacterBody3D
	player.set_physics_process(false)
	check(ProjectSettings.get_setting("application/run/main_scene") == OPENING, "F5 scene changed")
	check(facility.get_node_or_null("CoherentAssembly") is CoherentAssembly, "World assembly is missing")
	check(facility.get_node_or_null("InspectionBeam") is StabilizationBeam, "Inspection Beam is missing")
	check(facility.get_node_or_null("ReturnBeam") is StabilizationBeam, "Return Beam is missing")
	for name in ["Records", "Power", "Containment", "Signal"]:
		var wing := hub.get_node("WingApproaches/" + name)
		check(not wing.has_node("BackWall") and not wing.has_node("LockedGate"), name + " still has a sealed approach")
	# Opening's actual release behavior is covered by the protected Awakening suite.
	chamber.get_node("Shell/SealedBulkhead").position.y += 3.0
	await physics_frame
	route("Awakening-vestibule-H", [Vector2(0, -1), Vector2(0, 2), Vector2(0, 6), Vector2(-6, 10)])
	route("H-Records-D-J", [Vector2(-6, 10), Vector2(-15, 10), Vector2(-17, 10), Vector2(-20, 10), Vector2(-20, 29), Vector2(-19, 31.5), Vector2(-13, 31.5), Vector2(-11, 35), Vector2(-11, 33.5), Vector2(-5, 32)])
	route("H-Power-R-J", [Vector2(6, 10), Vector2(15, 10), Vector2(17, 10), Vector2(20, 10), Vector2(20, 29), Vector2(19, 31.5), Vector2(12, 31.5), Vector2(10.7, 32), Vector2(9.2, 32), Vector2(3, 32)])
	route("H-Containment-J", [Vector2(-4, 16), Vector2(-4, 21), Vector2(-6, 21), Vector2(-6, 26.5), Vector2(-6, 30.7), Vector2(-5, 32), Vector2(0, 32)])
	route("H-Signal-J", [Vector2(6, 19), Vector2(6, 26.5), Vector2(6, 30.7), Vector2(3, 32), Vector2(0, 32)])
	route("J-A-landing-V-S", [Vector2(-5, 32), Vector2(-3, 32), Vector2(-3, 35), Vector2(-2.8, 38.8), Vector2(-2.8, 41.8), Vector2(-2.8, 42)])
	route("J-B-landing", [Vector2(3, 32), Vector2(9.2, 32), Vector2(9.2, 38.8), Vector2(9.2, 32)])
	route("J-return-to-H", [Vector2(0, 32), Vector2(6, 30.7), Vector2(6, 26.5), Vector2(6, 19), Vector2(6, 10), Vector2(0, 6), Vector2(0, 2)])
	check(player.test_move(Transform3D(Basis.IDENTITY, world_point(-2.8, 42)), Vector3(0, 0, 2.0)), "S has an ordinary walking shortcut to the exterior")
	var gap_ray := ray_hit(Vector3(-3, 0.5, 44.5), Vector3(-3, -1, 44.5))
	check(gap_ray.is_empty(), "Service separation contains walkable floor")
	validate_d_standing_region()
	validate_fixed_dimensions()
	check(ray_hit(Vector3(-2.8, 1.5, 42), Vector3(-4.25, 2.6, 48)).is_empty(), "S cannot see C upper collar placement")
	var ground_hit := ray_hit(Vector3(-2.8, 1.5, 42), Vector3(-12, -0.2, 54))
	check(not ground_hit.is_empty() and str((ground_hit.get("collider") as Node).name).begins_with("Exterior"), "S cannot see onward fixed ground")
	for row in [["I-A", "IOrigin", "IATarget"], ["I-C", "IOrigin", "ICTarget"], ["R-B", "ROrigin", "RBTarget"]]:
		beam_corridor(row[0], row[1], row[2])
	measure_i_to_c()
	candidate_envelopes()
	sweep_boarding_clearance("A", Vector3(2.75, PLAYER_HEIGHT, 0.8), Vector3(0, PLAYER_HEIGHT, 0.8))
	sweep_boarding_clearance("B", Vector3(2.75, PLAYER_HEIGHT, 0.8), Vector3(0, PLAYER_HEIGHT, 0.8))
	sweep_boarding_clearance("C", Vector3(-2.75, PLAYER_HEIGHT, 0.8), Vector3(0, PLAYER_HEIGHT, 0.8))
	await walk_empty_bed_egress("A", Vector3(-6, 0.37, 35.7), 0.0, "z", 33.0)
	await walk_empty_bed_egress("B", Vector3(6, 0.37, 35.7), 0.0, "z", 33.0)
	await walk_empty_bed_egress("C", Vector3(-8.4, 0.37, 49), PI * 0.5, "x", -11.0)
	for name in ["A", "B", "C"]:
		var receiver := facility.get_node("Receivers/" + name) as Node3D
		var bed := receiver.get_node("ReceivingBed") as StaticBody3D
		var hood := receiver.get_node("HoodRear") as StaticBody3D
		check(hood.global_position.z - hood.scale.z * 0.5 - receiver.global_position.z >= 2.59, name + " rear fixed cover encroaches on member envelope")
		check(bed.scale.x >= 4.3 and bed.scale.z >= 4.3, name + " receiving bed too small")
	print("CONNECTED FACILITY VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
