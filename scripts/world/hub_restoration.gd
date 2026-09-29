extends Node3D

@export var interlock_path: NodePath
@export var bulkhead_path: NodePath
@export var bulkhead_detail_paths: Array[NodePath] = []
@export var startup_delay: float = 0.8
@export var startup_duration: float = 2.4
@export var bulkhead_lift: float = 3.0
@export var restored_light_energy: float = 2.0

var services_online: bool = false
var _restored_fixture_materials: Array[StandardMaterial3D] = []


func _ready() -> void:
	for fixture in $RestoredFixtures.get_children():
		var material := fixture.get_active_material(0).duplicate() as StandardMaterial3D
		material.emission_energy_multiplier = 0.0
		fixture.material_override = material
		_restored_fixture_materials.append(material)
	if not bulkhead_path.is_empty():
		for detail_path in bulkhead_detail_paths:
			get_node(detail_path).reparent(get_node(bulkhead_path), true)
	if not interlock_path.is_empty():
		get_node(interlock_path).activated.connect(_restore_access)


func _restore_access() -> void:
	if services_online:
		return
	services_online = true
	# The player's powered release interaction opens the door permanently.
	# The opening stays open for safe traversal even if the load is later lost.
	var startup := create_tween().set_parallel(true)
	if not bulkhead_path.is_empty():
		var bulkhead := get_node(bulkhead_path) as Node3D
		startup.tween_property(bulkhead, "position:y", bulkhead.position.y + bulkhead_lift, startup_duration).set_delay(startup_delay)
	for light in $RestoredLights.get_children():
		startup.tween_property(light, "light_energy", restored_light_energy, startup_duration).set_delay(startup_delay)
	for material in _restored_fixture_materials:
		startup.tween_property(material, "emission_energy_multiplier", 0.65, startup_duration).set_delay(startup_delay)
