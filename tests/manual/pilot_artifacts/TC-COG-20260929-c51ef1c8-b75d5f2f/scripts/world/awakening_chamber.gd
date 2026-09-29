extends Node3D

@export var restoration_duration: float = 2.4
@export var ventilation_speed: float = 2.0
@export var restored_light_energy: float = 2.2
@export var restored_instrument_emission: float = 1.4

var restored: bool = false
var _fan_speed: float = 0.0
var _presentation: CanvasLayer
var _previous_presentation_visibility: bool = true

@onready var _rotor: Node3D = $Infrastructure/Ventilation/Rotor
@onready var _beam: StabilizationBeam = $StabilizationBeam
@onready var _beam_breaker: Interactable = $BeamBreaker
@onready var _load_interlock: Node3D = $BulkheadLoadRelay


func _ready() -> void:
	# Keep prototype HUD behavior scoped to prototype scenes.
	_presentation = get_node_or_null("/root/PresentationUI") as CanvasLayer
	if _presentation != null:
		_previous_presentation_visibility = _presentation.visible
		_presentation.hide()
	$Shell/ServiceControl.activated.connect(_restore_services)
	set_process(false)


func _exit_tree() -> void:
	if is_instance_valid(_presentation):
		_presentation.visible = _previous_presentation_visibility


func _process(delta: float) -> void:
	_rotor.rotate_z(_fan_speed * delta)


func _restore_services() -> void:
	if restored:
		return
	restored = true
	set_process(true)
	_beam.aim_at($CubeDestinations/WestEquipmentBay.global_position)
	_beam_breaker.call("set_supplied", true)
	_beam.set_enabled(true)
	_load_interlock.call("set_supplied", true)
	var startup := create_tween().set_parallel(true)
	startup.tween_property(self, "_fan_speed", ventilation_speed, restoration_duration)
	for light in $Lighting/RestoredWorkLights.get_children():
		startup.tween_property(light, "light_energy", restored_light_energy, restoration_duration)
	for panel in $Infrastructure/LiveInstrumentFaces.get_children():
		var face := panel as MeshInstance3D
		var material := face.get_active_material(0).duplicate() as StandardMaterial3D
		face.material_override = material
		startup.tween_property(material, "emission_energy_multiplier", restored_instrument_emission, restoration_duration)
