class_name CameraObservationShroud
extends Interactable

signal sightline_changed(is_blocked: bool)

var is_blocked := false
var _panel_body: StaticBody3D


func _ready() -> void:
	interaction_label = "MOVE COVER"
	_panel_body = StaticBody3D.new()
	_panel_body.name = "OpaquePanel"
	add_child(_panel_body)
	_panel_body.position = Vector3(0.5, 0, 0)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.9, 0.9, 0.12)
	collision.shape = shape
	_panel_body.add_child(collision)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = shape.size
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.29, 0.32, 0.33)
	material.roughness = 0.9
	box.material = material
	mesh.mesh = box
	_panel_body.add_child(mesh)
	_update_position()


func interact() -> void:
	is_blocked = not is_blocked
	_update_position()
	sightline_changed.emit(is_blocked)


func _update_position() -> void:
	rotation.y = 0.0 if is_blocked else PI * 0.5
