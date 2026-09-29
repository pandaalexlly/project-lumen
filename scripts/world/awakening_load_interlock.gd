extends Interactable

signal activated

@export_node_path("PressurePlate") var plate_path: NodePath

var supplied: bool = false
var latched: bool = false
var release_powered: bool = false

@onready var _plate: PressurePlate = get_node_or_null(plate_path) as PressurePlate
@onready var _needle: Node3D = $RelayNeedle
@onready var _indicator: MeshInstance3D = $Indicator
@onready var _button: MeshInstance3D = $ReleaseButton
@onready var _interaction_body: StaticBody3D = $InteractionBody
@onready var _collider: CollisionShape3D = $InteractionBody/CollisionShape3D

var _button_material: StandardMaterial3D


func _ready() -> void:
	interaction_label = "Operate bulkhead release"
	if is_instance_valid(_plate):
		_plate.activated.connect(_refresh_state)
		_plate.deactivated.connect(_refresh_state)
	_indicator.material_override = _indicator.get_active_material(0).duplicate()
	_button_material = _button.get_active_material(0).duplicate() as StandardMaterial3D
	_button.material_override = _button_material
	_refresh_state()


func set_supplied(value: bool) -> void:
	supplied = value
	_refresh_state()


func interact() -> void:
	# Check actual occupancy at the instant of use, not a cached indication.
	if latched or not supplied or not is_instance_valid(_plate) or not _plate.is_active:
		_refresh_state()
		return
	latched = true
	_refresh_state()
	activated.emit()


func _refresh_state() -> void:
	release_powered = not latched and supplied and is_instance_valid(_plate) and _plate.is_active
	if not is_node_ready():
		return
	_needle.rotation.z = 0.55 if release_powered or latched else -0.55
	var indicator_material := _indicator.material_override as StandardMaterial3D
	indicator_material.emission_energy_multiplier = 1.2 if release_powered else 0.0
	_button_material.albedo_color = Color(0.54, 0.29, 0.12) if release_powered else Color(0.25, 0.14, 0.1)
	_button_material.emission_energy_multiplier = 0.38 if release_powered else 0.0
	_button.position.z = -0.18 if release_powered else -0.155
	# An unpowered control cannot generate an interaction prompt or telemetry.
	_interaction_body.collision_layer = 1 if release_powered else 0
	_collider.set_deferred("disabled", not release_powered)
