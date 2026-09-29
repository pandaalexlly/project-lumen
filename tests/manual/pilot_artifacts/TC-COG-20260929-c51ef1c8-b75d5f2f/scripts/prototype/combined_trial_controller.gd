class_name CombinedTrialController
extends Node

@export_node_path("QuantumRelocator") var quantum_cube_path: NodePath
@export_node_path("Node3D") var start_destination_path: NodePath
@export_node_path("SimpleDoor") var exit_door_path: NodePath
@export_node_path("StabilizationBeam") var stabilization_beam_path: NodePath
@export_node_path("MeshInstance3D") var beam_emitter_face_path: NodePath
@export var beam_inactive_material: Material
@export var shutter_paths: Array[NodePath] = []
@export var shutter_closed_y: float = 1.6

var shutters_closed: bool = false
var failure_latched: bool = false
var recovery_count: int = 0

@onready var _quantum_cube: QuantumRelocator = (
	get_node_or_null(quantum_cube_path) as QuantumRelocator
)
@onready var _start_destination: Node3D = get_node_or_null(start_destination_path) as Node3D
@onready var _exit_door: SimpleDoor = get_node_or_null(exit_door_path) as SimpleDoor
@onready var _stabilization_beam: StabilizationBeam = (
	get_node_or_null(stabilization_beam_path) as StabilizationBeam
)
@onready var _beam_emitter_face: MeshInstance3D = (
	get_node_or_null(beam_emitter_face_path) as MeshInstance3D
)

var _shutters: Array[Node3D] = []
var _shutter_open_positions: Array[Vector3] = []


func _ready() -> void:
	for path in shutter_paths:
		var shutter := get_node_or_null(path) as Node3D
		if shutter == null:
			continue
		_shutters.append(shutter)
		_shutter_open_positions.append(shutter.position)
	if is_instance_valid(_stabilization_beam):
		_stabilization_beam.enabled_changed.connect(_on_beam_enabled_changed)
		call_deferred("_sync_beam_emitter")


func close_shutters() -> void:
	if not failure_latched:
		var telemetry := get_node_or_null("/root/PlaytestTelemetry")
		var scene_root := get_tree().current_scene
		if telemetry != null and scene_root != null:
			telemetry.call(
				"record_failed_attempt",
				scene_root.scene_file_path,
				"combined_failure_plate"
			)
	failure_latched = true
	shutters_closed = true
	for shutter in _shutters:
		shutter.position.y = shutter_closed_y


func recover_from_failure() -> void:
	if not failure_latched or not is_instance_valid(_quantum_cube):
		return

	_open_shutters()
	if is_instance_valid(_exit_door):
		_exit_door.close()
	_reset_cube_to_start()
	failure_latched = false
	recovery_count += 1


func _open_shutters() -> void:
	shutters_closed = false
	for index in _shutters.size():
		_shutters[index].position = _shutter_open_positions[index]


func _reset_cube_to_start() -> void:
	if not is_instance_valid(_start_destination):
		return

	_quantum_cube._move_timer.stop()
	_quantum_cube._clear_pending_destination()
	_quantum_cube.global_transform = _start_destination.global_transform
	_quantum_cube._current_destination_index = _quantum_cube.starting_destination_index
	_quantum_cube._previous_destination_index = -1
	_quantum_cube._successful_move_count = 0
	_quantum_cube._moved_this_unobserved_period = false
	_quantum_cube._directly_observed = false
	_quantum_cube._artificially_observed = false
	_quantum_cube._currently_observed = false
	_quantum_cube._has_observation_state = false


func _on_beam_enabled_changed(is_enabled: bool) -> void:
	if not is_instance_valid(_beam_emitter_face):
		return
	_beam_emitter_face.material_override = null if is_enabled else beam_inactive_material


func _sync_beam_emitter() -> void:
	if is_instance_valid(_stabilization_beam):
		_on_beam_enabled_changed(_stabilization_beam.enabled)
