
class_name Hunt
extends State


@export var enemy: CharacterBody3D
@export var speed := 3.0
@export var nav_agent: NavigationAgent3D
@export var animation_tree: AnimationTree
@export var attack_range = 2.0


var player: CharacterBody3D
var hunt_timer: float


func enter() -> void:
	print("jens goes hunting")
	player = get_tree().get_first_node_in_group("Player")
	animation_tree.set("parameters/StateMachine/conditions/idle", false)
	animation_tree.set("parameters/StateMachine/conditions/run", true)
	hunt_timer = 10.0


func exit() -> void:
	pass


func update(delta: float) -> void:
	hunt_timer -= delta


func physics_update(delta: float) -> void:
	match animation_tree.get("parameters/StateMachine/playback").get_current_node():
		"run":
			nav_agent.set_target_position(player.global_position)
			var next_path_pos = nav_agent.get_next_path_position()
			enemy.velocity = (next_path_pos - enemy.global_transform.origin).normalized() * speed
			gradual_turn(delta, enemy.velocity.normalized())
		"attack":
			enemy.velocity = Vector3.ZERO
	
	if !_target_in_view_range() and hunt_timer < 0:
		print("player escaped, back to idle")
		transitioned.emit(self, "idle")
	
	if _target_in_attack_range():
		animation_tree.set("parameters/StateMachine/conditions/attack", true)
	else:
		animation_tree.set("parameters/StateMachine/conditions/attack", false)


func gradual_turn(delta, target_direction: Vector3):
	if target_direction.length() > 0.1:
		var current_forward = -enemy.transform.basis.z
		var new_forward = current_forward.slerp(target_direction, 4.0 * delta)
		enemy.look_at(enemy.global_position + new_forward, Vector3.UP)


func _target_in_attack_range() -> bool:
	return enemy.global_position.distance_to(player.global_position) < attack_range


func _target_in_view_range() -> bool:
	return enemy.global_position.distance_to(player.global_position) < 10.0
