class_name CoherentAssembly
extends ObservableObject

signal configuration_changed(previous_index: int, current_index: int, passenger_carried: bool)

const DESTINATION_RECHECK_INTERVAL := 0.1
const SUPPORT_OFF := 0
const SUPPORT_FULL := 1
const SUPPORT_UNSAFE := 2
const FOOTPRINT_SAMPLES := 8
const SUPPORT_RAY_HEIGHT := 0.12
const SUPPORT_RAY_DEPTH := 0.3
const SUPPORT_EDGE_TOLERANCE := 0.02

@export var configuration_paths: Array[NodePath] = []
@export var starting_configuration_index := 0
@export_node_path("CharacterBody3D") var player_path: NodePath
@export var fixed_support_paths: Array[NodePath] = []
@export var unobserved_delay := 0.05
@export var destination_hidden_grace := 0.2
@export_range(0.0, 0.25, 0.01) var destination_viewport_margin := 0.1

@onready var _members: Node3D = $Members
@onready var _bearing_body: StaticBody3D = $Members/Cradle/BearingBody
@onready var _bearing_shape: CollisionShape3D = $Members/Cradle/BearingBody/CollisionShape3D
@onready var _player: CharacterBody3D = get_node_or_null(player_path) as CharacterBody3D
@onready var _move_timer: Timer = $MoveTimer

var current_configuration_index: int = -1
var previous_configuration_index: int = -1
var successful_move_count: int = 0

var _configurations: Array[Node3D] = []
var _fixed_supports: Array[Node] = []
var _pending_index := -1
var _pending_support_state := -1
var _hidden_time := 0.0
var _grace_active := false
var _moved_this_unobserved_period := false
var _arrival_camera: Camera3D


func _ready() -> void:
	for path in configuration_paths:
		var configuration := get_node_or_null(path) as Node3D
		if configuration != null and not _is_yaw_only_placement(configuration.global_transform):
			push_error("CoherentAssembly configuration must use translation and yaw only: %s" % path)
			configuration = null
		_configurations.append(configuration)
	for path in fixed_support_paths:
		var fixed_support := get_node_or_null(path)
		if fixed_support != null:
			_fixed_supports.append(fixed_support)
	_move_timer.one_shot = true
	_move_timer.timeout.connect(_on_move_timer_timeout)
	_arrival_camera = Camera3D.new()
	_arrival_camera.current = false
	add_child(_arrival_camera)
	current_configuration_index = starting_configuration_index
	if _configuration(current_configuration_index) == null:
		current_configuration_index = -1
		for index in range(_configurations.size()):
			if _configuration(index) != null:
				current_configuration_index = index
				break
	if current_configuration_index != -1:
		global_transform = _configuration(current_configuration_index).global_transform


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if _pending_index != -1 and _support_state() != _pending_support_state:
		_clear_pending()
		if not currently_observed and not _moved_this_unobserved_period:
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)


func _evaluate_current_observation() -> bool:
	for position in _member_probe_positions(global_transform):
		if _observation_manager.is_target_position_directly_visible_with_margin(
			self, position, destination_viewport_margin
		):
			return true
	return false


func _get_current_observation_probe_positions() -> PackedVector3Array:
	return _member_probe_positions(global_transform)


func _on_observation_started() -> void:
	_move_timer.stop()
	_clear_pending()
	_moved_this_unobserved_period = false


func _on_observation_ended() -> void:
	if not _moved_this_unobserved_period and _configuration(current_configuration_index) != null:
		_clear_pending()
		_move_timer.start(unobserved_delay)


func _on_move_timer_timeout() -> void:
	if currently_observed or _moved_this_unobserved_period:
		return
	if not is_instance_valid(_observation_manager):
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return

	var support_state := _support_state()
	if support_state == SUPPORT_UNSAFE:
		_clear_pending()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return
	if _pending_index == -1:
		var legal_indices: Array[int] = []
		for index in range(_configurations.size()):
			if _is_candidate_legal(index, support_state):
				legal_indices.append(index)
		if legal_indices.is_empty():
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return
		_pending_index = legal_indices.pick_random()
		_pending_support_state = support_state
	if support_state != _pending_support_state or not _is_candidate_legal(_pending_index, support_state):
		_clear_pending()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return

	if destination_hidden_grace > 0.0:
		if not _grace_active:
			_grace_active = true
			_hidden_time = 0.0
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return
		_hidden_time += DESTINATION_RECHECK_INTERVAL
		if _hidden_time < destination_hidden_grace:
			_move_timer.start(DESTINATION_RECHECK_INTERVAL)
			return

	# All validation is repeated immediately before changing either transform.
	if _evaluate_current_observation() or _is_any_artificial_source_observing(
		_get_current_observation_probe_positions(), self
	) or not _is_candidate_legal(_pending_index, support_state):
		_clear_pending()
		_move_timer.start(DESTINATION_RECHECK_INTERVAL)
		return
	_commit(_pending_index, support_state == SUPPORT_FULL)


func _configuration(index: int) -> Node3D:
	if index < 0 or index >= _configurations.size():
		return null
	var configuration := _configurations[index]
	return configuration if is_instance_valid(configuration) else null


func _is_yaw_only_placement(placement: Transform3D) -> bool:
	var basis := placement.basis
	return (
		basis.y.is_equal_approx(Vector3.UP)
		and is_equal_approx(basis.x.length(), 1.0)
		and is_equal_approx(basis.z.length(), 1.0)
		and absf(basis.x.dot(basis.z)) < 0.001
		and basis.determinant() > 0.0
	)


func _is_candidate_legal(index: int, support_state: int = -1) -> bool:
	var destination := _configuration(index)
	if destination == null or index == current_configuration_index:
		return false
	if support_state == -1:
		support_state = _support_state()
	if support_state == SUPPORT_UNSAFE:
		return false
	var placement := destination.global_transform
	var positions := _member_probe_positions(placement)
	for position in positions:
		if _observation_manager.is_position_directly_visible_ignoring_root(
			position, destination_viewport_margin, self
		):
			return false
	if _is_any_artificial_source_observing(positions, null, self):
		return false
	if not _candidate_members_clear(placement, support_state == SUPPORT_FULL):
		return false
	if support_state == SUPPORT_FULL:
		if not _mapped_passenger_clear(placement):
			return false
		if not _arrival_view_concealed(placement):
			return false
	return true


func _member_probe_positions(placement: Transform3D) -> PackedVector3Array:
	var positions := PackedVector3Array()
	for member in _members.get_children():
		var probes := member.get_node_or_null("VisibilityProbes") as Node3D
		if probes == null:
			continue
		for probe_node in probes.get_children():
			var probe := probe_node as Node3D
			if probe != null:
				positions.append(placement * to_local(probe.global_position))
	return positions


func _support_state() -> int:
	if not is_instance_valid(_player) or not _player.is_on_floor():
		return SUPPORT_UNSAFE
	var shape := _player.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var capsule := shape.shape as CapsuleShape3D if shape != null else null
	if capsule == null:
		return SUPPORT_UNSAFE
	var foot := shape.global_position - Vector3.UP * capsule.height * 0.5
	var bearing_hits := 0
	var fixed_hits := 0
	for index in range(FOOTPRINT_SAMPLES + 1):
		var offset := Vector3.ZERO
		if index > 0:
			var angle := TAU * float(index - 1) / float(FOOTPRINT_SAMPLES)
			offset = Vector3(cos(angle), 0.0, sin(angle)) * capsule.radius * 0.98
		var query := PhysicsRayQueryParameters3D.create(
			foot + offset + Vector3.UP * SUPPORT_RAY_HEIGHT,
			foot + offset - Vector3.UP * SUPPORT_RAY_DEPTH
		)
		query.exclude = [_player.get_rid()]
		var collider := _player.get_world_3d().direct_space_state.intersect_ray(query).get("collider") as Node
		if collider == _bearing_body:
			bearing_hits += 1
		elif _is_fixed_support(collider):
			fixed_hits += 1
		else:
			return SUPPORT_UNSAFE
	if bearing_hits == FOOTPRINT_SAMPLES + 1 and _footprint_on_bearing(foot, capsule.radius):
		return SUPPORT_FULL
	if fixed_hits == FOOTPRINT_SAMPLES + 1:
		return SUPPORT_OFF
	return SUPPORT_UNSAFE


func _is_fixed_support(collider: Node) -> bool:
	for support in _fixed_supports:
		if collider == support or (collider != null and support.is_ancestor_of(collider)):
			return true
	return false


func _footprint_on_bearing(foot: Vector3, radius: float) -> bool:
	var box := _bearing_shape.shape as BoxShape3D
	if box == null:
		return false
	var local_foot := _bearing_shape.global_transform.affine_inverse() * foot
	return (
		absf(local_foot.x) + radius <= box.size.x * 0.5 - SUPPORT_EDGE_TOLERANCE
		and absf(local_foot.z) + radius <= box.size.z * 0.5 - SUPPORT_EDGE_TOLERANCE
		and absf(local_foot.y - box.size.y * 0.5) <= 0.15
	)


func _candidate_members_clear(placement: Transform3D, carrying: bool) -> bool:
	var exclusions := _assembly_collision_rids()
	if carrying:
		exclusions.append(_player.get_rid())
	for member in _members.get_children():
		for body_node in member.find_children("*", "CollisionObject3D", true, false):
			var body := body_node as CollisionObject3D
			if body == null:
				continue
			for shape_node in body.find_children("*", "CollisionShape3D", true, false):
				var collision_shape := shape_node as CollisionShape3D
				if collision_shape == null or collision_shape.shape == null or collision_shape.disabled:
					continue
				var query := PhysicsShapeQueryParameters3D.new()
				query.shape = collision_shape.shape
				query.transform = placement * (global_transform.affine_inverse() * collision_shape.global_transform)
				query.collision_mask = body.collision_mask if body is PhysicsBody3D else 1
				query.exclude = exclusions
				if not get_world_3d().direct_space_state.intersect_shape(query).is_empty():
					return false
	return true


func _mapped_passenger_clear(placement: Transform3D) -> bool:
	var collision_shape := _player.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if collision_shape == null or collision_shape.shape == null:
		return false
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = collision_shape.shape
	query.transform = placement * (global_transform.affine_inverse() * collision_shape.global_transform)
	query.collision_mask = _player.collision_mask
	var exclusions := _assembly_collision_rids()
	exclusions.append(_player.get_rid())
	query.exclude = exclusions
	return get_world_3d().direct_space_state.intersect_shape(query).is_empty()


func _arrival_view_concealed(placement: Transform3D) -> bool:
	var camera := _observation_manager.primary_camera
	if not is_instance_valid(camera):
		return false
	_arrival_camera.fov = camera.fov
	_arrival_camera.near = camera.near
	_arrival_camera.far = camera.far
	_arrival_camera.keep_aspect = camera.keep_aspect
	_arrival_camera.global_transform = placement * (global_transform.affine_inverse() * camera.global_transform)
	var exclusions := _assembly_collision_rids()
	exclusions.append(_player.get_rid())
	for position in _member_probe_positions(placement):
		if not _position_in_guarded_view(_arrival_camera, position):
			continue
		var query := PhysicsRayQueryParameters3D.create(_arrival_camera.global_position, position)
		query.exclude = exclusions
		if get_world_3d().direct_space_state.intersect_ray(query).is_empty():
			return false
	return true


func _position_in_guarded_view(camera: Camera3D, position: Vector3) -> bool:
	if camera.is_position_in_frustum(position):
		return true
	if camera.is_position_behind(position):
		return false
	var viewport_rect := camera.get_viewport().get_visible_rect()
	var margin := viewport_rect.size * destination_viewport_margin
	return Rect2(viewport_rect.position - margin, viewport_rect.size + margin * 2.0).has_point(
		camera.unproject_position(position)
	)


func _assembly_collision_rids() -> Array[RID]:
	var exclusions: Array[RID] = []
	_append_member_rids(_members, exclusions)
	return exclusions


func _append_member_rids(node: Node, exclusions: Array[RID]) -> void:
	var body := node as CollisionObject3D
	if body != null:
		exclusions.append(body.get_rid())
	for child in node.get_children():
		_append_member_rids(child, exclusions)


func _commit(index: int, carrying: bool) -> void:
	var old_transform := global_transform
	var new_transform := _configuration(index).global_transform
	var passenger_transform := Transform3D.IDENTITY
	var passenger_velocity := Vector3.ZERO
	if carrying:
		passenger_transform = new_transform * (old_transform.affine_inverse() * _player.global_transform)
		passenger_velocity = new_transform.basis * old_transform.basis.inverse() * _player.velocity
	global_transform = new_transform
	if carrying:
		_player.global_transform = passenger_transform
		_player.velocity = passenger_velocity
	var old_index := current_configuration_index
	previous_configuration_index = old_index
	current_configuration_index = index
	successful_move_count += 1
	_moved_this_unobserved_period = true
	_clear_pending()
	configuration_changed.emit(old_index, index, carrying)


func _clear_pending() -> void:
	_pending_index = -1
	_pending_support_state = -1
	_hidden_time = 0.0
	_grace_active = false
