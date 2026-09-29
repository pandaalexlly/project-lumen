extends SceneTree

const PROBE_SCENE := preload("res://scenes/tests/state_persistence_probe.tscn")

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


func _aim_at_setting(player: PlayerController, setting: StatePersistenceSetting) -> InteractionComponent:
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var ray := camera.get_node("InteractionComponent") as InteractionComponent
	camera.look_at(setting.get_node("ControlHousing").global_position)
	return ray


func _run() -> void:
	var probe := PROBE_SCENE.instantiate() as Node3D
	root.add_child(probe)
	current_scene = probe
	var player := probe.get_node("Player") as PlayerController
	var module := probe.get("module") as Node3D
	var setting := probe.get("setting") as StatePersistenceSetting
	var fixed := probe.get_node("FixedWorld") as Node3D
	var receiver_a := fixed.get_node("ReceiverA") as Node3D
	var receiver_b := fixed.get_node("ReceiverB") as Node3D
	var a_transform := receiver_a.global_transform
	var b_transform := receiver_b.global_transform
	var contact_transform: Transform3D = (receiver_a.get_node("ContactLeft") as Node3D).global_transform
	_check(module != null and setting != null, "One persistent module and attached setting must exist")
	_check(setting.get_parent() == module, "Physical setting must travel as part of the module")
	_check(module.has_node("IntegratedRepair"), "Module identity repair is missing")
	_check(module.global_position.is_equal_approx(Vector3(-4.2, 0, -1.8)), "Module must begin at A")
	_check(setting.condition_on and probe.get("fixed_lamp_on"), "A contact must initially show ON")
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 0, "Observed module moved")

	# An unobserved departure moves the current object, not an earlier snapshot.
	player.rotation.y = PI
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 1, "Module did not move from A to B")
	_check(probe.get("module") == module, "Relocation replaced the module instance")
	_check(module.global_position.is_equal_approx(Vector3(4.2, 0, -1.8)), "Module did not arrive at B")
	_check(setting.condition_on, "Module lost its current ON condition at B")
	_check(not probe.get("fixed_lamp_on"), "Fixed A lamp remained on without the module")
	_check(module.has_node("IntegratedRepair"), "Identity repair did not travel")
	await _wait_for_physics(0.8)
	_check(probe.get("successful_move_count") == 1, "Module moved repeatedly without reobservation")

	player.global_position = Vector3(4.63, 0.92, 1.0)
	player.rotation.y = 0.0
	var ray := _aim_at_setting(player, setting)
	await _wait_for_physics(0.15)
	_check(ray.get_focused_interactable() == setting, "Attached setting is not reachable by the normal interaction ray at B")
	ray.try_interact()
	_check(not setting.condition_on, "Interaction did not set the attached condition OFF at B")
	_check(setting.get_node("LeverPivot").rotation.z > 0.0, "Physical lever does not show the changed condition")
	_check(not probe.get("fixed_lamp_on"), "Fixed A lamp must remain dark at B")
	_check(probe.get("successful_move_count") == 1, "Module moved while directly observed at B")

	player.rotation.y = PI
	await _wait_for_physics(0.9)
	_check(probe.get("successful_move_count") == 2, "Module did not return from B to A")
	_check(probe.get("module") == module, "Return to A restored a different module instance")
	_check(module.global_position.is_equal_approx(Vector3(-4.2, 0, -1.8)), "Module did not return to A")
	_check(not setting.condition_on, "Return to A incorrectly restored old ON condition")
	_check(not probe.get("fixed_lamp_on"), "Old A lamp state was incorrectly recalled")
	_check(receiver_a.global_transform.is_equal_approx(a_transform), "Fixed receiver A moved")
	_check(receiver_b.global_transform.is_equal_approx(b_transform), "Fixed receiver B moved")
	_check(receiver_a.get_node("ContactLeft").global_transform.is_equal_approx(contact_transform), "Fixed A contact moved")

	player.global_position = Vector3(-3.77, 0.92, 1.0)
	player.rotation.y = 0.0
	ray = _aim_at_setting(player, setting)
	await _wait_for_physics(0.15)
	_check(ray.get_focused_interactable() == setting, "Attached setting is not reachable at A")
	ray.try_interact()
	_check(setting.condition_on and probe.get("fixed_lamp_on"), "Current ON condition did not reconnect fixed A lamp")
	_check(probe.get("successful_move_count") == 2, "Module moved while player adjusted setting at A")

	if failures.is_empty():
		print("State persistence validation passed: observed hold, A/B relocation, same identity, ray interaction, attached condition, false snapshot counterexample, fixed A output")
	else:
		printerr("State persistence validation failed: %d checks" % failures.size())
	quit(0 if failures.is_empty() else 1)
