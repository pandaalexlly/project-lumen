extends OmniLight3D

const ACTIVE_COLOR := Color(0.1, 0.82, 1.0)
const INACTIVE_COLOR := Color(1.0, 0.28, 0.06)

var _feedback_tween: Tween


func _ready() -> void:
	var beam := get_parent() as StabilizationBeam
	if beam == null:
		return
	beam.enabled_changed.connect(_on_enabled_changed)
	_sync_initial.call_deferred()


func _sync_initial() -> void:
	var beam := get_parent() as StabilizationBeam
	if beam != null:
		light_color = ACTIVE_COLOR if beam.enabled else INACTIVE_COLOR
		light_energy = 0.85 if beam.enabled else 0.12


func _on_enabled_changed(is_enabled: bool) -> void:
	if _feedback_tween != null:
		_feedback_tween.kill()
	light_color = ACTIVE_COLOR if is_enabled else INACTIVE_COLOR
	light_energy = 3.0 if is_enabled else 2.0
	_feedback_tween = create_tween()
	_feedback_tween.tween_property(
		self,
		"light_energy",
		0.85 if is_enabled else 0.12,
		0.3
	)
