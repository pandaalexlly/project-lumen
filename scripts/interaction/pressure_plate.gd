class_name PressurePlate
extends Area3D

signal activated
signal deactivated

@export_node_path("Node3D") var target_path: NodePath
@export var inactive_material: Material
@export var active_material: Material

var is_active: bool:
	get:
		return _is_active

var _is_active: bool = false

@onready var _target: Node3D = get_node_or_null(target_path) as Node3D
@onready var _surface: MeshInstance3D = $MeshInstance3D
@onready var _detection_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	_surface.material_override = inactive_material


func _physics_process(_delta: float) -> void:
	var occupied: bool = false
	if is_instance_valid(_target):
		# Query locally so teleported StaticBody3D children are detected even when
		# the physics backend omits static bodies from Area3D overlap lists.
		var query := PhysicsShapeQueryParameters3D.new()
		query.shape = _detection_shape.shape
		query.transform = _detection_shape.global_transform
		query.collision_mask = collision_mask
		for hit in get_world_3d().direct_space_state.intersect_shape(query):
			var body := hit["collider"] as Node
			if body == _target or _target.is_ancestor_of(body):
				occupied = true
				break
	if occupied == _is_active:
		return
	_is_active = occupied
	_surface.material_override = active_material if _is_active else inactive_material
	if _is_active:
		activated.emit()
	else:
		deactivated.emit()
