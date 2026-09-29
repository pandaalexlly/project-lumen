class_name CombinedTeachingCube
extends QuantumCube

@export_node_path("Node3D") var failure_destination_path: NodePath
@export_node_path("Node3D") var goal_destination_path: NodePath

var _failure_destination_index: int = -1
var _goal_destination_index: int = -1


func _ready() -> void:
	super()
	_failure_destination_index = _destinations.find(
		_resolve_external_destination(failure_destination_path)
	)
	_goal_destination_index = _destinations.find(
		_resolve_external_destination(goal_destination_path)
	)
	if _failure_destination_index == -1 or _goal_destination_index == -1:
		push_warning("%s: teaching destinations are not valid configured destinations" % name)


func _select_safe_destination(safe_indices: Array[int]) -> int:
	if safe_indices.has(_failure_destination_index):
		return _failure_destination_index
	if safe_indices.has(_goal_destination_index):
		return _goal_destination_index
	return -1
