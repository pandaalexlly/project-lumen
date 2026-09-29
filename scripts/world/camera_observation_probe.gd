extends "res://scripts/world/state_persistence_probe.gd"

const SHROUD_SCRIPT := preload("res://scripts/world/camera_observation_shroud.gd")

var lens_camera: Camera3D
var shroud: Interactable
var camera_powered := true
var _camera_rig: Node3D


func _ready() -> void:
	super._ready()
	_build_camera_station()


func _current_visible() -> bool:
	return super._current_visible() or _camera_sees_current()


func _candidate_visible(slot: int) -> bool:
	return super._candidate_visible(slot) or _camera_sees_candidate(slot)


func _camera_sees_current() -> bool:
	if lens_camera == null:
		return false
	for probe_node in module.get_node("VisibilityProbes").get_children():
		var probe := probe_node as Node3D
		if probe != null and _lens_sees_position(probe.global_position, false):
			return true
	return false


func _camera_sees_candidate(slot: int) -> bool:
	if lens_camera == null:
		return false
	var placement := Transform3D(Basis.IDENTITY, RECEIVER_POSITIONS[slot])
	for probe_node in module.get_node("VisibilityProbes").get_children():
		var probe := probe_node as Node3D
		if probe == null:
			continue
		var candidate_position: Vector3 = placement * module.to_local(probe.global_position)
		if _lens_sees_position(candidate_position, true):
			return true
	return false


func _lens_sees_position(world_position: Vector3, candidate: bool) -> bool:
	if not camera_powered or not lens_camera.is_position_in_frustum(world_position):
		return false
	var query := PhysicsRayQueryParameters3D.create(lens_camera.global_position, world_position)
	if candidate:
		var exclusions: Array[RID] = []
		_collect_collision_rids(module, exclusions)
		query.exclude = exclusions
	var hit := lens_camera.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return true
	var collider := hit.get("collider") as Node
	return not candidate and collider != null and module.is_ancestor_of(collider)


func _collect_collision_rids(node: Node, results: Array[RID]) -> void:
	if node is CollisionObject3D:
		results.append((node as CollisionObject3D).get_rid())
	for child in node.get_children():
		_collect_collision_rids(child, results)


func _build_camera_station() -> void:
	var camera_material := _material(Color(0.36, 0.39, 0.40))
	var lens_material := _material(Color(0.11, 0.15, 0.17))
	var power_material := _material(Color(0.46, 0.57, 0.46))
	power_material.emission_enabled = true
	power_material.emission = Color(0.16, 0.26, 0.16)
	power_material.emission_energy_multiplier = 0.7
	_box(_fixed, "CameraPost", Vector3(-7.0, 1.2, 0.9), Vector3(0.18, 2.4, 0.18), camera_material)
	_box(_fixed, "CameraCable", Vector3(-7.0, 0.04, 2.2), Vector3(0.07, 0.07, 2.6), lens_material)
	_camera_rig = Node3D.new()
	_camera_rig.name = "PoweredSecurityCamera"
	_fixed.add_child(_camera_rig)
	_camera_rig.position = Vector3(-7.0, 2.4, 0.9)
	_camera_rig.look_at(RECEIVER_POSITIONS[0] + Vector3(-0.65, 0.72, 0.74))
	_box(_camera_rig, "Housing", Vector3(0, 0, 0.12), Vector3(0.6, 0.43, 0.88), camera_material)
	_box(_camera_rig, "Lens", Vector3(0, 0, -0.35), Vector3(0.32, 0.27, 0.06), lens_material)
	_box(_camera_rig, "PowerPin", Vector3(0.23, 0.16, 0.44), Vector3(0.08, 0.08, 0.08), power_material)
	lens_camera = Camera3D.new()
	lens_camera.name = "LiveLens"
	lens_camera.fov = 28.0
	lens_camera.current = false
	_camera_rig.add_child(lens_camera)
	lens_camera.position = Vector3(0, 0, -0.41)
	shroud = SHROUD_SCRIPT.new() as Interactable
	shroud.name = "MaintenanceShroud"
	_camera_rig.add_child(shroud)
	shroud.position = Vector3(-0.5, 0, -0.68)
