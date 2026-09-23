class_name PrototypeSessionController
extends Node

@export_node_path("CharacterBody3D") var player_path: NodePath
@export_node_path("Area3D") var exit_trigger_path: NodePath
@export_node_path("CanvasItem") var completion_overlay_path: NodePath
@export var fall_restart_y: float = -5.0

var is_complete: bool:
	get:
		return _is_complete

@onready var _player: CharacterBody3D = get_node_or_null(player_path) as CharacterBody3D
@onready var _exit_trigger: Area3D = get_node_or_null(exit_trigger_path) as Area3D
@onready var _completion_overlay: CanvasItem = get_node_or_null(completion_overlay_path) as CanvasItem

var _is_complete: bool = false
var _restart_in_progress: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if is_instance_valid(_completion_overlay):
		_completion_overlay.visible = false
	if is_instance_valid(_exit_trigger):
		_exit_trigger.body_entered.connect(_on_exit_trigger_body_entered)


func _physics_process(_delta: float) -> void:
	if (
		not _is_complete
		and is_instance_valid(_player)
		and _player.global_position.y < fall_restart_y
	):
		restart_prototype()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_prototype") and not event.is_echo():
		restart_prototype()


func restart_prototype() -> void:
	if _restart_in_progress:
		return
	_restart_in_progress = true
	get_tree().paused = false
	var reload_error := get_tree().reload_current_scene()
	if reload_error != OK:
		_restart_in_progress = false
		push_error("PrototypeSessionController: failed to reload current scene")


func _on_exit_trigger_body_entered(body: Node3D) -> void:
	if _is_complete or body != _player:
		return
	_is_complete = true
	if is_instance_valid(_completion_overlay):
		_completion_overlay.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
