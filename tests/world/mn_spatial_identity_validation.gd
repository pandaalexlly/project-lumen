extends SceneTree

const PROBE_SCENE := preload("res://scenes/tests/mn_spatial_identity_probe.tscn")

var failures: Array[String] = []


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)


func _wait_for_physics(seconds: float) -> void:
	await create_timer(seconds).timeout
	await physics_frame
	await physics_frame


func _run() -> void:
	var probe := PROBE_SCENE.instantiate() as Node3D
	root.add_child(probe)
	current_scene = probe
	var player := probe.get_node("Player") as PlayerController
	var room_m := probe.get("room_m") as Node3D
	var room_n := probe.get("room_n") as Node3D
	var fixed := probe.get_node("FixedWorld") as Node3D
	var manager := probe.get_node("ObservationManager") as ObservationManager
	var plant_transform := (fixed.get_node("CentralPlant") as Node3D).global_transform
	var a_transform := (fixed.get_node("ReceiverA") as Node3D).global_transform
	var b_transform := (fixed.get_node("ReceiverB") as Node3D).global_transform
	_check(room_m != null and room_n != null, "Both persistent room shells must exist")
	_check(room_m.global_position.is_equal_approx(Vector3(-5.5, 0, -1)), "M did not start at A")
	_check(room_n.global_position.is_equal_approx(Vector3(5.5, 0, -1)), "N did not start at B")
	_check(room_m.has_node("IntegratedVerticalRepair"), "M identity repair is missing")
	_check(room_m.has_node("RearDoorLintel"), "M's existing doorway is missing")
	_check(room_m.has_node("FrontVerticalSplice"), "M long-distance splice is missing")
	_check(room_m.has_node("FrontSpliceFoot"), "M close footing detail is missing")
	_check(room_n.has_node("IntegratedWoundHigh"), "N identity wound is missing")
	_check(room_n.has_node("SolidRearFace"), "N's solid rear face is missing")
	_check(room_n.has_node("FrontHorizontalReinforcement"), "N long-distance reinforcement is missing")
	_check(room_n.has_node("FrontFloorJointPatch"), "N close floor detail is missing")
	_check(fixed.has_node("LeftInspectionApron") and fixed.has_node("RightInspectionApron"), "Paired fixed inspection aprons are missing")

	player.global_position = Vector3(0, 0.92, 9.2)
	player.rotation = Vector3.ZERO
	player.head.rotation = Vector3.ZERO
	await _wait_for_physics(0.2)
	var camera := player.get_node("Head/Camera3D") as Camera3D
	_check(probe.call("_room_visible", room_m), "M is not visible from shared initial overlook")
	_check(probe.call("_room_visible", room_n), "N is not visible from shared initial overlook")
	_check(camera.is_position_in_frustum((room_m.get_node("FrontVerticalSplice") as Node3D).global_position), "M's long-distance identity feature is outside the actual spawn view")
	_check(camera.is_position_in_frustum((room_n.get_node("FrontHorizontalReinforcement") as Node3D).global_position), "N's long-distance identity feature is outside the actual spawn view")
	_check(manager.is_target_position_directly_visible_with_margin(
		room_m, (room_m.get_node("FrontVerticalSplice") as Node3D).global_position, 0.08
	), "M's long-distance identity feature is not visible from spawn")
	_check(manager.is_target_position_directly_visible_with_margin(
		room_n, (room_n.get_node("FrontHorizontalReinforcement") as Node3D).global_position, 0.08
	), "N's long-distance identity feature is not visible from spawn")
	player.global_position = Vector3(-5.5, 0.92, 4.4)
	camera.look_at((room_m.get_node("RearDoorLintel") as Node3D).global_position)
	await _wait_for_physics(0.1)
	_check(manager.is_target_position_directly_visible_with_margin(
		room_m, (room_m.get_node("RearDoorLintel") as Node3D).global_position, 0.08
	), "M's medium-distance doorway is not visible from its apron")
	camera.look_at((room_m.get_node("FrontSpliceFastenerLow") as Node3D).global_position)
	await _wait_for_physics(0.1)
	_check(manager.is_target_position_directly_visible_with_margin(
		room_m, (room_m.get_node("FrontSpliceFastenerLow") as Node3D).global_position, 0.08
	), "M's close splice detail is not visible from its apron")
	player.global_position = Vector3(5.5, 0.92, 4.4)
	camera.look_at((room_n.get_node("IntegratedWoundHigh") as Node3D).global_position)
	await _wait_for_physics(0.1)
	_check(manager.is_target_position_directly_visible_with_margin(
		room_n, (room_n.get_node("IntegratedWoundHigh") as Node3D).global_position, 0.08
	), "N's medium-distance wound is not visible from its apron")
	camera.look_at((room_n.get_node("FrontFloorJointClamp") as Node3D).global_position)
	await _wait_for_physics(0.1)
	_check(manager.is_target_position_directly_visible_with_margin(
		room_n, (room_n.get_node("FrontFloorJointClamp") as Node3D).global_position, 0.08
	), "N's close floor detail is not visible from its apron")
	player.global_position = Vector3(0, 0.92, 9.2)
	camera.look_at(room_m.global_position + Vector3(0, 1.5, 2.2))
	await _wait_for_physics(0.1)
	_check(probe.call("_room_visible", room_m), "M cannot be inspected from fixed atrium ground")
	camera.look_at(room_n.global_position + Vector3(0, 1.5, 2.2))
	await _wait_for_physics(0.1)
	_check(probe.call("_room_visible", room_n), "N cannot be inspected from fixed atrium ground")
	player.rotation = Vector3.ZERO
	player.head.rotation = Vector3.ZERO
	await _wait_for_physics(0.1)
	_check(probe.call("_room_visible", room_m) and probe.call("_room_visible", room_n), "Shared overlook does not hold both shells after comparison")
	await _wait_for_physics(0.85)
	_check(probe.get("successful_exchange_count") == 0, "Observed rooms exchanged")

	player.rotation.y = PI
	await _wait_for_physics(0.85)
	_check(probe.get("successful_exchange_count") == 1, "Both-hidden interval did not exchange rooms")
	_check(room_m.global_position.is_equal_approx(Vector3(5.5, 0, -1)), "M identity did not travel to B")
	_check(room_n.global_position.is_equal_approx(Vector3(-5.5, 0, -1)), "N identity did not travel to A")
	_check(fixed.get_node("CentralPlant").global_transform.is_equal_approx(plant_transform), "Atrium plant moved")
	_check(fixed.get_node("ReceiverA").global_transform.is_equal_approx(a_transform), "Receiver A moved")
	_check(fixed.get_node("ReceiverB").global_transform.is_equal_approx(b_transform), "Receiver B moved")
	_check(room_m.has_node("DoorLeafOpen") and room_m.has_node("IntegratedVerticalRepair"), "M lost its doorway or repair")
	_check(room_n.has_node("SolidRearFace") and room_n.has_node("IntegratedWoundHigh"), "N lost its solid face or wound")
	_check(room_m.has_node("FrontVerticalSplice") and room_m.has_node("FrontSpliceFoot"), "M lost its nested identity cues")
	_check(room_n.has_node("FrontHorizontalReinforcement") and room_n.has_node("FrontFloorJointPatch"), "N lost its nested identity cues")

	await _wait_for_physics(0.85)
	_check(probe.get("successful_exchange_count") == 1, "Rooms repeated exchange without reobservation")
	player.rotation.y = 0.0
	await _wait_for_physics(0.2)
	player.rotation.y = PI
	await _wait_for_physics(0.85)
	_check(probe.get("successful_exchange_count") == 2, "Pair could not rearm and recover to first occupation")
	_check(room_m.global_position.is_equal_approx(Vector3(-5.5, 0, -1)), "M did not return to A")

	player.global_position = Vector3(-5.5, 0.92, -1.0)
	player.rotation.y = 0.0
	await _wait_for_physics(0.2)
	player.rotation.y = PI
	await _wait_for_physics(0.85)
	_check(probe.get("successful_exchange_count") == 2, "Occupied shell exchanged around player")

	if failures.is_empty():
		print("MN spatial identity validation passed: paired first view, layered cue sightlines, observed hold, reciprocal exchange, fixed references, rearm, occupied-room safety")
	else:
		printerr("MN spatial identity validation failed: %d checks" % failures.size())
	quit(0 if failures.is_empty() else 1)
