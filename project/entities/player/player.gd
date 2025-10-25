class_name Player
extends CharacterBody3D


const SPEED = 6.0
const JUMP_VELOCITY = 7.5
const COYOTE_TIME = 0.2 	# BUG: wenn man schnell jump drückt kann man double jump machen
const BOUNCE_IMPULSE = 7.0
const FULL_JUMP_TIME: float = 0.2


@export var max_jumps: int = 1
@export var health: int = 3
@export var invincible_time: float = 0.5


var movement_force: float = 0.09 # Kraft der aktuellen input eingebe
var block_penalty: float = 0.4

var on_floor: bool = true
var coyote_timer: float = 0.0

var jumps: int = 0
var jump_held_time: float = 0.0
var jumping: bool = false
var in_air_last_frame: bool = false
var velocity_last_frame: Vector3 = Vector3.ZERO

var hittable: bool = true
var i_timer: float = 0.0
var damage_tween: Tween

var blocking: bool = true


@onready var rotatable_objects: Node3D = %RotatableObjects
@onready var animation_player: AnimationPlayer = $RotatableObjects/schleim/AnimationPlayer
@onready var mesh: MeshInstance3D = $RotatableObjects/schleim/Armature/Skeleton3D/Icosphere


func _ready() -> void:
	Globals.teleport_player_to.connect(teleport_player)
	Globals.play_credits.connect(play_credits)


func _process(delta: float) -> void:
	if not hittable:
		i_timer += delta
		
		if i_timer > invincible_time:
			hittable = true


func _physics_process(delta: float) -> void:
	max_jumps = 2 if Globals.current_mask == 3 else 1
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
	if Input.is_action_just_pressed("jump") and (on_floor or jumps > 0) and Globals.current_mask != 1:
		# catch case when player falls off a ledge and still has 2 jumps left
		if jumps == max_jumps and not on_floor:
			jumps -= 1
		#velocity.y = JUMP_VELOCITY
		jumps -= 1
		jump_held_time = 0.0
		jumping = true
	
	if Input.is_action_pressed("jump") and jump_held_time < FULL_JUMP_TIME and jumping and Globals.current_mask != 1:
		jump_held_time += delta
		self.velocity.y = JUMP_VELOCITY
		animation_player.play("jump start")
	
	if velocity.length() > 0.1 and is_on_floor() and animation_player.current_animation != "stone_smash" and animation_player.current_animation != "jump land":
		animation_player.play("walk")
	elif velocity.length() < 0.1 and is_on_floor() and animation_player.current_animation != "stone_smash" and animation_player.current_animation != "jump land":
		animation_player.play("idle")
	
	if in_air_last_frame and is_on_floor() and velocity_last_frame.y < -8.0:
		animation_player.play("jump land")
	
	in_air_last_frame = not is_on_floor()
	velocity_last_frame = self.velocity
	
	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		self.velocity.y *= 0.5
		jumping = false
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var wish_dir: Vector2 = Vector2(0.0, 0.0)
		wish_dir.x = direction.x * SPEED
		wish_dir.y = direction.z * SPEED
		
		if blocking:
			wish_dir *= block_penalty
		
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


func teleport_player(pos: Vector3) -> void:
	global_position = pos


func play_credits() -> void:
	get_tree().get_first_node_in_group("HUD").visible = false
	$AnimationPlayer.play("credits")


func end_game() -> void:
	get_tree().quit()


func take_damage(_amount: int, pos: Vector3 = Vector3.ZERO) -> void:
	if pos != Vector3.ZERO and blocking:
		var direction_to_target: Vector3 = (pos - self.global_position).normalized()
		var forward: Vector3 = -rotatable_objects.global_transform.basis.z
		var angle: float = rad_to_deg(forward.angle_to(direction_to_target))
		
		if angle < 90.0:
			return
	
	if not hittable:
		return
	
	hittable = false
	i_timer = 0.0
	
	health -= 1
	Globals.damage_taken.emit()
	$BloodParticles.restart()
	Engine.set_time_scale(0.2)
	
	if damage_tween:
		damage_tween.kill()
	damage_tween = get_tree().create_tween()
	damage_tween.set_parallel(true)
	mesh.get_active_material(0).set("shader_parameter/albedo", Color(1.0, 0.0, 0.0, 1.0))
	damage_tween.tween_property(mesh.get_active_material(0), "shader_parameter/albedo", Color(0.21, 0.72, 0.03, 1.0), 2.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	damage_tween.tween_callback(Engine.set_time_scale.bind(1.0)).set_delay(0.2)
	
	if health <= 0:
		Globals.player_died.emit()
		show_you_died_screen()
		Engine.set_time_scale(0.1)
		$AnimationPlayer.speed_scale = 10.0


func knockback(pos: Vector3, knockback_amount: float) -> void:
	if blocking:
		knockback_amount /= 2.0
	
	self.velocity += (Vector3(
		self.global_position.x - pos.x, 
		0.0, 
		self.global_position.z - pos.z
	)).normalized() * knockback_amount


func heal(amount: int) -> void:
	if health >= 3:
		return
	health += amount
	Globals.damage_taken.emit()
	$HealParticles.restart()


func show_you_died_screen() -> void:
	get_tree().get_first_node_in_group("HUD").visible = false
	$AnimationPlayer.play("YouDied")


func player_died() -> void:
	Engine.set_time_scale(1.0)
	$AnimationPlayer.speed_scale = 1.0
	get_tree().get_first_node_in_group("HUD").visible = true
	if Globals.last_bonfire_scene != "":
		Globals.player_just_died = true
		get_tree().change_scene_to_file(Globals.last_bonfire_scene)
	else:
		get_tree().change_scene_to_file("res://level/level_1.tscn")
