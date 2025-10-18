class_name Player
extends CharacterBody3D


const SPEED = 6.0
const JUMP_VELOCITY = 7.5
const COYOTE_TIME = 0.2 	# BUG: wenn man schnell jump drückt kann man double jump machen
const BOUNCE_IMPULSE = 7.0
const FULL_JUMP_TIME: float = 0.2


@export var max_jumps: int = 1
@export var health: int = 3


var movement_force: float = 0.09 # Kraft der aktuellen input eingebe

var on_floor: bool = true
var coyote_timer: float = 0.0

var jumps: int = 0
var jump_held_time: float = 0.0
var jumping: bool = false
var in_air_last_frame: bool = false


@onready var rotatable_objects: Node3D = %RotatableObjects
@onready var animation_player: AnimationPlayer = $RotatableObjects/schleim/AnimationPlayer


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
		# catch case when player falls off a ledge and still has 2 jumps left
		if jumps == max_jumps and not on_floor:
			jumps -= 1
		#velocity.y = JUMP_VELOCITY
		jumps -= 1
		jump_held_time = 0.0
		jumping = true
	
	if Input.is_action_pressed("jump") and jump_held_time < FULL_JUMP_TIME and jumping:
		jump_held_time += delta
		self.velocity.y = JUMP_VELOCITY
		animation_player.play("jump start")
	
	if velocity.length() > 0.1 and is_on_floor() and animation_player.current_animation != "stone_smash":
		animation_player.play("walk")
	
	if in_air_last_frame and is_on_floor():
		animation_player.play("jump leer")
	
	in_air_last_frame = not is_on_floor()
	
	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		self.velocity.y *= 0.5
		jumping = false
	
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
	
	# squash jens
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().has_method("squash"):
			var squashable = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				squashable.squash(20)
				velocity.y = BOUNCE_IMPULSE
				break


func take_damage(_amount: int) -> void:
	health -= 1
	Globals.damage_taken.emit()
	if health <= 0:
		Globals.player_died.emit()


func switch_mask() -> void:
	pass
