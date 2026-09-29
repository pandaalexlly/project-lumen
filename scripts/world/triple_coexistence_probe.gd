extends Node3D

# Static, isolated sightline experiment. Names and markers are developer-only;
# the visible geometry carries no labels or instructions.
const STACK_CENTERS := {
	"H0": Vector3(0, 0, 0),
	"H1": Vector3(-18, 0, -8),
	"H2": Vector3(18, 0, -8),
}

var _shell: StandardMaterial3D
var _floor: StandardMaterial3D
var _recess: StandardMaterial3D
var _repair: StandardMaterial3D


func _ready() -> void:
	_shell = _material(Color(0.49, 0.51, 0.52))
	_floor = _material(Color(0.34, 0.36, 0.37))
	_recess = _material(Color(0.19, 0.22, 0.24))
	_repair = _material(Color(0.68, 0.65, 0.58))
	var world_environment := WorldEnvironment.new()
	world_environment.name = "NeutralEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.08, 0.10, 0.12)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.63, 0.67, 0.70)
	environment.ambient_light_energy = 0.8
	world_environment.environment = environment
	add_child(world_environment)
	var facilities := Node3D.new()
	facilities.name = "FixedFacilities"
	add_child(facilities)
	for stack_name in ["H0", "H1", "H2"]:
		_build_stack(facilities, stack_name)
	_build_h0_access()
	_build_viewpoint_markers()


func _build_stack(parent: Node3D, stack_name: String) -> void:
	var stack := Node3D.new()
	stack.name = stack_name
	parent.add_child(stack)
	stack.position = STACK_CENTERS[stack_name]
	var atrium := Node3D.new()
	atrium.name = "Atrium"
	stack.add_child(atrium)
	_box(atrium, "Floor", Vector3(0, -0.16, 0), Vector3(10.4, 0.32, 8), _floor, true)
	_box(atrium, "RearWall", Vector3(0, 2.6, -4), Vector3(10.4, 5.2, 0.35), _shell, true)
	_box(atrium, "LeftWall", Vector3(-5.2, 2.6, 0), Vector3(0.35, 5.2, 8), _shell, true)
	_box(atrium, "RightWall", Vector3(5.2, 2.6, 0), Vector3(0.35, 5.2, 8), _shell, true)
	_box(atrium, "FrontLeftPier", Vector3(-4.55, 2.6, 4), Vector3(1.3, 5.2, 0.55), _shell, true)
	_box(atrium, "FrontRightPier", Vector3(4.55, 2.6, 4), Vector3(1.3, 5.2, 0.55), _shell, true)
	_box(atrium, "FrontLintel", Vector3(0, 4.85, 4), Vector3(7.8, 0.7, 0.55), _shell, true)
	_box(atrium, "Recess", Vector3(0, 2.4, -3.78), Vector3(5.6, 3.7, 0.05), _recess)
	var qer := Node3D.new()
	qer.name = "QER"
	stack.add_child(qer)
	_box(qer, "Floor", Vector3(0, 6.15, 0.8), Vector3(8.2, 0.3, 8), _floor, true)
	_box(qer, "RearWall", Vector3(0, 8.55, -3.2), Vector3(8.2, 4.5, 0.35), _shell, true)
	_box(qer, "LeftPier", Vector3(-3.85, 8.55, 4.8), Vector3(0.5, 4.5, 0.5), _shell, true)
	_box(qer, "RightPier", Vector3(3.85, 8.55, 4.8), Vector3(0.5, 4.5, 0.5), _shell, true)
	_box(qer, "Roof", Vector3(0, 10.95, 0.8), Vector3(8.2, 0.3, 8), _shell, true)
	_box(qer, "RearApparatus", Vector3(0, 8.35, -2.91), Vector3(3.0, 2.5, 0.12), _recess)
	var awakening := Node3D.new()
	awakening.name = "Awakening"
	stack.add_child(awakening)
	_box(awakening, "Floor", Vector3(0, -8.15, 1.8), Vector3(8.2, 0.3, 10.4), _floor, true)
	_box(awakening, "RearWall", Vector3(0, -5.6, -3.2), Vector3(8.2, 5.0, 0.35), _shell, true)
	_box(awakening, "LeftPier", Vector3(-3.85, -5.6, 7), Vector3(0.5, 5.0, 0.5), _shell, true)
	_box(awakening, "RightPier", Vector3(3.85, -5.6, 7), Vector3(0.5, 5.0, 0.5), _shell, true)
	_box(awakening, "RearServiceBay", Vector3(0, -5.6, -2.91), Vector3(3.0, 3.0, 0.12), _recess)
	# The continuous side rib makes the three levels read as one fixed stack.
	_box(stack, "WestStackRib", Vector3(-4.72, 1.4, -3.78), Vector3(0.42, 20.0, 0.42), _recess, true)
	_box(stack, "EastStackRib", Vector3(4.72, 1.4, -3.78), Vector3(0.42, 20.0, 0.42), _recess, true)
	var identity := Node3D.new()
	identity.name = "IdentityCue"
	stack.add_child(identity)
	match stack_name:
		"H0":
			# Paired narrow repairs recur on the three fixed levels.
			for height in [-5.65, 2.4, 8.45]:
				_box(identity, "TwinSeamLeft%d" % int(height * 10), Vector3(-0.55, height, 4.32 if height > 0 else 7.32), Vector3(0.28, 2.3, 0.13), _repair)
				_box(identity, "TwinSeamRight%d" % int(height * 10), Vector3(0.55, height, 4.32 if height > 0 else 7.32), Vector3(0.28, 2.3, 0.13), _repair)
		"H1":
			for height in [-5.65, 2.4, 8.45]:
				var brace := _box(identity, "SlantedSplice%d" % int(height * 10), Vector3(2.0, height, 4.32 if height > 0 else 7.32), Vector3(0.42, 3.0, 0.14), _repair)
				brace.rotation.z = -0.48
		"H2":
			for height in [-5.65, 2.4, 8.45]:
				_box(identity, "OffsetPost%d" % int(height * 10), Vector3(-2.0, height, 4.32 if height > 0 else 7.32), Vector3(0.75, 2.6, 0.16), _repair)
				_box(identity, "PostCap%d" % int(height * 10), Vector3(-1.65, height + 1.3, 4.32 if height > 0 else 7.32), Vector3(1.45, 0.28, 0.18), _repair)
	var targets := Node3D.new()
	targets.name = "ProofTargets"
	stack.add_child(targets)
	var cue_x := 0.0
	if stack_name == "H1":
		cue_x = 2.0
	elif stack_name == "H2":
		cue_x = -2.0
	_marker(targets, "Identity", Vector3(cue_x, 3.5, 4.7))
	_marker(targets, "QER", Vector3(0, 8.5, 5.2))
	_marker(targets, "Awakening", Vector3(0, -5.5, 7.5))


func _build_h0_access() -> void:
	var access := Node3D.new()
	access.name = "H0Access"
	add_child(access)
	_box(access, "GroundServiceRun", Vector3(-4, -0.15, 14.5), Vector3(2.4, 0.3, 21), _floor, true)
	_box(access, "GroundBypass", Vector3(-7, -0.15, 15), Vector3(2.4, 0.3, 20), _floor, true)
	_box(access, "RampFootCrossing", Vector3(-5.5, -0.15, 24), Vector3(3.0, 0.3, 2.0), _floor, true)
	var ramp := _box(access, "GalleryRamp", Vector3(-4, 1.35, 18), Vector3(2.4, 0.3, 10.45), _floor, true)
	ramp.rotation.x = 0.291
	_box(access, "InternalGallery", Vector3(-4, 2.85, 12.2), Vector3(3.0, 0.3, 1.6), _floor, true)
	# An open H0-attached architectural frame, not a screen or window image.
	for x in [-9.0, 7.0]:
		_box(access, "GalleryPost%d" % int(x), Vector3(x, 5.2, 14.5), Vector3(0.45, 10.4, 0.45), _shell, true)
	_box(access, "GalleryCrown", Vector3(-1, 10.4, 14.5), Vector3(16.4, 0.45, 0.45), _shell, true)
	_box(access, "GroundH0Crossing", Vector3(-2.25, -0.15, 5.5), Vector3(10.5, 0.3, 3.4), _floor, true)
	_box(access, "GroundEastRun", Vector3(3, -0.15, 16), Vector3(2.4, 0.3, 24), _floor, true)
	_box(access, "GroundCrosspiece", Vector3(7, -0.15, 28), Vector3(6, 0.3, 2.0), _floor, true)
	_box(access, "ExteriorApron", Vector3(13, -0.15, 28.5), Vector3(6, 0.3, 5), _floor, true)
	# The ground approach stays on H0's side of the void; it does not bridge stacks.


func _build_viewpoint_markers() -> void:
	var viewpoints := Node3D.new()
	viewpoints.name = "Viewpoints"
	add_child(viewpoints)
	_marker(viewpoints, "A_InternalGallery", Vector3(-3.5, 3.0, 11.9))
	_marker(viewpoints, "B_ExternalOblique", Vector3(12, 0.0, 28.0))


func _marker(parent: Node3D, marker_name: String, at: Vector3) -> void:
	var marker := Marker3D.new()
	marker.name = marker_name
	parent.add_child(marker)
	marker.position = at


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
