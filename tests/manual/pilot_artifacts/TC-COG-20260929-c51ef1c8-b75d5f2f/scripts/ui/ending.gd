extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Layout/RevisitButton.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_prototype") and not event.is_echo():
		_on_revisit_pressed()


func _on_revisit_pressed() -> void:
	var flow := get_node_or_null("/root/GameFlow")
	if flow != null:
		flow.call("restart_current_stage")


func _on_menu_pressed() -> void:
	var flow := get_node_or_null("/root/GameFlow")
	if flow != null:
		flow.call("return_to_menu")
