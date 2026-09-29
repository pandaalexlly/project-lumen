class_name PlayerController
extends CharacterBody3D

@export var movement_speed: float = 5.0
@export var mouse_sensitivity: float = 0.1

@onready var head: Node3D = $Head

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotation.x = clampf(
			head.rotation.x + deg_to_rad(-event.relative.y * mouse_sensitivity),
			-deg_to_rad(89.0),
			deg_to_rad(89.0)
		)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	var movement_direction := (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()

	velocity.x = movement_direction.x * movement_speed
	velocity.z = movement_direction.z * movement_speed
	move_and_slide()
