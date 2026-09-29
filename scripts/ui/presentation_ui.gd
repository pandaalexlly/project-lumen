extends CanvasLayer

const TITLE_DURATION := 2.8
const NOTICE_DURATION := 1.8

@onready var room_title: Label = $RoomTitlePanel/RoomTitle
@onready var room_title_panel: PanelContainer = $RoomTitlePanel
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var event_notice: Label = $EventNotice

var _interaction_component: InteractionComponent
var _last_scene: Node
var _title_tween: Tween
var _notice_tween: Tween


func _ready() -> void:
	room_title_panel.modulate.a = 0.0
	interaction_prompt.visible = false
	event_notice.modulate.a = 0.0
	var flow := get_node_or_null("/root/GameFlow")
	if flow != null:
		flow.stage_entered.connect(show_room_title)
	set_process(true)


func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene != _last_scene:
		_last_scene = scene
		_interaction_component = null
		if _notice_tween != null:
			_notice_tween.kill()
		event_notice.modulate.a = 0.0
		if scene != null:
			_interaction_component = scene.get_node_or_null(
				"Player/Head/Camera3D/InteractionComponent"
			) as InteractionComponent
		if not is_instance_valid(_interaction_component):
			if _title_tween != null:
				_title_tween.kill()
			room_title_panel.modulate.a = 0.0
	if not is_instance_valid(_interaction_component):
		interaction_prompt.visible = false
		return
	var interactable := _interaction_component.get_focused_interactable()
	interaction_prompt.visible = interactable != null
	if interactable != null:
		interaction_prompt.text = "[E]  %s" % interactable.interaction_label


func show_room_title(title: String) -> void:
	if _title_tween != null:
		_title_tween.kill()
	room_title.text = title
	room_title_panel.modulate.a = 0.0
	_title_tween = create_tween()
	_title_tween.tween_property(room_title_panel, "modulate:a", 1.0, 0.22)
	_title_tween.tween_interval(TITLE_DURATION)
	_title_tween.tween_property(room_title_panel, "modulate:a", 0.0, 0.45)


func show_notification(message: String) -> void:
	# Relocation now has immediate world-space feedback; repeating it in HUD text
	# reads like diagnostic output and competes with the player's own observation.
	if message.is_empty() or message == "ANOMALOUS STATE CHANGED":
		return
	if _notice_tween != null:
		_notice_tween.kill()
	event_notice.text = message
	event_notice.modulate.a = 0.0
	_notice_tween = create_tween()
	_notice_tween.tween_property(event_notice, "modulate:a", 1.0, 0.12)
	_notice_tween.tween_interval(NOTICE_DURATION)
	_notice_tween.tween_property(event_notice, "modulate:a", 0.0, 0.3)
