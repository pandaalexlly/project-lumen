class_name ArtificialObservationSource
extends Node3D

const SOURCE_GROUP: StringName = &"artificial_observation_sources"


func _enter_tree() -> void:
	add_to_group(SOURCE_GROUP)


func is_observation_source_enabled() -> bool:
	return true


func observes_any_position(
	world_positions: PackedVector3Array,
	target_root: Node,
	ignored_root: Node = null
) -> bool:
	if not is_observation_source_enabled():
		return false
	for world_position in world_positions:
		if observes_position(world_position, target_root, ignored_root):
			return true
	return false


func observes_position(
	_world_position: Vector3,
	_target_root: Node,
	_ignored_root: Node = null
) -> bool:
	return false
