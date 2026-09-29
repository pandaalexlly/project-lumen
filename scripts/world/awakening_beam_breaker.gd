extends Interactable

@export_node_path("StabilizationBeam") var beam_path: NodePath

var supplied: bool = false

@onready var _beam: StabilizationBeam = get_node_or_null(beam_path) as StabilizationBeam
@onready var _handle: Node3D = $Handle


func _ready() -> void:
	if is_instance_valid(_beam):
		_beam.enabled_changed.connect(_on_beam_enabled_changed)
		_on_beam_enabled_changed(_beam.enabled)


func set_supplied(value: bool) -> void:
	supplied = value


func interact() -> void:
	if not supplied or not is_instance_valid(_beam):
		return
	_beam.toggle_enabled()


func _on_beam_enabled_changed(is_enabled: bool) -> void:
	create_tween().tween_property(
		_handle,
		"rotation:y",
		PI * 0.5 if is_enabled else 0.0,
		0.25
	)
