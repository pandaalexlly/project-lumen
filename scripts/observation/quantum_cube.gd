class_name QuantumCube
extends ObservableObject

const DESTINATION_RECHECK_INTERVAL: float = 0.1

enum CubePoint {
	A,
	B,
}

@export_node_path("Node3D") var point_a_path: NodePath
@export_node_path("Node3D") var point_b_path: NodePath
@export_enum("A", "B") var starting_point: int = CubePoint.A
@export var unobserved_delay: float = 0.8
@export var destination_hidden_grace: float = 0.2
@export_range(0.0, 0.25, 0.01) var destination_viewport_margin: float = 0.1
@export var debug_output: bool = true

@onready var _point_a: Node3D = get_node_or_null(point_a_path) as Node3D
@onready var _point_b: Node3D = get_node_or_null(point_b_path) as Node3D
@onready var _body_visibility_probes: Node3D = $BodyVisibilityProbes
@onready var _shadow_visibility_probes: Node3D = $ShadowVisibilityProbes
@onready var _move_timer: Timer = $MoveTimer

var _current_point: int = CubePoint.A
var _moved_this_unobserved_period: bool = false
var _destination_hidden_time: float = 0.0
var _destination_grace_active: bool = false


func _ready() -> void:
	_move_timer.one_shot = true
	_move_timer.timeout.connect(_on_move_timer_timeout)
	_current_point = starting_point
	_place_at_current_point()


func _evaluate_current_observation() -> bool:
	return (
		_is_current_probe_group_visible(_body_visibility_probes)
		or _is_current_probe_group_visible(_shadow_visibility_probes)
	)


func _on_observation_started() -> void:
	if not _move_timer.is_stopped():
		_move_timer.stop()
		if debug_output:
			print("QuantumCube: move cancelled")
	_reset_destination_hidden_grace()
	_moved_this_unobserved_period = false


func _on_observation_ended() -> void:
	if _moved_this_unobserved_period or not _has_valid_points():
		return
	_reset_destination_hidden_grace()
	_move_timer.start(unobserved_delay)


func _on_move_timer_timeout() -> void:
	if currently_observed or _moved_this_unobserved_period:
		return

	var destination_point := _point_b if _current_point == CubePoint.A else _point_a
	if not is_instance_valid(destination_point):
		return
	if not is_instance_valid(_observation_manager):
		_reset_destination_hidden_grace()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return
	if _is_destination_envelope_unsafe(destination_point):
		_reset_destination_hidden_grace()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return

	if destination_hidden_grace > 0.0:
		if not _destination_grace_active:
			_destination_grace_active = true
			_destination_hidden_time = 0.0
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return
		_destination_hidden_time += DESTINATION_RECHECK_INTERVAL
		if _destination_hidden_time < destination_hidden_grace:
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return

	var previous_point := _current_point
	_current_point = CubePoint.B if _current_point == CubePoint.A else CubePoint.A
	if not _place_at_current_point():
		_current_point = previous_point
		return

	_moved_this_unobserved_period = true
	if debug_output:
		print(
			"QuantumCube: %s -> %s"
			% [_point_name(previous_point), _point_name(_current_point)]
		)


func _place_at_current_point() -> bool:
	var target_point := _point_a if _current_point == CubePoint.A else _point_b
	if not is_instance_valid(target_point):
		return false
	global_transform = target_point.global_transform
	return true


func _is_destination_envelope_unsafe(destination_point: Node3D) -> bool:
	return (
		_is_destination_probe_group_visible(_body_visibility_probes, destination_point)
		or _is_destination_probe_group_visible(_shadow_visibility_probes, destination_point)
	)


func _is_current_probe_group_visible(probe_group: Node3D) -> bool:
	for child in probe_group.get_children():
		var probe := child as Node3D
		if probe == null:
			continue
		if _observation_manager.is_target_position_directly_visible_with_margin(
			self,
			probe.global_position,
			destination_viewport_margin
		):
			return true
	return false


func _is_destination_probe_group_visible(
	probe_group: Node3D,
	destination_point: Node3D
) -> bool:
	for child in probe_group.get_children():
		var probe := child as Node3D
		if probe == null:
			continue
		var local_probe_position := to_local(probe.global_position)
		var candidate_world_position := destination_point.global_transform * local_probe_position
		if _observation_manager.is_position_directly_visible_with_margin(
			candidate_world_position,
			destination_viewport_margin
		):
			return true
	return false


func _reset_destination_hidden_grace() -> void:
	_destination_hidden_time = 0.0
	_destination_grace_active = false


func _has_valid_points() -> bool:
	return is_instance_valid(_point_a) and is_instance_valid(_point_b)


func _point_name(point: int) -> String:
	return "A" if point == CubePoint.A else "B"
