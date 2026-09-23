class_name QuantumRelocator
extends ObservableObject

const DESTINATION_RECHECK_INTERVAL: float = 0.1

@export var destination_paths: Array[NodePath] = []
@export var starting_destination_index: int = 0
@export var first_move_excluded_paths: Array[NodePath] = []
@export var minimum_move_distance: float = 0.0
@export var avoid_immediate_return: bool = true
# Provisional gameplay-testing value, not a finalized world-rule constant.
@export var unobserved_delay: float = 2.5
@export var destination_hidden_grace: float = 0.2
@export_range(0.0, 0.25, 0.01) var destination_viewport_margin: float = 0.1
@export var debug_output: bool = true

@onready var _body_visibility_probes: Node3D = $BodyVisibilityProbes
@onready var _shadow_visibility_probes: Node3D = $ShadowVisibilityProbes
@onready var _move_timer: Timer = $MoveTimer

var current_destination_index: int:
	get:
		return _current_destination_index

var previous_destination_index: int:
	get:
		return _previous_destination_index

var successful_move_count: int:
	get:
		return _successful_move_count

var _destinations: Array[Node3D] = []
var _first_move_excluded_destinations: Array[Node3D] = []
var _current_destination_index: int = -1
var _previous_destination_index: int = -1
var _pending_destination_index: int = -1
var _successful_move_count: int = 0
var _moved_this_unobserved_period: bool = false
var _destination_hidden_time: float = 0.0
var _destination_grace_active: bool = false


func _ready() -> void:
	_move_timer.one_shot = true
	_move_timer.timeout.connect(_on_move_timer_timeout)
	_cache_destinations()
	_current_destination_index = starting_destination_index
	if _get_destination(_current_destination_index) == null:
		_current_destination_index = -1
		for index in range(_destinations.size()):
			if _get_destination(index) != null:
				_current_destination_index = index
				break
	_place_at_destination(_current_destination_index)


func _evaluate_current_observation() -> bool:
	return (
		_is_current_probe_group_visible(_body_visibility_probes)
		or _is_current_probe_group_visible(_shadow_visibility_probes)
	)


func _on_observation_started() -> void:
	if not _move_timer.is_stopped():
		_move_timer.stop()
		if debug_output:
			print("%s: move cancelled" % name)
	_clear_pending_destination()
	_moved_this_unobserved_period = false


func _on_observation_ended() -> void:
	if _moved_this_unobserved_period or _get_destination(_current_destination_index) == null:
		return
	_clear_pending_destination()
	_move_timer.start(unobserved_delay)


func _on_move_timer_timeout() -> void:
	if currently_observed or _moved_this_unobserved_period:
		return

	if not is_instance_valid(_observation_manager):
		_clear_pending_destination()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return

	if _pending_destination_index == -1:
		_pending_destination_index = _choose_safe_destination()
		if _pending_destination_index == -1:
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return

	var destination_point := _get_destination(_pending_destination_index)
	if (
		not _is_destination_eligible(_pending_destination_index)
		or _is_destination_envelope_unsafe(destination_point)
	):
		_clear_pending_destination()
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

	if not _place_at_destination(_pending_destination_index):
		_clear_pending_destination()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return

	var previous_index := _current_destination_index
	_previous_destination_index = previous_index
	_current_destination_index = _pending_destination_index
	_successful_move_count += 1
	_clear_pending_destination()
	_moved_this_unobserved_period = true
	if debug_output:
		print(
			"%s: destination %d -> %d"
			% [name, previous_index, _current_destination_index]
		)


func _place_at_destination(index: int) -> bool:
	var target_point := _get_destination(index)
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


func _clear_pending_destination() -> void:
	_pending_destination_index = -1
	_reset_destination_hidden_grace()


func _cache_destinations() -> void:
	# Null slots preserve Inspector indices when paths are invalid or duplicated.
	for path in destination_paths:
		var destination := _resolve_external_destination(path)
		_destinations.append(destination if not _destinations.has(destination) else null)
	for path in first_move_excluded_paths:
		var destination := _resolve_external_destination(path)
		if destination != null and not _first_move_excluded_destinations.has(destination):
			_first_move_excluded_destinations.append(destination)


func _resolve_external_destination(path: NodePath) -> Node3D:
	if path.is_empty():
		return null
	var destination := get_node_or_null(path) as Node3D
	if destination == null or destination == self or is_ancestor_of(destination):
		return null
	return destination


func _get_destination(index: int) -> Node3D:
	if index < 0 or index >= _destinations.size():
		return null
	var destination := _destinations[index]
	return destination if is_instance_valid(destination) else null


func _is_destination_eligible(index: int) -> bool:
	var current := _get_destination(_current_destination_index)
	var candidate := _get_destination(index)
	if current == null or candidate == null or candidate == current:
		return false
	if avoid_immediate_return and index == _previous_destination_index:
		return false
	if _successful_move_count == 0 and _first_move_excluded_destinations.has(candidate):
		return false
	if current.global_position.distance_to(candidate.global_position) < maxf(minimum_move_distance, 0.0):
		return false
	return _is_destination_additionally_available(index, candidate)


func _is_destination_additionally_available(
	_destination_index: int,
	_destination: Node3D
) -> bool:
	return true


func _choose_safe_destination() -> int:
	var safe_indices: Array[int] = []
	for index in range(_destinations.size()):
		if _is_destination_eligible(index) and not _is_destination_envelope_unsafe(_get_destination(index)):
			safe_indices.append(index)
	return _select_safe_destination(safe_indices)


func _select_safe_destination(safe_indices: Array[int]) -> int:
	if safe_indices.is_empty():
		return -1
	return safe_indices[randi_range(0, safe_indices.size() - 1)]
