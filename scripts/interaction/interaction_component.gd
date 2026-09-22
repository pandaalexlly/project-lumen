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
	force_raycast_update()
	if not is_colliding():
		return

	var target := _find_interactable(get_collider())
	if target != null:
		target.interact()


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
