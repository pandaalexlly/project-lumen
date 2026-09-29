extends Node3D

signal module_relocated(previous_slot: int, current_slot: int)

const RECEIVER_POSITIONS := [Vector3(-4.2, 0, -1.8), Vector3(4.2, 0, -1.8)]
const MODULE_HALF_WIDTH := 1.05
const MODULE_HALF_DEPTH := 0.7
const PLAYER_CLEARANCE := 0.55
const SETTING_SCRIPT := preload("res://scripts/world/state_persistence_setting.gd")

@export var unobserved_delay := 0.55
@export_range(0.0, 0.25, 0.01) var viewport_margin := 0.08

@onready var _manager: ObservationManager = $ObservationManager
@onready var _player: PlayerController = $Player

var module: Node3D
var setting: StatePersistenceSetting
var current_slot := 0
var successful_move_count := 0
var fixed_lamp_on := false

var _armed := false
var _hidden_time := 0.0
var _fixed: Node3D
var _lamp_lens: MeshInstance3D
var _lamp_light: OmniLight3D
var _shell_material: StandardMaterial3D
var _floor_material: StandardMaterial3D
var _repair_material: StandardMaterial3D
var _fixed_material: StandardMaterial3D
var _dark_material: StandardMaterial3D
var _lamp_on_material: StandardMaterial3D
var _lamp_off_material: StandardMaterial3D


func _ready() -> void:
	_shell_material = _material(Color(0.43, 0.45, 0.44))
	_floor_material = _material(Color(0.27, 0.30, 0.31))
	_repair_material = _material(Color(0.57, 0.54, 0.48))
	_fixed_material = _material(Color(0.33, 0.37, 0.39))
	_dark_material = _material(Color(0.16, 0.19, 0.20))
	_lamp_on_material = _material(Color(0.83, 0.68, 0.37))
	_lamp_on_material.emission_enabled = true
	_lamp_on_material.emission = Color(0.83, 0.60, 0.26)
	_lamp_on_material.emission_energy_multiplier = 2.0
	_lamp_off_material = _material(Color(0.20, 0.19, 0.16))
	_build_fixed_world()
	_build_module()
	_update_fixed_output()


func _physics_process(delta: float) -> void:
	if module == null:
		return
	if _current_visible():
		_armed = true
		_hidden_time = 0.0
		return
	if not _armed or _player_overlaps_slot(current_slot) or _player_overlaps_slot(1 - current_slot):
		_hidden_time = 0.0
		return
	if _candidate_visible(1 - current_slot):
		_hidden_time = 0.0
		return
	_hidden_time += delta
	if _hidden_time < unobserved_delay:
		return
	if _current_visible() or _candidate_visible(1 - current_slot):
		_hidden_time = 0.0
		return
	var previous_slot := current_slot
	current_slot = 1 - current_slot
	module.position = RECEIVER_POSITIONS[current_slot]
	successful_move_count += 1
	_armed = false
	_hidden_time = 0.0
	_update_fixed_output()
	module_relocated.emit(previous_slot, current_slot)


func _current_visible() -> bool:
	for probe_node in module.get_node("VisibilityProbes").get_children():
		var probe := probe_node as Node3D
		if probe != null and _manager.is_target_position_directly_visible_with_margin(
			module, probe.global_position, viewport_margin
		):
			return true
	return false


func _candidate_visible(slot: int) -> bool:
	var placement := Transform3D(Basis.IDENTITY, RECEIVER_POSITIONS[slot])
	for probe_node in module.get_node("VisibilityProbes").get_children():
		var probe := probe_node as Node3D
		if probe == null:
			continue
		var candidate_position := placement * module.to_local(probe.global_position)
		if _manager.is_position_directly_visible_ignoring_root(
			candidate_position, viewport_margin, module
		):
			return true
	return false


func _player_overlaps_slot(slot: int) -> bool:
	var offset: Vector3 = _player.global_position - RECEIVER_POSITIONS[slot]
	return (
		absf(offset.x) < MODULE_HALF_WIDTH + PLAYER_CLEARANCE
		and absf(offset.z) < MODULE_HALF_DEPTH + PLAYER_CLEARANCE
	)


func _update_fixed_output(_value: bool = false) -> void:
	fixed_lamp_on = current_slot == 0 and setting.condition_on
	_lamp_lens.material_override = _lamp_on_material if fixed_lamp_on else _lamp_off_material
	_lamp_light.visible = fixed_lamp_on


func _build_fixed_world() -> void:
	_fixed = Node3D.new()
	_fixed.name = "FixedWorld"
	add_child(_fixed)
	_box(_fixed, "Ground", Vector3(0, -0.18, -1.4), Vector3(24, 0.36, 19), _floor_material, true)
	_box(_fixed, "SharedServiceWalk", Vector3(0, 0.035, 4.1), Vector3(17, 0.07, 3.0), _fixed_material)
	_box(_fixed, "CentralCover", Vector3(0, 0.9, 0.5), Vector3(1.3, 1.8, 1.2), _fixed_material, true)
	_box(_fixed, "CoverCap", Vector3(0, 1.86, 0.5), Vector3(1.55, 0.12, 1.4), _repair_material)
	for slot in range(2):
		var receiver := Node3D.new()
		receiver.name = "ReceiverA" if slot == 0 else "ReceiverB"
		_fixed.add_child(receiver)
		receiver.position = RECEIVER_POSITIONS[slot]
		_box(receiver, "Bed", Vector3(0, 0.045, 0), Vector3(2.7, 0.09, 2.15), _fixed_material)
		_box(receiver, "LeftRim", Vector3(-1.4, 0.11, 0), Vector3(0.13, 0.22, 2.25), _dark_material)
		_box(receiver, "RightRim", Vector3(1.4, 0.11, 0), Vector3(0.13, 0.22, 2.25), _dark_material)
		_box(receiver, "RearRim", Vector3(0, 0.11, -1.1), Vector3(2.9, 0.22, 0.13), _dark_material)
	var a := _fixed.get_node("ReceiverA") as Node3D
	_box(a, "ContactLeft", Vector3(-0.62, 0.47, -1.2), Vector3(0.2, 0.75, 0.25), _repair_material)
	_box(a, "ContactRight", Vector3(0.62, 0.47, -1.2), Vector3(0.2, 0.75, 0.25), _repair_material)
	_box(a, "Conduit", Vector3(0, 1.55, -1.35), Vector3(0.17, 0.17, 1.45), _dark_material)
	var lamp_panel := _box(a, "FixedLampPanel", Vector3(0, 1.7, -1.95), Vector3(1.2, 0.85, 0.18), _fixed_material)
	_lamp_lens = _box(lamp_panel, "LampLens", Vector3(0, 0, 0.12), Vector3(0.62, 0.37, 0.06), _lamp_off_material)
	_lamp_light = OmniLight3D.new()
	_lamp_light.name = "LampLight"
	lamp_panel.add_child(_lamp_light)
	_lamp_light.position = Vector3(0, 0, 0.28)
	_lamp_light.omni_range = 3.5
	_lamp_light.light_energy = 1.2
	var b := _fixed.get_node("ReceiverB") as Node3D
	_box(b, "BlankRearMount", Vector3(0, 1.0, -1.5), Vector3(1.2, 1.8, 0.18), _fixed_material)
	_box(b, "MountScar", Vector3(0.25, 1.25, -1.38), Vector3(0.55, 0.14, 0.1), _repair_material)


func _build_module() -> void:
	module = Node3D.new()
	module.name = "PersistentModule"
	add_child(module)
	module.position = RECEIVER_POSITIONS[0]
	_box(module, "Body", Vector3(0, 0.68, 0), Vector3(2.0, 1.22, 1.25), _shell_material, true)
	_box(module, "TopServiceRail", Vector3(0, 1.38, -0.2), Vector3(1.85, 0.18, 0.3), _dark_material)
	_box(module, "IntegratedRepair", Vector3(-0.65, 0.72, 0.665), Vector3(0.23, 1.12, 0.12), _repair_material)
	_box(module, "RepairFoot", Vector3(-0.65, 0.18, 0.52), Vector3(0.7, 0.12, 0.35), _repair_material)
	_box(module, "RepairCrossbar", Vector3(-0.65, 0.95, 0.75), Vector3(0.56, 0.13, 0.07), _dark_material)
	_box(module, "AttachedContactLeft", Vector3(-0.62, 0.47, -0.85), Vector3(0.16, 0.24, 0.45), _repair_material)
	_box(module, "AttachedContactRight", Vector3(0.62, 0.47, -0.85), Vector3(0.16, 0.24, 0.45), _repair_material)
	setting = SETTING_SCRIPT.new() as StatePersistenceSetting
	setting.name = "AttachedSetting"
	module.add_child(setting)
	setting.position = Vector3(0.43, 0.78, 0.82)
	setting.condition_changed.connect(_update_fixed_output)
	var probes := Node3D.new()
	probes.name = "VisibilityProbes"
	module.add_child(probes)
	for index in range(5):
		var probe := Marker3D.new()
		probe.name = "Probe%d" % index
		probes.add_child(probe)
		match index:
			0: probe.position = Vector3(-0.65, 0.72, 0.74)
			1: probe.position = Vector3(0.43, 0.78, 1.02)
			2: probe.position = Vector3(0, 1.48, -0.2)
			3: probe.position = Vector3(-0.9, 0.6, -0.45)
			4: probe.position = Vector3(0.9, 0.6, -0.45)


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.85
	return material


func _box(
	parent: Node3D,
	box_name: String,
	box_position: Vector3,
	size: Vector3,
	material: Material,
	solid: bool = false
) -> MeshInstance3D:
	var node: Node3D = StaticBody3D.new() if solid else Node3D.new()
	node.name = box_name
	parent.add_child(node)
	node.position = box_position
	var mesh := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	box_mesh.material = material
	mesh.mesh = box_mesh
	node.add_child(mesh)
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		node.add_child(collision)
	return mesh
