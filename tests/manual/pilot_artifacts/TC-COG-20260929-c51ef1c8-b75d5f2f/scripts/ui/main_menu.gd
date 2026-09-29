extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Layout/StartButton.grab_focus()


func _on_start_pressed() -> void:
	var flow := get_node_or_null("/root/GameFlow")
	if flow != null:
		flow.call("start_new_game")
