extends SceneTree

const PROBE_SCENE := preload("res://scenes/tests/camera_observation_probe.tscn")

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
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var ray := camera.get_node("InteractionComponent") as InteractionComponent
	var module := probe.get("module") as Node3D
	var setting := probe.get("setting") as StatePersistenceSetting
	var shroud := probe.get("shroud") as Interactable
	var lens := probe.get("lens_camera") as Camera3D
	var fixed := probe.get_node("FixedWorld") as Node3D
	var receiver_a := fixed.get_node("ReceiverA") as Node3D
	var receiver_b := fixed.get_node("ReceiverB") as Node3D
	var a_transform := receiver_a.global_transform
	var b_transform := receiver_b.global_transform
	_check(module != null and shroud != null and lens != null, "Module, lens, and physical shroud must exist")
	_check(module.has_node("IntegratedRepair") and setting.get_parent() == module, "Persistent identity evidence must be attached")
	_check(probe.get("camera_powered") and not lens.current, "Surveillance lens must be powered without becoming the player view")
	_check(not shroud.get("is_blocked"), "Camera must begin with a clear service aperture")
	await _wait_for_physics(0.15)
	_check(probe.call("_camera_sees_current"), "Powered lens does not see the current A member")
	_check(not probe.call("_camera_sees_candidate", 1), "Camera incorrectly observes empty B candidate")

	# Player releases sight, but the same powered camera continues to hold A.
	player.rotation.y = PI
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 0, "Module moved despite live camera sight")
	_check(probe.call("_camera_sees_current"), "Camera lost A sight during baseline hold")

	# Move the physical cover using the existing E interaction ray; power stays on.
	player.global_position = Vector3(-7.0, 0.92, 2.5)
	player.rotation.y = 0.0
	camera.look_at(shroud.get_node("OpaquePanel").global_position)
	await _wait_for_physics(0.15)
	_check(ray.get_focused_interactable() == shroud, "Camera cover is not reachable by the normal interaction ray")
	ray.try_interact()
	_check(shroud.get("is_blocked"), "Cover did not move into the camera sightline")
	_check(probe.get("camera_powered"), "Cover interaction changed camera power")
	await _wait_for_physics(0.1)
	_check(not probe.call("_camera_sees_current"), "Opaque cover did not interrupt live camera sight")

	# The cover does not command relocation while the player still observes A.
	player.global_position = Vector3(-4.2, 0.92, 4.5)
	player.rotation.y = 0.0
	camera.look_at(module.global_position + Vector3(0, 1.0, 0.6))
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 0, "Cover acted like a relocation switch while player watched")
	_check(probe.call("_current_visible"), "Player view failed to hold after camera occlusion")

	player.rotation.y = PI
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 1, "Fully unobserved A module did not move to B")
	_check(probe.get("module") == module and module.has_node("IntegratedRepair"), "Module identity did not survive camera release")
	_check(setting.condition_on and not probe.get("fixed_lamp_on"), "Attached condition or fixed A output changed incorrectly")
	_check(module.global_position.is_equal_approx(Vector3(4.2, 0, -1.8)), "Module did not arrive at B")
	_check(receiver_a.global_transform.is_equal_approx(a_transform) and receiver_b.global_transform.is_equal_approx(b_transform), "Fixed receivers moved")
	await _wait_for_physics(0.8)
	_check(probe.get("successful_move_count") == 1, "Module repeated movement without reobservation")

	# The covered lens allows a lawful reverse move after B is reobserved.
	player.global_position = Vector3(4.2, 0.92, 3.5)
	player.rotation.y = 0.0
	camera.look_at(module.global_position + Vector3(0, 1.0, 0.6))
	await _wait_for_physics(0.15)
	_check(probe.call("_current_visible"), "B module cannot be reobserved for recovery")
	player.rotation.y = PI
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 2, "Covered-camera fixture cannot recover B to A")
	_check(module.global_position.is_equal_approx(Vector3(-4.2, 0, -1.8)), "Module did not return to A")
	_check(probe.get("fixed_lamp_on"), "A's fixed output did not reconnect to current ON condition")

	if failures.is_empty():
		print("Camera observation validation passed: live powered hold, candidate isolation, ray-operated optical occlusion, player hold, identity persistence, rearm, recovery")
	else:
		printerr("Camera observation validation failed: %d checks" % failures.size())
	quit(0 if failures.is_empty() else 1)
