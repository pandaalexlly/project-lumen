class_name SimpleDoor
extends StaticBody3D

@export var open_offset: Vector3 = Vector3(0, 3, 0)

var is_open: bool:
	get:
		return _is_open

var _is_open: bool = false
@onready var _closed_position: Vector3 = position


func open() -> void:
	if _is_open:
		return
	_is_open = true
	position = _closed_position + open_offset


func close() -> void:
	if not _is_open:
		return
	_is_open = false
	position = _closed_position
