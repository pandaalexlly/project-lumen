extends Interactable

signal activated

var is_active: bool = false


func interact() -> void:
	if is_active:
		return
	is_active = true
	var handle := $Handle as Node3D
	create_tween().tween_property(handle, "rotation:y", PI * 0.5, 0.25)
	activated.emit()
