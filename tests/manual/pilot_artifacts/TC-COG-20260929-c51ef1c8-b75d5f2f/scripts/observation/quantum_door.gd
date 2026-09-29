class_name QuantumDoor
extends QuantumRelocator

@export_node_path("CharacterBody3D") var player_path: NodePath

@onready var _player: CharacterBody3D = get_node_or_null(player_path) as CharacterBody3D
@onready var _door_body: StaticBody3D = $StaticBody3D
@onready var _door_collision: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _is_destination_additionally_available(
	_destination_index: int,
	destination: Node3D
) -> bool:
	if (
		not is_instance_valid(_player)
		or not is_instance_valid(_door_body)
		or not is_instance_valid(_door_collision)
		or _door_collision.shape == null
	):
		return false

	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = _door_collision.shape
	var collision_local_transform := global_transform.affine_inverse() * _door_collision.global_transform
	query.transform = destination.global_transform * collision_local_transform
	query.collision_mask = _player.collision_layer
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [_door_body.get_rid()]

	var overlaps := get_world_3d().direct_space_state.intersect_shape(query)
	for overlap in overlaps:
		var collider := overlap.get("collider") as Node
		if collider == _player or (collider != null and _player.is_ancestor_of(collider)):
			return false
	return true
