class_name InteractionComponent
extends RayCast3D

@export var interaction_distance: float = 3.0


func _ready() -> void:
	target_position = Vector3(0.0, 0.0, -interaction_distance)
	enabled = true
	_exclude_collision_ancestor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		try_interact()


func try_interact() -> void:
	var target := get_focused_interactable()
	if target != null:
		target.interact()
		var telemetry := get_node_or_null("/root/PlaytestTelemetry")
		var scene_root := get_tree().current_scene
		if telemetry != null and scene_root != null:
			telemetry.call(
				"record_interaction",
				scene_root.scene_file_path,
				target
			)
		var audio_manager := get_node_or_null("/root/AudioManager")
		if audio_manager != null:
			audio_manager.call("notify_interaction")


func get_focused_interactable() -> Interactable:
	force_raycast_update()
	if not is_colliding():
		return null

	var target := _find_interactable(get_collider())
	return target


func _find_interactable(collider: Object) -> Interactable:
	var current_node := collider as Node
	while current_node != null:
		if current_node is Interactable:
			return current_node as Interactable
		current_node = current_node.get_parent()

	return null


func _exclude_collision_ancestor() -> void:
	var current_node := get_parent()
	while current_node != null:
		if current_node is CollisionObject3D:
			add_exception(current_node)
			return
		current_node = current_node.get_parent()
