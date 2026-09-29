extends Node

signal interaction_requested
signal cube_relocated
signal beam_state_changed(is_enabled: bool)
signal beam_redirected
signal plate_state_changed(is_active: bool)
signal door_opened
signal completion_reached

@onready var sfx: AudioStreamPlayer = $SFX
@onready var ambient: AudioStreamPlayer = $Ambient


func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	sfx.stream = stream
	sfx.play()


func play_ambient(stream: AudioStream) -> void:
	if stream == null:
		return
	ambient.stream = stream
	ambient.play()


func stop_ambient() -> void:
	ambient.stop()


func notify_interaction() -> void:
	interaction_requested.emit()


func notify_cube_relocation() -> void:
	cube_relocated.emit()


func notify_beam_state(is_enabled: bool) -> void:
	beam_state_changed.emit(is_enabled)


func notify_beam_redirect() -> void:
	beam_redirected.emit()


func notify_plate_activation(is_active: bool) -> void:
	plate_state_changed.emit(is_active)


func notify_door_opened() -> void:
	door_opened.emit()


func notify_completion() -> void:
	completion_reached.emit()
