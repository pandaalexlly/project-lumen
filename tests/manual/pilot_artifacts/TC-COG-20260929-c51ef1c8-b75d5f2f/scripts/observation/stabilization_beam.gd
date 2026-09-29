class_name StabilizationBeam
extends ArtificialObservationSource

signal enabled_changed(is_enabled: bool)

@export var initially_enabled: bool = false
@export_range(0.1, 50.0, 0.1) var beam_length: float = 20.0
@export_range(0.1, 10.0, 0.01) var beam_width: float = 0.62
@export_range(0.1, 10.0, 0.01) var beam_height: float = 0.62
@export_flags_3d_physics var occlusion_collision_mask: int = 1
@export_node_path("CollisionObject3D") var player_path: NodePath
@export var debug_output: bool = true

@onready var _emitter_origin: Marker3D = $EmitterOrigin
@onready var _beam_volume: MeshInstance3D = $EmitterOrigin/BeamVolume
@onready var _player_collision_root: CollisionObject3D = (
	get_node_or_null(player_path) as CollisionObject3D
)

var enabled: bool:
	get:
		return _enabled

var visual_length: float:
	get:
		return _visual_length

var _enabled: bool = false
var _visual_length: float = 0.0


func _ready() -> void:
	_enabled = initially_enabled
	_update_visual_state()


func _physics_process(_delta: float) -> void:
	if _enabled:
		_update_visual_length()


func is_observation_source_enabled() -> bool:
	return _enabled


func set_enabled(value: bool) -> void:
	if value == _enabled:
		return
	_enabled = value
	_update_visual_state()
	enabled_changed.emit(_enabled)
	var audio_manager := get_node_or_null("/root/AudioManager")
	if audio_manager != null:
		audio_manager.call("notify_beam_state", _enabled)
	var presentation_ui := get_node_or_null("/root/PresentationUI")
	if presentation_ui != null:
		presentation_ui.call(
			"show_notification",
			"BEAM ACTIVATED" if _enabled else "BEAM DISABLED"
		)
	if debug_output:
		print("%s: %s" % [name, "enabled" if _enabled else "disabled"])


func toggle_enabled() -> void:
	set_enabled(not _enabled)


func aim_at(world_position: Vector3) -> void:
	if global_position.is_equal_approx(world_position):
		return
	look_at(world_position, Vector3.UP)
	if _enabled:
		_update_visual_length()


func observes_position(
	world_position: Vector3,
	target_root: Node,
	ignored_root: Node = null
) -> bool:
	if not _enabled or not is_instance_valid(_emitter_origin):
		return false

	var beam_local_position := _emitter_origin.to_local(world_position)
	if beam_local_position.z > 0.0 or beam_local_position.z < -beam_length:
		return false
	if absf(beam_local_position.x) > beam_width * 0.5:
		return false
	if absf(beam_local_position.y) > beam_height * 0.5:
		return false

	var query := PhysicsRayQueryParameters3D.create(
		_emitter_origin.global_position,
		world_position,
		occlusion_collision_mask
	)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = _collect_query_exclusion_rids(ignored_root)
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return true

	var collider := result.get("collider") as Node
	return (
		is_instance_valid(target_root)
		and collider != null
		and (collider == target_root or target_root.is_ancestor_of(collider))
	)


func _update_visual_state() -> void:
	if not is_instance_valid(_beam_volume):
		return
	_beam_volume.visible = _enabled
	_update_visual_length()


func _update_visual_length() -> void:
	if not is_instance_valid(_emitter_origin) or not is_instance_valid(_beam_volume):
		return

	var ray_start := _emitter_origin.global_position
	var ray_end := ray_start - _emitter_origin.global_basis.z.normalized() * beam_length
	var exclusions := _collect_query_exclusion_rids()
	var visible_length := beam_length

	while true:
		var query := PhysicsRayQueryParameters3D.create(
			ray_start,
			ray_end,
			occlusion_collision_mask
		)
		query.collide_with_areas = false
		query.collide_with_bodies = true
		query.exclude = exclusions
		var result := get_world_3d().direct_space_state.intersect_ray(query)
		if result.is_empty():
			break

		var collider := result.get("collider") as CollisionObject3D
		if collider != null and _belongs_to_quantum_object(collider):
			exclusions.append(collider.get_rid())
			continue

		visible_length = minf(
			beam_length,
			ray_start.distance_to(result.get("position", ray_end))
		)
		break

	_set_visual_length(visible_length)


func _set_visual_length(length: float) -> void:
	_visual_length = clampf(length, 0.0, beam_length)
	_beam_volume.position = Vector3(0.0, 0.0, -_visual_length * 0.5)
	_beam_volume.scale = Vector3(beam_width, beam_height, _visual_length)


func _collect_collision_rids(root_node: Node) -> Array[RID]:
	var collision_rids: Array[RID] = []
	if is_instance_valid(root_node):
		_append_collision_rids(root_node, collision_rids)
	return collision_rids


func _collect_query_exclusion_rids(ignored_root: Node = null) -> Array[RID]:
	var collision_rids := _collect_collision_rids(ignored_root)
	if is_instance_valid(_player_collision_root):
		_append_collision_rids(_player_collision_root, collision_rids)
	return collision_rids


func _append_collision_rids(node: Node, collision_rids: Array[RID]) -> void:
	var collision_object := node as CollisionObject3D
	if collision_object != null and not collision_rids.has(collision_object.get_rid()):
		collision_rids.append(collision_object.get_rid())
	for child in node.get_children():
		_append_collision_rids(child, collision_rids)


func _belongs_to_quantum_object(node: Node) -> bool:
	var current := node
	while current != null:
		if current is QuantumRelocator or current is CoherentAssembly:
			return true
		current = current.get_parent()
	return false
