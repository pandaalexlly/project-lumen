class_name ObservationManager
extends Node

@export_node_path("Camera3D") var primary_camera_path: NodePath

@onready var primary_camera: Camera3D = get_node_or_null(primary_camera_path) as Camera3D

var _camera_collision_ancestor: CollisionObject3D


func _ready() -> void:
	_camera_collision_ancestor = _find_camera_collision_ancestor()


func is_directly_observed(target_root: Node, observation_anchor: Node3D) -> bool:
	if not is_instance_valid(primary_camera):
		return false
	if not is_instance_valid(target_root) or not is_instance_valid(observation_anchor):
		return false

	var anchor_position := observation_anchor.global_position
	if not primary_camera.is_position_in_frustum(anchor_position):
		return false

	return _has_line_of_sight(target_root, anchor_position)


func is_position_directly_visible(world_position: Vector3) -> bool:
	if not is_instance_valid(primary_camera):
		return false
	if not primary_camera.is_position_in_frustum(world_position):
		return false

	return _raycast_to_position(world_position).is_empty()


func is_position_directly_visible_with_margin(
	world_position: Vector3,
	viewport_margin: float = 0.1
) -> bool:
	if not is_instance_valid(primary_camera):
		return false
	if not _is_position_in_guarded_view(world_position, viewport_margin):
		return false

	return _raycast_to_position(world_position).is_empty()


func is_target_position_directly_visible_with_margin(
	target_root: Node,
	world_position: Vector3,
	viewport_margin: float = 0.1
) -> bool:
	if not is_instance_valid(primary_camera) or not is_instance_valid(target_root):
		return false
	if not _is_position_in_guarded_view(world_position, viewport_margin):
		return false

	return _has_line_of_sight(target_root, world_position)


func _has_line_of_sight(target_root: Node, anchor_position: Vector3) -> bool:
	var result := _raycast_to_position(anchor_position)
	if result.is_empty():
		return true

	var collider := result.get("collider") as Node
	if collider == null:
		return false
	return collider == target_root or target_root.is_ancestor_of(collider)


func _raycast_to_position(world_position: Vector3) -> Dictionary:
	var query := PhysicsRayQueryParameters3D.create(
		primary_camera.global_position,
		world_position
	)
	if is_instance_valid(_camera_collision_ancestor):
		query.exclude = [_camera_collision_ancestor.get_rid()]

	return primary_camera.get_world_3d().direct_space_state.intersect_ray(query)


func _is_position_in_guarded_view(world_position: Vector3, viewport_margin: float) -> bool:
	if primary_camera.is_position_in_frustum(world_position):
		return true
	if primary_camera.is_position_behind(world_position):
		return false

	var viewport_rect := primary_camera.get_viewport().get_visible_rect()
	var margin_size := viewport_rect.size * maxf(viewport_margin, 0.0)
	var guarded_rect := Rect2(
		viewport_rect.position - margin_size,
		viewport_rect.size + margin_size * 2.0
	)
	return guarded_rect.has_point(primary_camera.unproject_position(world_position))


func _find_camera_collision_ancestor() -> CollisionObject3D:
	if not is_instance_valid(primary_camera):
		return null

	var current_node := primary_camera.get_parent()
	while current_node != null:
		if current_node is CollisionObject3D:
			return current_node as CollisionObject3D
		current_node = current_node.get_parent()

	return null
