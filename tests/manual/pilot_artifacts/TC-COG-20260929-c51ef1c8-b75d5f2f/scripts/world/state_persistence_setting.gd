class_name StatePersistenceSetting
extends Interactable

signal condition_changed(is_on: bool)

var condition_on := true
var _lever_pivot: Node3D


func _ready() -> void:
	interaction_label = "ADJUST"
	var housing := StaticBody3D.new()
	housing.name = "ControlHousing"
	add_child(housing)
	var shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(0.48, 0.48, 0.28)
	shape.shape = box_shape
	housing.add_child(shape)
	var housing_mesh := MeshInstance3D.new()
	var housing_box := BoxMesh.new()
	housing_box.size = box_shape.size
	housing_box.material = _material(Color(0.22, 0.25, 0.26))
	housing_mesh.mesh = housing_box
	housing.add_child(housing_mesh)
	_lever_pivot = Node3D.new()
	_lever_pivot.name = "LeverPivot"
	_lever_pivot.position = Vector3(0, 0, 0.18)
	add_child(_lever_pivot)
	var lever := MeshInstance3D.new()
	lever.name = "Lever"
	lever.position = Vector3(0, 0.32, 0)
	var lever_box := BoxMesh.new()
	lever_box.size = Vector3(0.12, 0.68, 0.12)
	lever_box.material = _material(Color(0.56, 0.55, 0.49))
	lever.mesh = lever_box
	_lever_pivot.add_child(lever)
	_update_visual()


func interact() -> void:
	set_condition_on(not condition_on)


func set_condition_on(value: bool) -> void:
	if value == condition_on:
		return
	condition_on = value
	_update_visual()
	condition_changed.emit(condition_on)


func _update_visual() -> void:
	if _lever_pivot != null:
		_lever_pivot.rotation.z = -0.55 if condition_on else 0.55


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.85
	return material
