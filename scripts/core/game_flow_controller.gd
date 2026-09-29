extends Node

signal stage_entered(title: String)
signal ending_reached

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"
const ENDING_SCENE := "res://scenes/ui/ending.tscn"
const STAGE_SCENES: Array[String] = [
	"res://scenes/prototype/observation_lab.tscn",
	"res://scenes/prototype/stabilization_lab_discovery.tscn",
	"res://scenes/prototype/stabilization_lab_destination.tscn",
	"res://scenes/prototype/stabilization_lab_combined.tscn",
	"res://scenes/prototype/field_observation_site.tscn",
]
const STAGE_TITLES: Array[String] = [
	"OBSERVATION CALIBRATION CHAMBER",
	"STABILIZATION TEST — ACTIVE FIELD",
	"STABILIZATION TEST — FIELD REDIRECTION",
	"STABILIZATION TEST — COMBINED OBSERVATION",
	"EXTERNAL OBSERVATION RELAY SITE",
]

var current_stage_index: int = -1
var _transition_in_progress: bool = false


func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)


func start_new_game() -> void:
	var telemetry := get_node_or_null("/root/PlaytestTelemetry")
	if telemetry != null:
		telemetry.call("start_session", "main_menu")
	_change_to_stage(0)


func advance_from_scene(scene_path: String) -> bool:
	if _transition_in_progress:
		return true
	var stage_index := STAGE_SCENES.find(scene_path)
	if stage_index == -1:
		return false
	var next_scene_path := (
		STAGE_SCENES[stage_index + 1]
		if stage_index + 1 < STAGE_SCENES.size()
		else ENDING_SCENE
	)
	var telemetry := get_node_or_null("/root/PlaytestTelemetry")
	if telemetry != null:
		telemetry.call("record_room_completed", scene_path, next_scene_path)
	if stage_index + 1 < STAGE_SCENES.size():
		_change_to_stage(stage_index + 1)
	else:
		_change_scene(ENDING_SCENE)
	return true


func restart_current_stage() -> void:
	if current_stage_index >= 0 and current_stage_index < STAGE_SCENES.size():
		var telemetry := get_node_or_null("/root/PlaytestTelemetry")
		if telemetry != null:
			telemetry.call("start_session", "stage_revisit")
		_change_to_stage(current_stage_index)


func return_to_menu() -> void:
	var telemetry := get_node_or_null("/root/PlaytestTelemetry")
	if telemetry != null:
		telemetry.call("finish_session", "returned_to_menu")
	current_stage_index = -1
	_change_scene(MAIN_MENU_SCENE)


func is_managed_stage(scene_path: String) -> bool:
	return STAGE_SCENES.has(scene_path)


func _change_to_stage(stage_index: int) -> void:
	if stage_index < 0 or stage_index >= STAGE_SCENES.size():
		return
	current_stage_index = stage_index
	_change_scene(STAGE_SCENES[stage_index])


func _change_scene(scene_path: String) -> void:
	if _transition_in_progress:
		return
	_transition_in_progress = true
	get_tree().paused = false
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		_transition_in_progress = false
		push_error("GameFlow: failed to load %s" % scene_path)


func _on_scene_changed() -> void:
	_transition_in_progress = false
	var scene_root := get_tree().current_scene
	if scene_root == null:
		return
	var scene_path := scene_root.scene_file_path
	var stage_index := STAGE_SCENES.find(scene_path)
	if stage_index >= 0:
		current_stage_index = stage_index
		var telemetry := get_node_or_null("/root/PlaytestTelemetry")
		if telemetry != null:
			telemetry.call(
				"record_room_entered",
				scene_path,
				STAGE_TITLES[current_stage_index],
				current_stage_index
			)
		stage_entered.emit(STAGE_TITLES[current_stage_index])
	elif scene_path == ENDING_SCENE:
		ending_reached.emit()
		var telemetry := get_node_or_null("/root/PlaytestTelemetry")
		if telemetry != null:
			telemetry.call("finish_session", "ending_reached")
		var audio_manager := get_node_or_null("/root/AudioManager")
		if audio_manager != null:
			audio_manager.call("notify_completion")
