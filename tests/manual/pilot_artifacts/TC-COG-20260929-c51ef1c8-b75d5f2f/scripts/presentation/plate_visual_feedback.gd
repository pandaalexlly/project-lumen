extends OmniLight3D

const ACTIVE_COLOR := Color(0.12, 1.0, 0.42)
const INACTIVE_COLOR := Color(1.0, 0.45, 0.08)

var _feedback_tween: Tween


func _ready() -> void:
	var plate := get_parent() as PressurePlate
	if plate == null:
		return
	plate.activated.connect(_on_activated)
	plate.deactivated.connect(_on_deactivated)
	light_color = INACTIVE_COLOR
	light_energy = 0.0


func _on_activated() -> void:
	_pulse(ACTIVE_COLOR, 2.4, 0.28)
	var audio_manager := get_node_or_null("/root/AudioManager")
	if audio_manager != null:
		audio_manager.call("notify_plate_activation", true)


func _on_deactivated() -> void:
	_pulse(INACTIVE_COLOR, 1.2, 0.0)
	var audio_manager := get_node_or_null("/root/AudioManager")
	if audio_manager != null:
		audio_manager.call("notify_plate_activation", false)


func _pulse(color: Color, peak_energy: float, settled_energy: float) -> void:
	if _feedback_tween != null:
		_feedback_tween.kill()
	light_color = color
	light_energy = peak_energy
	_feedback_tween = create_tween()
	_feedback_tween.tween_property(self, "light_energy", settled_energy, 0.32)
