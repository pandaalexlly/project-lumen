extends Node3D

@export_node_path("Node3D") var needle_path: NodePath
@export_node_path("MeshInstance3D") var instrument_face_path: NodePath
@export_node_path("OmniLight3D") var indicator_light_path: NodePath

@onready var _needle: Node3D = get_node_or_null(needle_path) as Node3D
@onready var _instrument_face: MeshInstance3D = get_node_or_null(instrument_face_path) as MeshInstance3D
@onready var _indicator_light: OmniLight3D = get_node_or_null(indicator_light_path) as OmniLight3D

var _needle_rest_rotation: float = 0.0
var _instrument_material: StandardMaterial3D
var _pulse_tween: Tween


func _ready() -> void:
	if is_instance_valid(_needle):
		_needle_rest_rotation = _needle.rotation.z
	if is_instance_valid(_instrument_face):
		_instrument_material = _instrument_face.get_active_material(0).duplicate() as StandardMaterial3D
		_instrument_material.emission_enabled = true
		_instrument_material.emission = Color(0.58, 0.42, 0.18, 1)
		_instrument_material.emission_energy_multiplier = 0.0
		_instrument_face.material_override = _instrument_material
	var audio_manager := get_node_or_null("/root/AudioManager")
	if audio_manager != null and audio_manager.has_signal("cube_relocated"):
		audio_manager.connect("cube_relocated", _on_cube_relocated)


func _on_cube_relocated() -> void:
	if _pulse_tween != null:
		_pulse_tween.kill()
	if is_instance_valid(_needle):
		_needle.rotation.z = _needle_rest_rotation - 0.42
	if is_instance_valid(_instrument_material):
		_instrument_material.emission_energy_multiplier = 0.28
	if is_instance_valid(_indicator_light):
		_indicator_light.light_energy = 0.18
	_pulse_tween = create_tween().set_parallel(true)
	if is_instance_valid(_needle):
		_pulse_tween.tween_property(_needle, "rotation:z", _needle_rest_rotation, 0.42).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if is_instance_valid(_instrument_material):
		_pulse_tween.tween_property(_instrument_material, "emission_energy_multiplier", 0.0, 0.55)
	if is_instance_valid(_indicator_light):
		_pulse_tween.tween_property(_indicator_light, "light_energy", 0.0, 0.55)
