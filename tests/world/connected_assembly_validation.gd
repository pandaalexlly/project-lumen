extends SceneTree

const WORLD := preload("res://scenes/world/opening/awakening_chamber.tscn")

var failures: Array[String] = []
var chamber: Node3D
var hub: Node3D
var facility: Node3D
var player: PlayerController
var camera: Camera3D
var assembly: CoherentAssembly
var manager: ObservationManager
var inspection: StabilizationBeam
var return_beam: StabilizationBeam
var inspection_power: StabilizationBeamSwitch
var inspection_aim: StabilizationBeamSwitch
var return_power: StabilizationBeamSwitch


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
		push_error(description)


func point(x: float, y: float, z: float) -> Vector3:
	return hub.to_global(Vector3(x, y, z))


func settle() -> void:
	await physics_frame
	await physics_frame
	await process_frame


func position_player(position: Vector3, target: Vector3) -> void:
	player.global_position = hub.to_global(position)
	player.velocity = Vector3.ZERO
	camera.look_at(hub.to_global(target))
	await create_timer(0.18).timeout
	await settle()


func member_visible(name: String) -> bool:
	var member := assembly.get_node("Members/" + name) as Node3D
	for probe in (member.get_node("VisibilityProbes") as Node3D).get_children():
		if manager.is_target_position_directly_visible_with_margin(
			assembly, (probe as Node3D).global_position, assembly.destination_viewport_margin
		):
			return true
	return false


func visible_probe_details(name: String) -> String:
	var found: Array[String] = []
	var member := assembly.get_node("Members/" + name) as Node3D
	for probe in (member.get_node("VisibilityProbes") as Node3D).get_children():
		var location := (probe as Node3D).global_position
		if manager.is_target_position_directly_visible_with_margin(assembly, location, assembly.destination_viewport_margin):
			found.append("%s(frustrum=%s)" % [probe.name, str(camera.is_position_in_frustum(location))])
	return ",".join(found)


func wait_for_configuration(index: int, seconds: float = 1.2) -> bool:
	var frames := ceili(seconds * Engine.physics_ticks_per_second)
	for frame in range(frames):
		if assembly.current_configuration_index == index:
			return true
		await physics_frame
	return assembly.current_configuration_index == index


func walk_forward(frames: int, yaw: float) -> void:
	player.rotation.y = yaw
	Input.action_press("move_forward")
	for frame in range(frames):
		await physics_frame
	Input.action_release("move_forward")
	await settle()


func press_interact() -> void:
	var event := InputEventAction.new()
	event.action = &"interact"
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame


func validate_fixed_access(label: String) -> void:
	var routes: Array[Array] = [
		[Vector2(-6, 10), Vector2(-15, 10), Vector2(-20, 10), Vector2(-20, 29), Vector2(-19, 31.5), Vector2(-11, 35)],
		[Vector2(6, 10), Vector2(15, 10), Vector2(20, 10), Vector2(20, 29), Vector2(19, 31.5), Vector2(10.7, 32)],
		[Vector2(-6, 26.5), Vector2(-6, 30.7), Vector2(-5, 32), Vector2(-3, 32), Vector2(-3, 35), Vector2(-2.8, 42)],
		[Vector2(6, 26.5), Vector2(6, 30.7), Vector2(3, 32), Vector2(9.2, 32), Vector2(9.2, 38.8)],
		[Vector2(-5, 32), Vector2(-3, 32), Vector2(-3, 38.8)],
	]
	var samples := 0
	for route in routes:
		for index in range(route.size() - 1):
			var start: Vector2 = route[index]
			var finish: Vector2 = route[index + 1]
			var count := maxi(1, ceili(start.distance_to(finish) / 0.35))
			for step in range(count):
				var from := start.lerp(finish, float(step) / count)
				var to := start.lerp(finish, float(step + 1) / count)
				var world_from := point(from.x, 0.92, from.y)
				var world_to := point(to.x, 0.92, to.y)
				if player.test_move(Transform3D(Basis.IDENTITY, world_from), world_to - world_from):
					check(false, "%s fixed route blocked near %s" % [label, str(from)])
					return
				var ray := PhysicsRayQueryParameters3D.create(world_from + Vector3.UP * 0.2, world_from - Vector3.UP * 1.3)
				ray.exclude = [player.get_rid()]
				var hit := player.get_world_3d().direct_space_state.intersect_ray(ray)
				if hit.is_empty() or absf((hit.get("position", Vector3.ZERO) as Vector3).y - hub.global_position.y) > 0.16:
					check(false, "%s fixed route lacks support near %s" % [label, str(from)])
					return
				samples += 1
	print("FIXED_ACCESS %s: %d capsule/support samples" % [label, samples])


func validate_beam_volume(label: String, beam: StabilizationBeam, target_name: String) -> void:
	var origin := (beam.get_node("EmitterOrigin") as Marker3D).global_position
	var target := (facility.get_node("BeamTargets/" + target_name) as Marker3D).global_position
	var direction := (target - origin).normalized()
	var side := Vector3(-direction.z, 0, direction.x).normalized()
	var exclusions: Array[RID] = [player.get_rid()]
	exclusions.append_array(assembly.call("_assembly_collision_rids"))
	for horizontal in [-0.31, 0.0, 0.31]:
		for vertical in [-0.31, 0.0, 0.31]:
			var offset: Vector3 = side * float(horizontal) + Vector3.UP * float(vertical)
			var query := PhysicsRayQueryParameters3D.create(origin + offset, target + offset)
			query.exclude = exclusions
			var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
			check(hit.is_empty(), "%s actual Beam volume blocked by %s" % [label, str(hit.get("collider", "none"))])
	check(beam.visual_length + 0.02 >= origin.distance_to(target), label + " visual field stops before target")
	print("ACTUAL_BEAM %s: 9 rays clear; origin=%s length=%.3f visual=%.3f" % [label, str(hub.to_local(origin)), origin.distance_to(target), beam.visual_length])


func validate_fresh_safety_cases() -> void:
	chamber.queue_free()
	await process_frame
	chamber = WORLD.instantiate() as Node3D
	root.add_child(chamber)
	current_scene = chamber
	hub = chamber.get_node("OperationsAtrium") as Node3D
	facility = hub.get_node("ConnectedFacility") as Node3D
	player = chamber.get_node("Player") as PlayerController
	camera = player.get_node("Head/Camera3D") as Camera3D
	manager = chamber.get_node("ObservationManager") as ObservationManager
	assembly = facility.get_node("CoherentAssembly") as CoherentAssembly
	inspection = facility.get_node("InspectionBeam") as StabilizationBeam
	return_beam = facility.get_node("ReturnBeam") as StabilizationBeam
	inspection_power = facility.get_node("InspectionPower") as StabilizationBeamSwitch
	inspection_aim = facility.get_node("InspectionAim") as StabilizationBeamSwitch
	return_power = facility.get_node("ReturnPower") as StabilizationBeamSwitch
	await settle()
	check(assembly.current_configuration_index == 0 and return_beam.enabled, "Fresh early-C setup is not initial A/R-on")
	var interaction := camera.get_node("InteractionComponent") as InteractionComponent
	await position_player(Vector3(-1.8, 0.92, 31.5), Vector3(-1.8, 1.05, 32.85))
	check(interaction.get_focused_interactable() == inspection_power, "I power control is not naturally ray-focusable")
	await press_interact()
	check(not inspection.enabled, "I power did not respond to E action")
	await press_interact()
	check(inspection.enabled, "I power did not restore through E action")
	await position_player(Vector3(-0.7, 0.92, 31.5), Vector3(-0.7, 1.05, 32.85))
	check(interaction.get_focused_interactable() == inspection_aim, "I aim control is not naturally ray-focusable")
	await press_interact()
	check(inspection_aim.using_secondary_aim, "I aim did not redirect through E action")
	await press_interact()
	check(not inspection_aim.using_secondary_aim, "I aim did not return through E action")
	await position_player(Vector3(10.7, 0.92, 31.5), Vector3(10.7, 1.05, 32.9))
	check(interaction.get_focused_interactable() == return_power, "R power control is not naturally ray-focusable")
	await press_interact()
	check(not return_beam.enabled, "R power did not respond to E action")
	await press_interact()
	check(return_beam.enabled, "R power did not restore through E action")
	print("CONTROLS: I power/aim and R power focused and responded to E")
	await validate_concealment_sweep("A", -6.0, 38.0, 2)
	await position_player(Vector3(-3, 0.92, 38.8), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "A boarding approach did not start on fixed landing")
	await walk_forward(36, PI * 0.5)
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "Controller-driven A side boarding did not reach full support")
	await walk_forward(5, PI)
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "Controller-driven rearward drift lost deck support")
	print("BOARDING: controller-driven A landing-to-deck support=%d local=%s" % [assembly.call("_support_state"), str(hub.to_local(player.global_position))])
	await position_player(Vector3(-4.02, 0.92, 38.8), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_UNSAFE, "Partial support was accepted in fresh world")
	inspection_power.interact()
	camera.look_at(point(8, 1.5, 38.8))
	await settle()
	check(not assembly.currently_observed, "Partial-support concealment still observes current A")
	check(not assembly.call("_is_candidate_legal", 2), "Partial support did not reject otherwise empty C")
	await create_timer(0.55).timeout
	check(assembly.current_configuration_index == 0 and assembly.successful_move_count == 0, "Partial support caused unsafe departure")
	await position_player(Vector3(-6, 0.92, 39.2), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL and assembly.directly_observed, "Full support/rearm failed after partial wait")
	inspection_aim.interact()
	inspection_power.interact()
	camera.look_at(point(-6, 1.5, 40.7))
	await settle()
	check(not assembly.currently_observed, "All-candidates-excluded pose sees current A")
	check(not assembly.call("_is_candidate_legal", 1) and not assembly.call("_is_candidate_legal", 2), "All-candidates-excluded setup left a legal placement")
	await create_timer(0.55).timeout
	check(assembly.current_configuration_index == 0, "No-safe-candidate case moved assembly")
	camera.look_at(point(-6, 0.65, 36.8))
	await settle()
	check(assembly.directly_observed, "Reobservation after no-safe wait failed")
	inspection_power.interact()
	var rider_block := StaticBody3D.new()
	rider_block.name = "TemporaryRiderArrivalBlock"
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.8, 1.2, 0.8)
	collision.shape = shape
	rider_block.add_child(collision)
	chamber.add_child(rider_block)
	rider_block.global_position = point(-6, 1.0, 51.2)
	await settle()
	check(assembly.call("_candidate_members_clear", (facility.get_node("Receivers/C") as Node3D).global_transform, true), "Rider-only blocker also strikes C members")
	check(not assembly.call("_mapped_passenger_clear", (facility.get_node("Receivers/C") as Node3D).global_transform), "Blocked C passenger capsule was accepted")
	camera.look_at(point(-6, 1.5, 40.7))
	await create_timer(0.55).timeout
	check(assembly.current_configuration_index == 0 and assembly.successful_move_count == 0, "Blocked passenger candidate committed")
	rider_block.queue_free()
	await settle()
	check(assembly.call("_is_candidate_legal", 2), "Removing C rider blocker did not restore legal candidate")
	check(await wait_for_configuration(2), "Fresh A did not permit first supported release to C")
	check(hub.to_local(player.global_position).distance_to(Vector3(-6, 0.92, 51.2)) < 0.12, "Early-C passenger pose was not preserved")
	print("FRESH_SAFETY: partial wait, both-candidates wait, rider block, and first supported C passed")


func validate_concealment_sweep(state_name: String, receiver_x: float, receiver_z: float, candidate_index: int) -> void:
	var full_support := 0
	var concealed := 0
	var legal_c := 0
	var misses: Array[String] = []
	for lateral in [-0.45, 0.0, 0.45]:
		for depth in [1.0, 1.2, 1.4]:
			player.global_position = point(receiver_x + float(lateral), 0.92, receiver_z + float(depth))
			player.velocity = Vector3.ZERO
			await settle()
			for yaw in [-15.0, 0.0, 15.0]:
				for pitch in [-12.0, 0.0, 15.0]:
					var direction := Vector3(sin(deg_to_rad(yaw)), tan(deg_to_rad(pitch)), cos(deg_to_rad(yaw)))
					camera.look_at(camera.global_position + direction * 10.0)
					await settle()
					var support_ok: bool = assembly.call("_support_state") == assembly.SUPPORT_FULL
					var concealed_ok: bool = not bool(assembly.call("_evaluate_current_observation"))
					var candidate_ok: bool = bool(assembly.call("_is_candidate_legal", candidate_index))
					full_support += int(support_ok)
					concealed += int(support_ok and concealed_ok)
					legal_c += int(support_ok and concealed_ok and candidate_ok)
					if not (support_ok and concealed_ok and candidate_ok) and misses.size() < 12:
						misses.append("x=%s z=%s yaw=%s pitch=%s support=%s concealed=%s candidate=%s visible=[%s,%s,%s,%s] deck_probes=%s" % [
							str(lateral), str(depth), str(yaw), str(pitch),
							str(support_ok), str(concealed_ok), str(candidate_ok),
							str(member_visible("Cube")), str(member_visible("Bearer")),
							str(member_visible("Cradle")), str(member_visible("Collar")),
							visible_probe_details("Cradle")
						])
	print("CONCEALMENT_SWEEP %s: support=%d/81 hidden=%d/81 passenger_candidate_legal=%d/81 misses=%s" % [state_name, full_support, concealed, legal_c, str(misses)])
	check(full_support == 81, state_name + " central deck stance/drift sweep lost physical support")
	check(legal_c >= 72, state_name + " passenger concealment is too narrow for ordinary stance/look variation")


func _run() -> void:
	chamber = WORLD.instantiate() as Node3D
	root.add_child(chamber)
	current_scene = chamber
	hub = chamber.get_node("OperationsAtrium") as Node3D
	facility = hub.get_node("ConnectedFacility") as Node3D
	player = chamber.get_node("Player") as PlayerController
	camera = player.get_node("Head/Camera3D") as Camera3D
	manager = chamber.get_node("ObservationManager") as ObservationManager
	assembly = facility.get_node("CoherentAssembly") as CoherentAssembly
	inspection = facility.get_node("InspectionBeam") as StabilizationBeam
	return_beam = facility.get_node("ReturnBeam") as StabilizationBeam
	inspection_power = facility.get_node("InspectionPower") as StabilizationBeamSwitch
	inspection_aim = facility.get_node("InspectionAim") as StabilizationBeamSwitch
	return_power = facility.get_node("ReturnPower") as StabilizationBeamSwitch
	await settle()
	var receiver_transforms: Array[Transform3D] = []
	for name in ["A", "B", "C"]:
		receiver_transforms.append((facility.get_node("Receivers/" + name) as Node3D).global_transform)
	var members := assembly.get_node("Members") as Node3D
	var member_transforms: Array[Transform3D] = []
	for member in members.get_children():
		member_transforms.append((member as Node3D).transform)
	var moves: Array[Dictionary] = []
	assembly.configuration_changed.connect(func(from_index: int, to_index: int, carried: bool) -> void:
		moves.append({"from": from_index, "to": to_index, "carried": carried,
			"assembly": assembly.global_transform, "player": player.global_transform})
	)
	check(assembly.current_configuration_index == 0, "Initial real-world configuration is not A")
	check(inspection.enabled and return_beam.enabled, "I/R initial power is not ON")
	check(assembly.artificially_observed, "I does not hold actual A")
	check(not assembly.call("_is_candidate_legal", 1, assembly.SUPPORT_OFF), "R does not exclude empty B")
	check(inspection.visual_length > 3.0 and return_beam.visual_length > 3.0, "Initial Beam visual fields stop before A/B collars")
	validate_beam_volume("I-A", inspection, "IATarget")
	validate_beam_volume("R-B", return_beam, "RBTarget")
	validate_fixed_access("A")
	print("INITIAL: state=%d I=%s R=%s I_origin=%s R_origin=%s" % [
		assembly.current_configuration_index, str(inspection.enabled), str(return_beam.enabled),
		str(hub.to_local((inspection.get_node("EmitterOrigin") as Marker3D).global_position)),
		str(hub.to_local((return_beam.get_node("EmitterOrigin") as Marker3D).global_position))
	])
	await position_player(Vector3(-2.8, 0.92, 42), Vector3(-4.25, 2.6, 48))
	check(not assembly.call("_is_candidate_legal", 2, assembly.SUPPORT_OFF), "Direct S view did not exclude prospective C collar")
	check(assembly.current_configuration_index == 0, "Prospective C sight disturbed I-held actual A")
	inspection_power.interact()
	var d_passing := 0
	for eye_x in [-11.5, -11.0, -10.5]:
		for eye_z in [34.6, 35.0, 35.4]:
			await position_player(Vector3(eye_x, 0.92, eye_z), Vector3(-7.75, 2.6, 36))
			var collar_only := member_visible("Collar") and not member_visible("Cube") and not member_visible("Bearer") and not member_visible("Cradle")
			check(collar_only and assembly.directly_observed, "Real D collar-only view failed at %s, %s" % [str(eye_x), str(eye_z)])
			d_passing += int(collar_only and assembly.directly_observed)
	print("D_REAL_REGION: %d/9 collar-only standing samples" % d_passing)
	await position_player(Vector3(-11, 0.92, 35), Vector3(-7.75, 2.6, 36))
	check(not member_visible("Cube"), "D also exposes real Cube")
	check(not member_visible("Bearer"), "D also exposes real bearer")
	check(not member_visible("Cradle"), "D also exposes real deck")
	check(member_visible("Collar"), "D cannot see real collar")
	check(assembly.directly_observed, "D collar-only view did not hold complete assembly")
	check(assembly.current_configuration_index == 0, "D collar-only view did not hold A")
	print("D_COLLAR: cube=%s bearer=%s deck=%s collar=%s direct=%s" % [
		str(member_visible("Cube")), str(member_visible("Bearer")),
		str(member_visible("Cradle")), str(member_visible("Collar")), str(assembly.directly_observed)
	])
	camera.look_at(point(-20, 1.5, 35))
	await settle()
	check(not assembly.currently_observed, "Matched D concealment still observes A")
	check(assembly.call("_is_candidate_legal", 2, assembly.SUPPORT_OFF), "C not legal from matched D concealment")
	check(await wait_for_configuration(2), "Matched D concealment did not permit empty A-to-C")
	validate_fixed_access("C")
	check(not moves.is_empty() and not moves[-1]["carried"], "Empty A-to-C unexpectedly carried player")
	for index in range(members.get_child_count()):
		check((members.get_child(index) as Node3D).transform.is_equal_approx(member_transforms[index]), "Member lost rigid local transform on empty move")
	for index in range(3):
		check((facility.get_node("Receivers/" + ["A", "B", "C"][index]) as Node3D).global_transform.is_equal_approx(receiver_transforms[index]), "Fixed receiver moved with assembly")
	print("D_RELEASE: state=%d passenger_support=%d" % [assembly.current_configuration_index, assembly.call("_support_state")])
	await position_player(Vector3(-6, 0.35, 39.2), Vector3(-6, 1.0, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_UNSAFE, "Empty A receiving recess was mistaken for travelling support")
	inspection_aim.interact()
	inspection_power.interact()
	await settle()
	check(assembly.current_configuration_index == 2 and assembly.artificially_observed, "I/C did not hold and rearm actual C")
	validate_beam_volume("I-C", inspection, "ICTarget")
	inspection_power.interact()
	await position_player(Vector3(-1.8, 0.92, 31.5), Vector3(-1.8, 1.5, 20))
	check(assembly.call("_is_candidate_legal", 0, assembly.SUPPORT_OFF), "A not legal for empty-C recall")
	check(await wait_for_configuration(0), "Empty C did not recall to A")
	print("EMPTY_C_RECALL: state=%d" % assembly.current_configuration_index)
	inspection_aim.interact()
	inspection_power.interact()
	await position_player(Vector3(-3, 0.92, 38.8), Vector3(-6, 0.65, 36.8))
	check(assembly.currently_observed, "A could not be rearmed after empty-C recall")
	return_power.interact()
	inspection_aim.interact()
	await settle()
	check(assembly.directly_observed and assembly.current_configuration_index == 0, "Current A moved despite direct observation after I redirected to C")
	check(not assembly.call("_is_candidate_legal", 2, assembly.SUPPORT_OFF), "I/C did not exclude prospective C")
	check(assembly.call("_is_candidate_legal", 1, assembly.SUPPORT_OFF), "B should be the legal empty alternative")
	await position_player(Vector3(-3, 0.92, 31.5), Vector3(-3, 1.5, 20))
	print("B_PREP: current=%s direct=%s artificial=%s candidate_B=%s candidate_C=%s support=%d" % [
		str(assembly.currently_observed), str(assembly.directly_observed), str(assembly.artificially_observed),
		str(assembly.call("_is_candidate_legal", 1, assembly.SUPPORT_OFF)),
		str(assembly.call("_is_candidate_legal", 2, assembly.SUPPORT_OFF)), assembly.call("_support_state")
	])
	check(await wait_for_configuration(1), "Empty A did not relocate to B when I excluded C")
	validate_fixed_access("B")
	check(not moves[-1]["carried"], "Empty A-to-B incorrectly carried player")
	print("EMPTY_B: state=%d" % assembly.current_configuration_index)
	return_power.interact()
	await settle()
	check(assembly.artificially_observed, "R did not hold/rearm actual B")
	check(not assembly.call("_is_candidate_legal", 2, assembly.SUPPORT_OFF), "I/C stopped excluding C during B recall")
	return_power.interact()
	check(await wait_for_configuration(0), "B did not recall to A with C excluded")
	print("B_RECALL: state=%d" % assembly.current_configuration_index)
	inspection_aim.interact()
	await position_player(Vector3(-3, 0.92, 38.8), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "A fixed landing was treated as assembly support")
	await position_player(Vector3(-4.02, 0.92, 38.8), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_UNSAFE, "A split landing/deck footprint was accepted")
	await position_player(Vector3(-6, 0.92, 39.2), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "A full deck support was not detected")
	check(assembly.directly_observed, "Aboard player did not remain an observer")
	inspection_aim.interact()
	await settle()
	check(assembly.current_configuration_index == 0, "Aboard sight did not hold after I redirected")
	check(not assembly.call("_is_candidate_legal", 2), "I/C did not exclude passenger C")
	camera.look_at(point(-6, 1.5, 40.7))
	await settle()
	check(not assembly.currently_observed, "A fixed hood did not conceal fully supported passenger view")
	check(assembly.call("_is_candidate_legal", 1), "Passenger B candidate failed in real receiver geometry")
	check(await wait_for_configuration(1), "Supported passenger did not arrive at B")
	check(moves[-1]["carried"], "B transition omitted its passenger")
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "Passenger lost deck support on B arrival")
	check(hub.to_local(player.global_position).distance_to(Vector3(6, 0.92, 39.2)) < 0.12, "B arrival did not preserve passenger local pose")
	check(moves[-1]["assembly"].is_equal_approx(assembly.global_transform), "B move signal preceded assembly placement")
	check((moves[-1]["player"] as Transform3D).origin.distance_to(point(6, 0.92, 39.2)) < 0.12, "B move signal preceded passenger placement")
	print("PASSENGER_B: state=%d support=%d local=%s" % [assembly.current_configuration_index, assembly.call("_support_state"), str(hub.to_local(player.global_position))])
	return_power.interact()
	await settle()
	await validate_concealment_sweep("B", 6.0, 38.0, 0)
	await walk_forward(6, 0.0)
	await walk_forward(43, -PI * 0.5)
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "B east dismount did not reach fixed support")
	check(hub.to_local(player.global_position).x > 8.2, "B east dismount did not clear assembly")
	await position_player(Vector3(10.7, 0.92, 31.5), Vector3(10.7, 1.5, 20))
	check(assembly.artificially_observed, "R failed to keep B held through dismount")
	return_power.interact()
	check(await wait_for_configuration(0), "B did not return empty after passenger dismounted")
	print("B_DISMOUNT_RECALL: state=%d" % assembly.current_configuration_index)
	inspection_aim.interact()
	return_power.interact()
	await position_player(Vector3(-6, 0.92, 39.2), Vector3(-6, 0.65, 36.8))
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "A support failed before C passenger test")
	inspection_power.interact()
	await settle()
	check(assembly.directly_observed and assembly.current_configuration_index == 0, "Aboard player sight failed after I switched off")
	camera.look_at(point(-6, 1.5, 40.7))
	await settle()
	check(not assembly.currently_observed, "C passenger release still sees current A")
	check(not assembly.call("_is_candidate_legal", 1), "R did not exclude passenger B")
	check(assembly.call("_is_candidate_legal", 2), "Passenger C candidate failed in real exterior receiver")
	check(await wait_for_configuration(2), "Supported passenger did not arrive at C")
	check(moves[-1]["carried"], "C transition omitted its passenger")
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "Passenger lost deck support on C arrival")
	check(hub.to_local(player.global_position).distance_to(Vector3(-6, 0.92, 51.2)) < 0.12, "C arrival did not preserve passenger local pose")
	check((moves[-1]["player"] as Transform3D).origin.distance_to(point(-6, 0.92, 51.2)) < 0.12, "C move signal preceded passenger placement")
	print("PASSENGER_C: state=%d support=%d local=%s" % [assembly.current_configuration_index, assembly.call("_support_state"), str(hub.to_local(player.global_position))])
	camera.look_at(point(-6, 0.65, 48.8))
	await settle()
	check(assembly.directly_observed, "C passenger could not look back and rearm actual assembly")
	inspection_aim.interact()
	inspection_power.interact()
	await settle()
	check(assembly.artificially_observed, "I/C did not hold actual C during concealment sweep")
	await validate_concealment_sweep("C", -6.0, 50.0, 0)
	await position_player(Vector3(-6, 0.92, 51.2), Vector3(-6, 0.65, 48.8))
	await walk_forward(6, 0.0)
	await walk_forward(43, PI * 0.5)
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "C west dismount did not reach fixed exterior support")
	check(hub.to_local(player.global_position).x < -8.7, "C west dismount did not clear assembly")
	var exterior_player_position := player.global_position
	camera.look_at(point(-6, 1.45, 48))
	await settle()
	check(assembly.directly_observed, "Exterior fixed ground cannot reobserve actual C")
	inspection_power.interact()
	camera.look_at(point(-18, 1.5, 51))
	check(await wait_for_configuration(0), "Exterior reobserved C did not return empty to A")
	check(player.global_position.distance_to(exterior_player_position) < 0.2, "Fixed-ground player was carried by empty C departure")
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "Exterior player lost fixed support after assembly departed")
	print("C_DISMOUNT_RETURN: state=%d player_local=%s" % [assembly.current_configuration_index, str(hub.to_local(player.global_position))])
	await validate_fresh_safety_cases()
	print("CONNECTED ASSEMBLY VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
