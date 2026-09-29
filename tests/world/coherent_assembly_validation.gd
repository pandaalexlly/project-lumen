extends SceneTree

const FIXTURE := preload("res://scenes/tests/coherent_assembly_feasibility.tscn")

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


func place_player(player: PlayerController, position: Vector3) -> void:
	player.global_position = position
	player.velocity = Vector3.ZERO
	await create_timer(0.18).timeout
	await settle()


func member_visible(assembly: CoherentAssembly, manager: ObservationManager, member_name: String) -> bool:
	var member := assembly.get_node("Members/" + member_name) as Node3D
	for probe in member.get_node("VisibilityProbes").get_children():
		if manager.is_target_position_directly_visible_with_margin(
			assembly, probe.global_position, assembly.destination_viewport_margin
		):
			return true
	return false


func candidate_member_visible(
	assembly: CoherentAssembly,
	manager: ObservationManager,
	member_name: String,
	placement: Transform3D
) -> bool:
	var member := assembly.get_node("Members/" + member_name) as Node3D
	for probe in member.get_node("VisibilityProbes").get_children():
		var candidate_position: Vector3 = placement * assembly.to_local(probe.global_position)
		if manager.is_position_directly_visible_ignoring_root(
			candidate_position, assembly.destination_viewport_margin, assembly
		):
			return true
	return false


func _run() -> void:
	var scene := FIXTURE.instantiate() as Node3D
	root.add_child(scene)
	current_scene = scene
	var assembly := scene.get_node("CoherentAssembly") as CoherentAssembly
	var player := scene.get_node("Player") as PlayerController
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var manager := scene.get_node("ObservationManager") as ObservationManager
	var beam := scene.get_node("StabilizationBeam") as StabilizationBeam
	var beam_b := scene.get_node("BeamB") as StabilizationBeam
	var beam_c := scene.get_node("BeamC") as StabilizationBeam
	beam.aim_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await settle()
	check(beam.enabled and assembly.artificially_observed, "Initial Beam does not hold assembly")
	check(
		beam.visual_length > beam.global_position.distance_to(
			assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position
		),
		"Beam visualization stops at an observing assembly member"
	)
	check(assembly.current_configuration_index == 0, "Initial configuration is not A")
	check(is_equal_approx(assembly.unobserved_delay, 0.05), "Shared release lead-in changed")
	check(is_equal_approx(assembly.destination_hidden_grace, 0.2), "Hidden grace changed")
	var fixed_route: Array[Vector3] = [
		Vector3(-4.4, 0.92, -0.5), Vector3(-2.4, 0.92, -0.5),
		Vector3(-2.4, 0.92, -4.1), Vector3(0, 0.92, -4.1),
		Vector3(13.6, 0.92, -4.1), Vector3(13.6, 0.92, -0.5),
		Vector3(10.5, 0.92, -0.5), Vector3(13.6, 0.92, -0.5),
		Vector3(13.6, 0.92, -4.1), Vector3(5.5, 0.92, -4.1),
		Vector3(5.5, 0.92, -14), Vector3(3.5, 0.92, -14),
	]
	for index in range(fixed_route.size() - 1):
		var collision := KinematicCollision3D.new()
		var route_blocked := player.test_move(
			Transform3D(Basis.IDENTITY, fixed_route[index]),
			fixed_route[index + 1] - fixed_route[index], collision
		)
		check(not route_blocked, "Fixed access route blocked at segment %d" % index)
		for sample in range(5):
			var point := fixed_route[index].lerp(fixed_route[index + 1], float(sample) / 4.0)
			var ray := PhysicsRayQueryParameters3D.create(
				Vector3(point.x, 0.12, point.z), Vector3(point.x, -0.18, point.z)
			)
			ray.exclude = [player.get_rid()]
			var support := player.get_world_3d().direct_space_state.intersect_ray(ray).get("collider") as Node
			check(
				support != null and scene.get_node("Fixed").is_ancestor_of(support),
				"Fixed access lacks elevated support on segment %d sample %d" % [index, sample]
			)
	var members := assembly.get_node("Members") as Node3D
	check(members.get_child_count() == 4, "Explicit membership does not contain four structural parts")
	var local_transforms: Array[Transform3D] = []
	for member in members.get_children():
		local_transforms.append(member.transform)

	beam.set_enabled(false)
	await place_player(player, Vector3(-4.4, 0.92, -3))
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "Fixed landing classified as passenger")
	camera.look_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await settle()
	check(member_visible(assembly, manager, "Cube"), "Current Cube body not visible")
	check(assembly.directly_observed, "Current Cube member did not hold assembly")
	var cube_center: Vector3 = assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position
	var behind_cube := cube_center + (cube_center - camera.global_position).normalized() * 1.5
	check(not manager.is_position_directly_visible_with_margin(behind_cube, assembly.destination_viewport_margin), "Source Cube did not occlude ordinary current-world ray")
	check(manager.is_position_directly_visible_ignoring_root(behind_cube, assembly.destination_viewport_margin, assembly), "Vacated-source candidate query kept departing Cube collider")
	var before := assembly.successful_move_count
	await create_timer(0.4).timeout
	check(assembly.successful_move_count == before, "Directly observed assembly moved")
	await place_player(player, Vector3(-4.4, 0.92, -0.5))
	var behind_fixed_screen := Vector3(-6.3, 1.2, -0.7)
	camera.look_at(behind_fixed_screen)
	await settle()
	check(not manager.is_position_directly_visible_ignoring_root(behind_fixed_screen, assembly.destination_viewport_margin, assembly), "Vacated-source query also removed independent fixed screen")
	camera.look_at(assembly.get_node("Members/Collar/VisibilityProbes/RightPostUpper").global_position)
	await settle()
	check(not member_visible(assembly, manager, "Cube"), "Diagnostic screen did not hide current Cube")
	check(member_visible(assembly, manager, "Collar"), "Diagnostic screen hid current collar")
	check(assembly.directly_observed, "Visible collar did not hold complete assembly")
	camera.look_at(assembly.get_node("Members/Cradle/VisibilityProbes/RearRight").global_position)
	await settle()
	check(not member_visible(assembly, manager, "Cube"), "Cradle-edge view also exposes Cube")
	check(member_visible(assembly, manager, "Cradle"), "Cradle edge is not visible")
	check(assembly.directly_observed, "Visible cradle edge did not hold complete assembly")

	# The test player moves from independent landing to a generous deck and
	# remains an ordinary observer while standing on that bearing surface.
	await place_player(player, Vector3(-8, 0.92, 1.2))
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "Broad deck did not provide full direct support")
	camera.look_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await settle()
	check(assembly.directly_observed, "Supported player gained observation immunity")
	var loose_crate := StaticBody3D.new()
	loose_crate.name = "UnrelatedLooseCargo"
	loose_crate.position = Vector3(-8, 0.25, 0.5)
	var loose_crate_shape := CollisionShape3D.new()
	var crate_box := BoxShape3D.new()
	crate_box.size = Vector3(1.2, 0.5, 1.2)
	loose_crate_shape.shape = crate_box
	loose_crate.add_child(loose_crate_shape)
	scene.add_child(loose_crate)
	await place_player(player, Vector3(-8, 1.42, 0.5))
	check(assembly.call("_support_state") == assembly.SUPPORT_UNSAFE, "Loose cargo granted recursive passenger support")
	loose_crate.queue_free()
	await place_player(player, Vector3(-8, 0.92, 1.2))
	await place_player(player, Vector3(-5.98, 0.92, 0))
	check(assembly.call("_support_state") == assembly.SUPPORT_UNSAFE, "Split support was treated as full/off")
	camera.look_at(player.global_position + Vector3(10, 0, 0))
	await create_timer(0.45).timeout
	check(assembly.successful_move_count == 0, "Ambiguous partial support allowed departure")
	await place_player(player, Vector3(-8, 0.92, 1.2))
	camera.look_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await settle()
	check(assembly.directly_observed, "Boarded Cube reobservation failed")
	camera.look_at(Vector3(-8, 1.5, 2.7))
	await settle()
	check(not assembly.directly_observed, "Fixed cover did not conceal all current members")
	await create_timer(0.1).timeout
	camera.look_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await create_timer(0.4).timeout
	check(assembly.successful_move_count == 0, "Short concealment inside grace moved assembly")
	camera.look_at(Vector3(-8, 1.5, 2.7))
	await settle()
	check(assembly.call("_arrival_view_concealed", scene.get_node("ConfigurationB").global_transform), "B arrival exposes participating geometry")
	check(assembly.call("_is_candidate_legal", 1), "Fully supported passenger has no legal B candidate")
	check(assembly.call("_is_candidate_legal", 2), "Fully supported passenger has no legal C candidate")
	var committed_states: Array[Dictionary] = []
	assembly.configuration_changed.connect(func(from_index: int, to_index: int, carried: bool) -> void:
		committed_states.append({"from": from_index, "to": to_index, "carried": carried,
			"assembly": assembly.global_transform, "player": player.global_transform})
	)
	beam_c.set_enabled(true)
	await settle()
	check(not assembly.currently_observed, "Candidate Beam also held current A")
	check(not assembly.call("_is_candidate_legal", 2), "Beam did not exclude prospective C member")
	check(assembly.call("_is_candidate_legal", 1), "Beam C incorrectly excluded B")
	for frame in range(15):
		if assembly.get("_pending_index") == 1:
			break
		await physics_frame
	check(assembly.get("_pending_index") == 1, "Legal B was not selected for grace")
	var member_block := StaticBody3D.new()
	member_block.name = "CandidateMemberBlock"
	member_block.position = Vector3(8, 0.65, -1.2)
	var member_block_shape := CollisionShape3D.new()
	var member_box := BoxShape3D.new()
	member_box.size = Vector3(0.8, 0.8, 0.8)
	member_block_shape.shape = member_box
	member_block.add_child(member_block_shape)
	scene.add_child(member_block)
	await settle()
	check(not assembly.call("_candidate_members_clear", scene.get_node("ConfigurationB").global_transform, true), "Fixed obstruction did not reject a structural member")
	check(not assembly.call("_is_candidate_legal", 1), "Member-overlapping candidate stayed legal")
	await create_timer(0.4).timeout
	check(assembly.successful_move_count == 0 and committed_states.is_empty(), "Late candidate obstruction caused a partial or stale commit")
	check(assembly.get("_pending_index") == -1, "Unsafe pending candidate kept its hidden grace")
	member_block.queue_free()
	await settle()
	check(assembly.call("_is_candidate_legal", 1), "Removing member obstruction did not restore B")
	var rider_block := StaticBody3D.new()
	rider_block.name = "RiderOnlyArrivalBlock"
	rider_block.position = Vector3(8, 1.0, 1.2)
	var rider_block_shape := CollisionShape3D.new()
	var rider_box := BoxShape3D.new()
	rider_box.size = Vector3(0.8, 1.2, 0.8)
	rider_block_shape.shape = rider_box
	rider_block.add_child(rider_block_shape)
	scene.add_child(rider_block)
	await settle()
	check(assembly.call("_candidate_members_clear", scene.get_node("ConfigurationB").global_transform, false), "Rider-only blocker also overlaps assembly")
	check(not assembly.call("_mapped_passenger_clear", scene.get_node("ConfigurationB").global_transform), "Blocked passenger capsule was accepted")
	check(not assembly.call("_is_candidate_legal", 1), "Passenger collision did not reject B")
	await create_timer(0.5).timeout
	check(assembly.successful_move_count == 0 and committed_states.is_empty(), "No-safe-candidate case partially committed")
	rider_block.queue_free()
	await settle()
	check(assembly.call("_is_candidate_legal", 1), "Removing passenger obstruction did not restore B")
	await create_timer(0.75).timeout
	check(assembly.current_configuration_index == 1, "One legal candidate did not select B")
	check(assembly.successful_move_count == 1, "Passenger transition count incorrect")
	check(player.global_position.distance_to(Vector3(8, 0.92, 1.2)) < 0.08, "Passenger local pose not transported to B")
	check(committed_states.size() == 1 and committed_states[0]["carried"], "Atomic passenger commit signal missing")
	if committed_states.size() == 1:
		check(committed_states[0]["assembly"].is_equal_approx(assembly.global_transform), "Commit signal preceded root placement")
		check(committed_states[0]["player"].is_equal_approx(player.global_transform), "Commit signal preceded passenger placement")
	for index in range(members.get_child_count()):
		check(members.get_child(index).transform.is_equal_approx(local_transforms[index]), "Member %d lost rigid local transform" % index)
	await create_timer(0.45).timeout
	check(assembly.successful_move_count == 1, "Assembly hopped twice while unobserved")
	beam_b.aim_at(assembly.get_node("Members/Collar/VisibilityProbes/RightPostUpper").global_position)
	beam_b.set_enabled(true)
	await settle()
	check(assembly.artificially_observed, "Beam on non-Cube member did not hold/rearm B")
	await place_player(player, Vector3(-4.4, 0.92, -0.5))
	var a_placement: Transform3D = (scene.get_node("ConfigurationA") as Node3D).global_transform
	camera.look_at(a_placement * Vector3(1.75, 2.6, -2))
	await settle()
	check(not candidate_member_visible(assembly, manager, "Cube", a_placement), "Prospective Cube leaked through diagnostic screen")
	check(candidate_member_visible(assembly, manager, "Collar", a_placement), "Prospective collar not directly visible")
	check(not assembly.call("_is_candidate_legal", 0), "Visible prospective collar did not exclude complete A")
	await place_player(player, Vector3(-4.4, 0.92, 0.2))
	camera.look_at(a_placement * Vector3(1.96, 0.0, 1.96))
	await settle()
	check(not candidate_member_visible(assembly, manager, "Cube", a_placement), "Prospective cradle view also sees Cube")
	check(candidate_member_visible(assembly, manager, "Cradle", a_placement), "Prospective cradle edge not visible")
	check(not assembly.call("_is_candidate_legal", 0), "Visible prospective cradle did not exclude complete A")
	await place_player(player, Vector3(8, 0.92, 1.2))
	camera.look_at(Vector3(8, 1.5, 2.7))
	await settle()
	check(assembly.call("_support_state") == assembly.SUPPORT_FULL, "B rider could not reboard for return")
	beam_b.set_enabled(false)
	await settle()
	check(not assembly.currently_observed, "Beam remained on current B after redirect")
	check(assembly.call("_is_candidate_legal", 0), "Previous A remained banned after reobservation")
	check(not assembly.call("_is_candidate_legal", 2), "C exclusion lost during return")
	await create_timer(0.75).timeout
	check(assembly.current_configuration_index == 0, "Previous A did not become reachable")
	check(player.global_position.distance_to(Vector3(-8, 0.92, 1.2)) < 0.08, "Return did not map passenger pose")

	# A player on independent floor is not carried. The same fixed controls
	# then recover the empty assembly without a reset or previous-state ban.
	camera.look_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	await settle()
	check(assembly.directly_observed, "Actual A could not rearm after return")
	await place_player(player, Vector3(0, 0.92, -3.4))
	camera.look_at(player.global_position + Vector3(0, 0, -10))
	await settle()
	check(assembly.call("_support_state") == assembly.SUPPORT_OFF, "Independent floor was not recognized after dismount")
	check(assembly.call("_is_candidate_legal", 1), "Empty B candidate unavailable")
	check(not assembly.currently_observed, "Empty release still has a current observer")
	check(not assembly.get("_moved_this_unobserved_period"), "Actual A reobservation did not rearm empty release")
	var player_stayed := player.global_position
	await create_timer(0.75).timeout
	check(assembly.current_configuration_index == 1, "Unboarded assembly did not move to sole legal B")
	check(player.global_position.distance_to(player_stayed) < 0.04, "Independent player was carried")
	check(committed_states.size() == 3 and not committed_states[2]["carried"], "Empty atomic transition was not reported")
	beam.set_enabled(true)
	beam_b.aim_at(assembly.get_node("Members/Cube/VisibilityProbes/Center").global_position)
	beam_b.set_enabled(true)
	await settle()
	check(assembly.artificially_observed, "Actual B could not be Beam-rearmed")
	beam_b.set_enabled(false)
	await settle()
	check(not assembly.call("_is_candidate_legal", 0) and not assembly.call("_is_candidate_legal", 2), "Observed alternatives remained legal")
	var moves_before_block := assembly.successful_move_count
	await create_timer(0.5).timeout
	check(assembly.successful_move_count == moves_before_block, "Assembly moved with every candidate observed")
	beam.set_enabled(false)
	await settle()
	check(assembly.call("_is_candidate_legal", 0), "Removing A exclusion did not restore legal return")
	await create_timer(0.75).timeout
	check(assembly.current_configuration_index == 0, "Empty B could not return to previous A")
	beam_c.set_enabled(false)
	beam.set_enabled(true)
	await settle()
	check(assembly.artificially_observed, "Empty A could not be rearmed")
	beam.set_enabled(false)
	await settle()
	check(assembly.call("_is_candidate_legal", 1) and assembly.call("_is_candidate_legal", 2), "Multiple legal candidates were not available")
	await create_timer(0.75).timeout
	check(assembly.current_configuration_index in [1, 2], "Multiple-candidate choice left legal set")

	for index in range(members.get_child_count()):
		check(members.get_child(index).transform.is_equal_approx(local_transforms[index]), "Member local transform changed before transition")

	scene.queue_free()
	await process_frame

	# Independent fixture: C is a real third resting state, supports a rider,
	# and can be recalled empty through fixed, accessible observer stations.
	var c_scene := FIXTURE.instantiate() as Node3D
	root.add_child(c_scene)
	current_scene = c_scene
	var c_assembly := c_scene.get_node("CoherentAssembly") as CoherentAssembly
	var c_player := c_scene.get_node("Player") as PlayerController
	var c_camera := c_player.get_node("Head/Camera3D") as Camera3D
	var c_beam_a := c_scene.get_node("StabilizationBeam") as StabilizationBeam
	var c_beam_b := c_scene.get_node("BeamB") as StabilizationBeam
	var c_beam_c := c_scene.get_node("BeamC") as StabilizationBeam
	await place_player(c_player, Vector3(-8, 0.92, 1.2))
	c_camera.look_at(Vector3(-8, 1.5, 2.7))
	c_beam_b.set_enabled(true)
	await settle()
	check(c_assembly.call("_support_state") == c_assembly.SUPPORT_FULL, "C trial did not start with full support")
	check(not c_assembly.call("_is_candidate_legal", 1) and c_assembly.call("_is_candidate_legal", 2), "C trial did not isolate third state")
	c_beam_a.set_enabled(false)
	await create_timer(0.75).timeout
	check(c_assembly.current_configuration_index == 2, "Supported player did not reach C")
	check(c_player.global_position.distance_to(Vector3(0, 0.92, -12.8)) < 0.08, "C passenger pose was not preserved")
	c_beam_c.set_enabled(true)
	await settle()
	check(c_assembly.artificially_observed, "C inspection Beam could not rearm actual C")
	c_beam_c.set_enabled(false)
	await settle()
	check(c_assembly.call("_is_candidate_legal", 0), "Previous A unavailable from C")
	await create_timer(0.75).timeout
	check(c_assembly.current_configuration_index == 0, "Supported C could not return to A")
	c_beam_a.set_enabled(true)
	await settle()
	await place_player(c_player, Vector3(0, 0.92, -3.4))
	c_camera.look_at(c_player.global_position + Vector3(10, 0, 0))
	await settle()
	check(c_assembly.call("_support_state") == c_assembly.SUPPORT_OFF, "C empty trial player lacks fixed support")
	check(c_assembly.call("_is_candidate_legal", 2), "Empty C candidate unavailable from fixed circulation")
	c_beam_a.set_enabled(false)
	await create_timer(0.75).timeout
	check(c_assembly.current_configuration_index == 2, "Empty C departure failed")
	check(c_player.global_position.distance_to(Vector3(0, 0.92, -3.4)) < 0.08, "Empty C departure carried independent player")
	c_beam_c.set_enabled(true)
	await settle()
	check(c_assembly.artificially_observed, "Empty C could not be reobserved from fixed source")
	c_beam_c.set_enabled(false)
	await settle()
	check(c_assembly.call("_is_candidate_legal", 0), "Empty C recall cannot reach A")
	await create_timer(0.75).timeout
	check(c_assembly.current_configuration_index == 0, "Empty C could not be recalled to A")
	c_scene.queue_free()
	await process_frame
	print("COHERENT ASSEMBLY VALIDATION: %s" % ("PASS" if failures.is_empty() else str(failures)))
	quit(0 if failures.is_empty() else 1)
