class_name Wander
extends State


@export var enemy: CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var animation_tree: AnimationTree
@export var speed := 2.0


var rand_speed: float

var idle_target: Vector3
var wander_time: float


func randomize_wander() -> void:
	animation_tree.set("parameters/StateMachine/conditions/idle", false)
	animation_tree.set("parameters/StateMachine/conditions/run", true)
	
	
	idle_target = Vector3(
			enemy.global_position.x + randf_range(-4.0, 4.0), 
			enemy.global_position.y, 
			enemy.global_position.z + randf_range(-4.0, 4.0)
		)
	nav_agent.set_target_position(idle_target)
	
	rand_speed = randf_range(0.5, speed)
	animation_tree.set("parameters/TimeScale/scale", rand_speed / speed)
	
	wander_time = randf_range(1.0, 3.0)


func enter() -> void:
	randomize_wander()


func exit() -> void:
	animation_tree.set("parameters/TimeScale/scale", 1.0)


func update(delta) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		transitioned.emit(self, "idle")


func physics_update(delta) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	enemy.velocity = (next_path_pos - enemy.global_transform.origin).normalized() * rand_speed
	gradual_turn(delta, enemy.velocity.normalized())
	
	if nav_agent.distance_to_target() < 1:
		transitioned.emit(self, "idle")


func gradual_turn(delta, target_direction: Vector3):
	if target_direction.length() > 0.1:
		var current_forward = -enemy.transform.basis.z
		var new_forward = current_forward.slerp(target_direction, 4.0 * delta)
		enemy.look_at(enemy.global_position + new_forward, Vector3.UP)
