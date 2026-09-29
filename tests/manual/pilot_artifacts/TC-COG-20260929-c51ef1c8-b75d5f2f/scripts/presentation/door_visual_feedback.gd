extends OmniLight3D

const OPEN_COLOR := Color(0.1, 1.0, 0.45)
const CLOSED_COLOR := Color(1.0, 0.28, 0.06)

var _feedback_tween: Tween


func _ready() -> void:
	var door := get_parent() as SimpleDoor
	if door == null:
		return
	door.opened.connect(_on_opened)
	door.closed.connect(_on_closed)
	light_energy = 0.0


func _on_opened() -> void:
	_pulse(OPEN_COLOR, 2.8, 0.22)


func _on_closed() -> void:
	_pulse(CLOSED_COLOR, 1.4, 0.0)


func _pulse(color: Color, peak_energy: float, settled_energy: float) -> void:
	if _feedback_tween != null:
		_feedback_tween.kill()
	light_color = color
	light_energy = peak_energy
	_feedback_tween = create_tween()
	_feedback_tween.tween_property(self, "light_energy", settled_energy, 0.36)
