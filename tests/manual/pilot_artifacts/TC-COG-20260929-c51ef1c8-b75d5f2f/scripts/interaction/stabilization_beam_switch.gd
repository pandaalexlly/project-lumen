class_name StabilizationBeamSwitch
extends Interactable

enum ControlMode {
	TOGGLE_POWER,
	TOGGLE_AIM,
}

@export var control_mode: ControlMode = ControlMode.TOGGLE_POWER
@export_node_path("StabilizationBeam") var beam_path: NodePath
@export_node_path("Node3D") var primary_aim_path: NodePath
@export_node_path("Node3D") var secondary_aim_path: NodePath
@export var debug_output: bool = true

@onready var _beam: StabilizationBeam = get_node_or_null(beam_path) as StabilizationBeam
@onready var _primary_aim: Node3D = get_node_or_null(primary_aim_path) as Node3D
@onready var _secondary_aim: Node3D = get_node_or_null(secondary_aim_path) as Node3D
@onready var _primary_indicator: MeshInstance3D = $PrimaryIndicator
@onready var _secondary_indicator: MeshInstance3D = $SecondaryIndicator

var using_secondary_aim: bool:
	get:
		return _using_secondary_aim

var _using_secondary_aim: bool = false


func _ready() -> void:
	if is_instance_valid(_beam):
		_beam.enabled_changed.connect(_on_beam_enabled_changed)
	if control_mode == ControlMode.TOGGLE_AIM:
		_apply_aim()
	_update_indicators()


func interact() -> void:
	if not is_instance_valid(_beam):
		return
	if control_mode == ControlMode.TOGGLE_POWER:
		_beam.toggle_enabled()
	else:
		_using_secondary_aim = not _using_secondary_aim
		_apply_aim()
		var audio_manager := get_node_or_null("/root/AudioManager")
		if audio_manager != null:
			audio_manager.call("notify_beam_redirect")
		var presentation_ui := get_node_or_null("/root/PresentationUI")
		if presentation_ui != null:
			presentation_ui.call("show_notification", "BEAM REDIRECTED")
		if debug_output:
			print("%s: aiming at %s" % [name, "B" if _using_secondary_aim else "A"])
	_update_indicators()


func _apply_aim() -> void:
	var target := _secondary_aim if _using_secondary_aim else _primary_aim
	if is_instance_valid(_beam) and is_instance_valid(target):
		_beam.aim_at(target.global_position)


func _on_beam_enabled_changed(_is_enabled: bool) -> void:
	_update_indicators()


func _update_indicators() -> void:
	if not is_instance_valid(_primary_indicator) or not is_instance_valid(_secondary_indicator):
		return
	var show_secondary := (
		_beam.enabled
		if control_mode == ControlMode.TOGGLE_POWER and is_instance_valid(_beam)
		else _using_secondary_aim
	)
	_primary_indicator.visible = not show_secondary
	_secondary_indicator.visible = show_secondary
