extends OmniLight3D

@onready var _beam: StabilizationBeam = get_parent() as StabilizationBeam
@onready var _emitter_face: MeshInstance3D = get_parent().get_node("EmitterFace") as MeshInstance3D

var _emitter_material: StandardMaterial3D
var _feedback_tween: Tween


func _ready() -> void:
	_emitter_material = _emitter_face.material_override.duplicate() as StandardMaterial3D
	_emitter_face.material_override = _emitter_material
	_beam.enabled_changed.connect(_on_enabled_changed)
	_sync_state(_beam.enabled)


func _on_enabled_changed(is_enabled: bool) -> void:
	if _feedback_tween != null:
		_feedback_tween.kill()
	_sync_state(is_enabled)
	if is_enabled:
		light_energy = 0.7
		_feedback_tween = create_tween()
		_feedback_tween.tween_property(self, "light_energy", 0.35, 0.3)


func _sync_state(is_enabled: bool) -> void:
	light_color = Color(0.52, 0.68, 0.68)
	light_energy = 0.35 if is_enabled else 0.0
	_emitter_material.emission_energy_multiplier = 0.45 if is_enabled else 0.0
