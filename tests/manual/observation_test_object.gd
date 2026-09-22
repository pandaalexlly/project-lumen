extends Node3D

@export var observation_manager_path: NodePath

@onready var observation_manager: ObservationManager = get_node_or_null(observation_manager_path) as ObservationManager
@onready var observation_anchor: Node3D = $ObservationAnchor

var _has_observation_state: bool = false
var _was_observed: bool = false


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(observation_manager):
		return

	var is_observed := observation_manager.is_directly_observed(self, observation_anchor)
	if _has_observation_state and is_observed == _was_observed:
		return

	_has_observation_state = true
	_was_observed = is_observed
	if is_observed:
		print("Observation test: OBSERVED")
	else:
		print("Observation test: NOT OBSERVED")
