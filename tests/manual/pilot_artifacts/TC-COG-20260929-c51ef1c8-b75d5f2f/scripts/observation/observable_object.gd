class_name ObservableObject
extends Node3D

signal observation_started
signal observation_ended

@export var observation_manager_path: NodePath
@export_node_path("Node3D") var observation_anchor_path: NodePath = NodePath("ObservationAnchor")

@onready var _observation_manager: ObservationManager = get_node_or_null(observation_manager_path) as ObservationManager
@onready var _observation_anchor: Node3D = get_node_or_null(observation_anchor_path) as Node3D

var currently_observed: bool:
	get:
		return _currently_observed

var directly_observed: bool:
	get:
		return _directly_observed

var artificially_observed: bool:
	get:
		return _artificially_observed

var _currently_observed: bool = false
var _directly_observed: bool = false
var _artificially_observed: bool = false
var _has_observation_state: bool = false


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_observation_anchor):
		return

	_directly_observed = (
		_evaluate_current_observation()
		if is_instance_valid(_observation_manager)
		else false
	)
	_artificially_observed = _is_any_artificial_source_observing(
		_get_current_observation_probe_positions(),
		self,
		null
	)
	_apply_observation_state(_directly_observed or _artificially_observed)


func _evaluate_current_observation() -> bool:
	return _observation_manager.is_directly_observed(self, _observation_anchor)


func _get_current_observation_probe_positions() -> PackedVector3Array:
	return PackedVector3Array([_observation_anchor.global_position])


func _is_any_artificial_source_observing(
	world_positions: PackedVector3Array,
	target_root: Node,
	ignored_root: Node = null
) -> bool:
	for source_node in get_tree().get_nodes_in_group(
		ArtificialObservationSource.SOURCE_GROUP
	):
		var source := source_node as ArtificialObservationSource
		if (
			source != null
			and source.observes_any_position(
				world_positions,
				target_root,
				ignored_root
			)
		):
			return true
	return false


func _apply_observation_state(is_observed: bool) -> void:
	if not _has_observation_state:
		_has_observation_state = true
		_currently_observed = is_observed
		if is_observed:
			observation_started.emit()
			_on_observation_started()
		return

	if is_observed == _currently_observed:
		return

	_currently_observed = is_observed
	if is_observed:
		observation_started.emit()
		_on_observation_started()
	else:
		observation_ended.emit()
		_on_observation_ended()


func _on_observation_started() -> void:
	pass


func _on_observation_ended() -> void:
	pass
