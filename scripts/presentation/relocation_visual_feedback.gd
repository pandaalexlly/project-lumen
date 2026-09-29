extends Node

@export_node_path("MeshInstance3D") var visual_path: NodePath
@export_node_path("OmniLight3D") var light_path: NodePath

@onready var _visual: MeshInstance3D = get_node_or_null(visual_path) as MeshInstance3D
@onready var _light: OmniLight3D = get_node_or_null(light_path) as OmniLight3D

var _last_position: Vector3
var _armed: bool = false
var _pulse_tween: Tween


func _ready() -> void:
	call_deferred("_arm")


func _process(_delta: float) -> void:
	if not _armed:
		return
	var parent_3d := get_parent() as Node3D
	if parent_3d == null or parent_3d.global_position.is_equal_approx(_last_position):
		return
	_last_position = parent_3d.global_position
	_pulse()


func _arm() -> void:
	var parent_3d := get_parent() as Node3D
	if parent_3d == null:
		return
	_last_position = parent_3d.global_position
	_armed = true


func _pulse() -> void:
	if _pulse_tween != null:
		_pulse_tween.kill()
	if is_instance_valid(_visual):
		_visual.scale = Vector3.ONE * 1.18
	if is_instance_valid(_light):
		_light.light_energy = 3.0
	_pulse_tween = create_tween().set_parallel()
	if is_instance_valid(_visual):
		_pulse_tween.tween_property(_visual, "scale", Vector3.ONE, 0.24)
	if is_instance_valid(_light):
		_pulse_tween.tween_property(_light, "light_energy", 0.0, 0.32)
