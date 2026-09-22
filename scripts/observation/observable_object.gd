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

var _currently_observed: bool = false
var _has_observation_state: bool = false


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_observation_manager) or not is_instance_valid(_observation_anchor):
		return

	var is_observed := _evaluate_current_observation()
	_apply_observation_state(is_observed)


func _evaluate_current_observation() -> bool:
	return _observation_manager.is_directly_observed(self, _observation_anchor)


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
