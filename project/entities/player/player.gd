class_name Player
extends CharacterBody3D


const SPEED = 6.0
const JUMP_VELOCITY = 7.0
const COYOTE_TIME = 0.2 	# BUG: wenn man schnell jump drückt kann man double jump machen


@export var max_jumps: int = 2


var movement_force: float = 0.09 # Kraft der aktuellen input eingebe

var on_floor: bool = true
var coyote_timer: float = 0.0

var jumps: int = 0

@onready var rotatable_objects: Node3D = %RotatableObjects


func _physics_process(delta: float) -> void:
	# Add the gravity. and coyote time
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer += delta
		if coyote_timer >= COYOTE_TIME:
			on_floor = false
			coyote_timer = 0.0
	else:
		on_floor = true
		jumps = max_jumps

	# Handle jump. and double jump
	if Input.is_action_just_pressed("jump") and (on_floor or jumps > 0):
		if jumps == max_jumps and not on_floor:
			jumps -= 1
		velocity.y = JUMP_VELOCITY
		jumps -= 1
	

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var wish_dir: Vector2
		wish_dir.x = direction.x * SPEED
		wish_dir.y = direction.z * SPEED
		
		velocity.x = velocity.x * (1.0 - movement_force) + wish_dir.x * movement_force
		velocity.z = velocity.z * (1.0 - movement_force) + wish_dir.y * movement_force
		
		# Rotate mesh to face movement direction
		rotatable_objects.rotation.y = atan2(direction.x, direction.z) + PI
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)
		velocity.z = move_toward(velocity.z, 0, SPEED * 0.1)

	move_and_slide()
