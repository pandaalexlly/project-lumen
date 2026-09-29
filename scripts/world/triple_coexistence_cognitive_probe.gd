extends Node3D

# Isolated visit-order scaffold. The three proof stacks are always present and
# never move; only the player is handed between fully enclosed test receivers.
const STACK_NAMES := ["H0", "H1", "H2"]
const STACK_CENTERS := {
	"H0": Vector3(0, 0, 0),
	"H1": Vector3(-18, 0, -8),
	"H2": Vector3(18, 0, -8),
}
const PLAYER_HEIGHT := 0.92
const CELL_X := 3.0
const CELL_TRIGGER_LOCAL := Vector3(0.8, 1.0, -2.55)
const ARRIVAL_LOCAL := Vector3(-CELL_X + 0.8, PLAYER_HEIGHT, -2.55)
const REVEAL_LOCAL := Vector3(0, PLAYER_HEIGHT, 3.15)

@onready var proof: Node3D = $Proof
@onready var player: CharacterBody3D = $Proof/Player

var visit_phase: int = 0
var handoff_count: int = 0
var _handoff_pending := false
var _shell_material: StandardMaterial3D
var _bay_material: StandardMaterial3D
var _repair_material: StandardMaterial3D


func _ready() -> void:
	_shell_material = _material(Color(0.47, 0.49, 0.50))
	_bay_material = _material(Color(0.31, 0.34, 0.35))
	_repair_material = _material(Color(0.68, 0.65, 0.58))
	var staging := Node3D.new()
	staging.name = "TestOnlyStaging"
	add_child(staging)
	for index in range(STACK_NAMES.size()):
		_build_visit_pocket(staging, STACK_NAMES[index], index)
	player.global_position = STACK_CENTERS["H0"] + Vector3(0, PLAYER_HEIGHT, 0)
	player.rotation.y = PI


func _build_visit_pocket(parent: Node3D, stack_name: String, source_phase: int) -> void:
	var pocket := Node3D.new()
	pocket.name = stack_name + "VisitPocket"
	pocket.position = STACK_CENTERS[stack_name]
	parent.add_child(pocket)
	# Behind the original facade: the final exterior proof geometry is untouched.
	_box(pocket, "FixedInteriorPartition", Vector3(0, 2.6, 2.25), Vector3(10.4, 5.2, 0.35), _shell_material, true)
	# A repeated load path joins the visited atrium to the fixed QER floor above.
	_box(pocket, "QERSupportColumn", Vector3(0, 3.0, -3.0), Vector3(0.38, 6.0, 0.38), _shell_material, true)
	_box(pocket, "QERFloorBracket", Vector3(0, 5.82, -3.0), Vector3(2.4, 0.24, 0.45), _bay_material, true)
	_build_inboard_repair(pocket, stack_name, 2.02)
	if stack_name == "H0":
		# The final return lands in the front pocket, facing this same repair history.
		_build_inboard_repair(pocket, stack_name, 2.48)
	_build_cell(pocket, "ArrivalReceiver", -CELL_X)
	_build_cell(pocket, "SourceReceiver", CELL_X)
	var transfer := Area3D.new()
	transfer.name = "OccludedHandoff"
	transfer.position = Vector3(CELL_X, 0, 0) + CELL_TRIGGER_LOCAL
	transfer.collision_layer = 0
	transfer.collision_mask = 1
	var shape_node := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.72, 2.0, 0.72)
	shape_node.shape = shape
	transfer.add_child(shape_node)
	pocket.add_child(transfer)
	transfer.body_entered.connect(_on_handoff_entered.bind(source_phase))


func _build_cell(parent: Node3D, cell_name: String, center_x: float) -> void:
	var cell := Node3D.new()
	cell.name = cell_name
	parent.add_child(cell)
	var at := Vector3(center_x, 0, 0)
	_box(cell, "WestWall", at + Vector3(-1.4, 1.45, -1.6), Vector3(0.28, 2.9, 4.2), _bay_material, true)
	_box(cell, "EastWall", at + Vector3(1.4, 1.45, -1.6), Vector3(0.28, 2.9, 4.2), _bay_material, true)
	_box(cell, "BackWall", at + Vector3(0, 1.45, -3.7), Vector3(2.8, 2.9, 0.28), _bay_material, true)
	# Opposed gaps make a short dogleg. The transfer point cannot look into the atrium.
	_box(cell, "FrontScreen", at + Vector3(0.6, 1.45, 0.5), Vector3(1.6, 2.9, 0.28), _bay_material, true)
	_box(cell, "InnerScreen", at + Vector3(-0.55, 1.45, -1.0), Vector3(1.7, 2.9, 0.28), _bay_material, true)
	_box(cell, "Roof", at + Vector3(0, 3.0, -1.6), Vector3(2.8, 0.22, 4.2), _bay_material, true)
	var arrival := Marker3D.new()
	arrival.name = "ArrivalFloor"
	arrival.position = at + Vector3(0.8, PLAYER_HEIGHT, -2.55)
	cell.add_child(arrival)


func _build_inboard_repair(parent: Node3D, stack_name: String, z_position: float) -> void:
	var repairs := Node3D.new()
	repairs.name = "InboardRepair" + ("Rear" if z_position < 2.25 else "Front")
	parent.add_child(repairs)
	match stack_name:
		"H0":
			_box(repairs, "TwinSeamLeft", Vector3(-0.55, 2.4, z_position), Vector3(0.28, 2.3, 0.10), _repair_material)
			_box(repairs, "TwinSeamRight", Vector3(0.55, 2.4, z_position), Vector3(0.28, 2.3, 0.10), _repair_material)
		"H1":
			var splice := _box(repairs, "SlantedSplice", Vector3(2.0, 2.4, z_position), Vector3(0.42, 3.0, 0.10), _repair_material)
			splice.rotation.z = -0.48
		"H2":
			_box(repairs, "OffsetPost", Vector3(-2.0, 2.4, z_position), Vector3(0.75, 2.6, 0.10), _repair_material)
			_box(repairs, "PostCap", Vector3(-1.65, 3.7, z_position), Vector3(1.45, 0.28, 0.10), _repair_material)


func _on_handoff_entered(body: Node3D, source_phase: int) -> void:
	if body != player or source_phase != visit_phase or _handoff_pending:
		return
	_handoff_pending = true
	_perform_handoff.call_deferred(source_phase)


func _perform_handoff(source_phase: int) -> void:
	if source_phase != visit_phase:
		_handoff_pending = false
		return
	visit_phase += 1
	handoff_count += 1
	player.velocity = Vector3.ZERO
	if visit_phase < STACK_NAMES.size():
		var destination: String = STACK_NAMES[visit_phase]
		player.global_position = STACK_CENTERS[destination] + ARRIVAL_LOCAL
	else:
		player.global_position = STACK_CENTERS["H0"] + REVEAL_LOCAL
	_handoff_pending = false
	print("COGNITIVE PROBE: handoff %d, phase %d" % [handoff_count, visit_phase])


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	return material


func _box(parent: Node3D, box_name: String, at: Vector3, size: Vector3, material: Material, solid := false) -> Node3D:
	var node: Node3D = StaticBody3D.new() if solid else Node3D.new()
	node.name = box_name
	parent.add_child(node)
	node.position = at
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
	return node
