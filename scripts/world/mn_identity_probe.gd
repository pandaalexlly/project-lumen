extends Node3D

signal rooms_exchanged(m_slot: int)

const ROOM_CENTERS := [Vector3(-5.5, 0.0, -1.0), Vector3(5.5, 0.0, -1.0)]
const ROOM_HALF_WIDTH := 3.1
const ROOM_HALF_DEPTH := 2.8
const PLAYER_CLEARANCE := 0.55

@export var unobserved_delay := 0.6
@export_range(0.0, 0.25, 0.01) var viewport_margin := 0.08

@onready var _manager: ObservationManager = $ObservationManager
@onready var _player: PlayerController = $Player

var room_m: Node3D
var room_n: Node3D
var m_slot_index := 0
var successful_exchange_count := 0

var _armed := false
var _unobserved_time := 0.0
var _shell_material: StandardMaterial3D
var _floor_material: StandardMaterial3D
var _repair_material: StandardMaterial3D
var _fixed_material: StandardMaterial3D
var _dark_material: StandardMaterial3D


func _ready() -> void:
	_shell_material = _material(Color(0.43, 0.45, 0.45))
	_floor_material = _material(Color(0.27, 0.29, 0.30))
	_repair_material = _material(Color(0.58, 0.55, 0.49))
	_fixed_material = _material(Color(0.32, 0.36, 0.38))
	_dark_material = _material(Color(0.16, 0.19, 0.21))
	_build_fixed_world()
	room_m = _build_room("RoomM", true)
	room_n = _build_room("RoomN", false)
	room_m.position = ROOM_CENTERS[0]
	room_n.position = ROOM_CENTERS[1]


func _physics_process(delta: float) -> void:
	if room_m == null or room_n == null:
		return
	if _room_visible(room_m) or _room_visible(room_n):
		_armed = true
		_unobserved_time = 0.0
		return
	if not _armed or _player_overlaps_room(room_m) or _player_overlaps_room(room_n):
		_unobserved_time = 0.0
		return
	_unobserved_time += delta
	if _unobserved_time < unobserved_delay:
		return
	# Both complete shells move together. Fixed beds, landmarks, and ground never move.
	if _room_visible(room_m) or _room_visible(room_n):
		_unobserved_time = 0.0
		return
	var old_m_transform := room_m.global_transform
	room_m.global_transform = room_n.global_transform
	room_n.global_transform = old_m_transform
	m_slot_index = 1 - m_slot_index
	successful_exchange_count += 1
	_armed = false
	_unobserved_time = 0.0
	rooms_exchanged.emit(m_slot_index)


func _room_visible(room: Node3D) -> bool:
	for probe_node in room.get_node("VisibilityProbes").get_children():
		var probe := probe_node as Node3D
		if probe != null and _manager.is_target_position_directly_visible_with_margin(
			room, probe.global_position, viewport_margin
		):
			return true
	return false


func _player_overlaps_room(room: Node3D) -> bool:
	var local_position := room.to_local(_player.global_position)
	return (
		absf(local_position.x) < ROOM_HALF_WIDTH + PLAYER_CLEARANCE
		and absf(local_position.z) < ROOM_HALF_DEPTH + PLAYER_CLEARANCE
	)


func _build_fixed_world() -> void:
	var fixed := Node3D.new()
	fixed.name = "FixedWorld"
	add_child(fixed)
	_box(fixed, "Ground", Vector3(0, -0.18, -1), Vector3(27, 0.36, 24), _fixed_material, true)
	_box(fixed, "AtriumSpine", Vector3(0, 0.035, 7), Vector3(21, 0.07, 4), _floor_material)
	_box(fixed, "LeftInspectionApron", Vector3(-5.5, 0.04, 4.25), Vector3(5.4, 0.08, 3.0), _floor_material)
	_box(fixed, "RightInspectionApron", Vector3(5.5, 0.04, 4.25), Vector3(5.4, 0.08, 3.0), _floor_material)
	_box(fixed, "CentralPlant", Vector3(0, 0.9, 5.2), Vector3(1.2, 1.8, 1.2), _fixed_material, true)
	_box(fixed, "PlantCap", Vector3(0, 1.87, 5.2), Vector3(1.7, 0.14, 1.7), _repair_material)
	_box(fixed, "SharedConduit", Vector3(0, 3.65, 2.45), Vector3(18.7, 0.18, 0.18), _dark_material)
	for slot in range(2):
		var center: Vector3 = ROOM_CENTERS[slot]
		var receiver := Node3D.new()
		receiver.name = "ReceiverA" if slot == 0 else "ReceiverB"
		fixed.add_child(receiver)
		receiver.position = center
		_box(receiver, "FrontSill", Vector3(0, 0.055, 3.0), Vector3(6.7, 0.11, 0.20), _dark_material)
		_box(receiver, "LeftBedEdge", Vector3(-3.33, 0.055, 0), Vector3(0.12, 0.11, 5.9), _dark_material)
		_box(receiver, "RightBedEdge", Vector3(3.33, 0.055, 0), Vector3(0.12, 0.11, 5.9), _dark_material)
		_box(receiver, "RearBedEdge", Vector3(0, 0.055, -3.0), Vector3(6.7, 0.11, 0.12), _dark_material)
		_box(receiver, "FrontPostLeft", Vector3(-3.55, 1.55, 3.0), Vector3(0.35, 3.1, 0.35), _fixed_material, true)
		_box(receiver, "FrontPostRight", Vector3(3.55, 1.55, 3.0), Vector3(0.35, 3.1, 0.35), _fixed_material, true)
	# These landmarks belong to the receivers, not to either room shell.
	_box(fixed, "AServiceRib", Vector3(-9.55, 1.7, -1), Vector3(0.38, 3.4, 4.8), _fixed_material, true)
	_box(fixed, "ARibRepair", Vector3(-9.55, 1.45, -0.2), Vector3(0.46, 0.26, 0.8), _repair_material)
	_box(fixed, "BServiceStack", Vector3(9.65, 1.25, -1.5), Vector3(0.8, 2.5, 0.8), _fixed_material, true)
	_box(fixed, "BStackCap", Vector3(9.65, 2.58, -1.5), Vector3(1.05, 0.16, 1.05), _repair_material)
	# The same rear opening meets a fixed service run at A and a blank recess at B.
	_box(fixed, "ARearServiceFloor", Vector3(-5.5, 0.055, -5.5), Vector3(2.1, 0.11, 3.0), _floor_material)
	_box(fixed, "ARearServiceEnd", Vector3(-5.5, 1.35, -7.0), Vector3(2.1, 2.7, 0.18), _fixed_material, true)
	_box(fixed, "BRearBlindFace", Vector3(5.5, 1.35, -4.7), Vector3(2.1, 2.7, 0.18), _fixed_material, true)
	_box(fixed, "BBlindBrace", Vector3(5.5, 1.5, -4.58), Vector3(1.45, 0.22, 0.22), _repair_material)


func _build_room(room_name: String, is_m: bool) -> Node3D:
	var room := Node3D.new()
	room.name = room_name
	add_child(room)
	_box(room, "Floor", Vector3(0, 0.055, 0), Vector3(6.2, 0.11, 5.6), _floor_material, true)
	_box(room, "LeftWall", Vector3(-ROOM_HALF_WIDTH, 1.5, 0), Vector3(0.18, 3.0, 5.6), _shell_material, true)
	_box(room, "RightWall", Vector3(ROOM_HALF_WIDTH, 1.5, 0), Vector3(0.18, 3.0, 5.6), _shell_material, true)
	_box(room, "FrontLeft", Vector3(-2.45, 1.5, ROOM_HALF_DEPTH), Vector3(1.3, 3.0, 0.18), _shell_material, true)
	_box(room, "FrontRight", Vector3(2.45, 1.5, ROOM_HALF_DEPTH), Vector3(1.3, 3.0, 0.18), _shell_material, true)
	_box(room, "FrontLintel", Vector3(0, 2.85, ROOM_HALF_DEPTH), Vector3(3.6, 0.3, 0.18), _shell_material, true)
	_box(room, "LeftInnerRib", Vector3(-1.8, 0.11, -1.15), Vector3(0.28, 0.22, 2.1), _repair_material)
	_box(room, "RightInnerRib", Vector3(1.8, 0.11, -1.15), Vector3(0.28, 0.22, 2.1), _repair_material)
	if is_m:
		# A tall load-bearing splice reads from the shared overlook; the rear
		# doorway and small footing plates confirm the same shell closer in.
		_box(room, "FrontVerticalSplice", Vector3(2.45, 1.5, 2.94), Vector3(0.36, 2.88, 0.12), _repair_material)
		_box(room, "FrontSpliceFoot", Vector3(2.45, 0.13, 2.58), Vector3(0.84, 0.16, 0.58), _repair_material)
		_box(room, "FrontSpliceFastenerLow", Vector3(2.45, 0.4, 3.025), Vector3(0.16, 0.16, 0.05), _dark_material)
		_box(room, "FrontSpliceFastenerHigh", Vector3(2.45, 2.35, 3.025), Vector3(0.16, 0.16, 0.05), _dark_material)
		_box(room, "RearLeft", Vector3(-2.05, 1.5, -ROOM_HALF_DEPTH), Vector3(2.1, 3.0, 0.18), _shell_material, true)
		_box(room, "RearRight", Vector3(2.05, 1.5, -ROOM_HALF_DEPTH), Vector3(2.1, 3.0, 0.18), _shell_material, true)
		_box(room, "RearDoorLintel", Vector3(0, 2.75, -ROOM_HALF_DEPTH), Vector3(2.0, 0.5, 0.18), _shell_material, true)
		_box(room, "DoorHinge", Vector3(1.0, 1.2, -2.67), Vector3(0.14, 2.4, 0.14), _dark_material)
		_box(room, "DoorLeafOpen", Vector3(1.45, 1.2, -2.05), Vector3(0.12, 2.35, 1.05), _repair_material)
		_box(room, "IntegratedVerticalRepair", Vector3(-1.08, 1.48, -2.66), Vector3(0.16, 2.4, 0.18), _repair_material)
		_box(room, "RepairCrosspiece", Vector3(-1.08, 1.85, -2.55), Vector3(0.62, 0.13, 0.16), _dark_material)
	else:
		# The sister shell has a broad lintel reinforcement instead of the
		# vertical splice, with a smaller repaired floor joint for close study.
		_box(room, "FrontHorizontalReinforcement", Vector3(0, 2.86, 2.94), Vector3(3.3, 0.36, 0.12), _repair_material)
		_box(room, "FrontReinforcementReturn", Vector3(-1.6, 2.48, 2.94), Vector3(0.18, 0.7, 0.12), _repair_material)
		_box(room, "FrontFloorJointPatch", Vector3(-1.35, 0.13, 1.83), Vector3(1.3, 0.16, 0.48), _repair_material)
		_box(room, "FrontFloorJointClamp", Vector3(-1.35, 0.22, 1.83), Vector3(0.16, 0.05, 0.52), _dark_material)
		_box(room, "SolidRearFace", Vector3(0, 1.5, -ROOM_HALF_DEPTH), Vector3(6.2, 3.0, 0.18), _shell_material, true)
		_box(room, "IntegratedWoundLow", Vector3(0.4, 0.75, -2.66), Vector3(1.15, 0.17, 0.18), _dark_material)
		_box(room, "IntegratedWoundHigh", Vector3(0.9, 1.6, -2.66), Vector3(0.17, 1.75, 0.18), _dark_material)
		_box(room, "WoundBrace", Vector3(1.18, 2.2, -2.55), Vector3(0.65, 0.17, 0.2), _repair_material)
	var probes := Node3D.new()
	probes.name = "VisibilityProbes"
	room.add_child(probes)
	for index in range(5):
		var probe := Marker3D.new()
		probe.name = "Probe%d" % index
		probes.add_child(probe)
		match index:
			0: probe.position = Vector3(-2.45, 1.55, 2.86)
			1: probe.position = Vector3(2.45, 1.55, 2.86)
			2: probe.position = Vector3(0, 0.16, 1.5)
			3: probe.position = Vector3(-1.0, 1.5, -2.6)
			4: probe.position = Vector3(1.0, 1.5, -2.6)
	return room


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material


func _box(
	parent: Node3D,
	box_name: String,
	box_position: Vector3,
	size: Vector3,
	material: Material,
	solid: bool = false
) -> void:
	var node: Node3D
	if solid:
		node = StaticBody3D.new()
	else:
		node = Node3D.new()
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
