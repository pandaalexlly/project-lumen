class_name ApplicationQuantumCube
extends QuantumCube

@export var guaranteed_destination_path: NodePath
@export_range(3, 4, 1) var guaranteed_move_min: int = 3
@export_range(3, 4, 1) var guaranteed_move_max: int = 4

var guaranteed_move_number: int:
	get:
		return _guaranteed_move_number

var guaranteed_destination_index: int:
	get:
		return _guaranteed_destination_index

var _guaranteed_move_number: int = -1
var _guaranteed_destination_index: int = -1


func _ready() -> void:
	super()
	var guaranteed_destination := _resolve_external_destination(guaranteed_destination_path)
	_guaranteed_destination_index = _destinations.find(guaranteed_destination)
	var minimum_move := maxi(guaranteed_move_min, 1)
	var maximum_move := maxi(guaranteed_move_max, 1)
	_guaranteed_move_number = randi_range(
		mini(minimum_move, maximum_move),
		maxi(minimum_move, maximum_move)
	)
	if debug_output:
		print(
			"%s: guaranteed destination move %d"
			% [name, _guaranteed_move_number]
		)
	if _guaranteed_destination_index == -1:
		push_warning("%s: guaranteed destination is not a valid configured destination" % name)


func _select_safe_destination(safe_indices: Array[int]) -> int:
	if _guaranteed_destination_index == -1:
		return -1

	var next_move_number := successful_move_count + 1
	if next_move_number < _guaranteed_move_number:
		var non_guaranteed_indices := safe_indices.filter(
			func(index: int) -> bool:
				return index != _guaranteed_destination_index
		)
		return super._select_safe_destination(non_guaranteed_indices)

	if next_move_number == _guaranteed_move_number:
		return (
			_guaranteed_destination_index
			if safe_indices.has(_guaranteed_destination_index)
			else -1
		)

	return super._select_safe_destination(safe_indices)
