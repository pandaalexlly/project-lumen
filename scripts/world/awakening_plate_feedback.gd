extends Node3D

@export var loaded_travel: float = 0.035
@export var response_duration: float = 0.22

@onready var _plate: PressurePlate = get_parent() as PressurePlate
@onready var _surface: MeshInstance3D = $Surface
@onready var _needle: Node3D = $LoadCell/Needle

var _surface_rest_y: float


func _ready() -> void:
	_surface_rest_y = _surface.position.y
	_plate.activated.connect(_on_occupied)
	_plate.deactivated.connect(_on_released)
	_needle.rotation.z = -0.5


func _on_occupied() -> void:
	_set_load_feedback(true)


func _on_released() -> void:
	_set_load_feedback(false)


func _set_load_feedback(loaded: bool) -> void:
	var response := create_tween().set_parallel(true)
	response.tween_property(
		_surface,
		"position:y",
		_surface_rest_y - loaded_travel if loaded else _surface_rest_y,
		response_duration
	)
	response.tween_property(
		_needle,
		"rotation:z",
		0.5 if loaded else -0.5,
		response_duration
	)
	var audio_manager := get_node_or_null("/root/AudioManager")
	if audio_manager != null:
		audio_manager.call("notify_plate_activation", loaded)
