extends CharacterBody3D


@export var player: CharacterBody3D
@export var speed := 4.0
@export var health := 100.0


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree


var playback
const ATTACK_RANGE := 1.5
const VIEW_RANGE := 10.0


func _ready() -> void:
	playback = animation_tree.get("parameters/StateMachine/playback")


func _physics_process(delta: float) -> void:
	$Healthbar.mesh.material.set("shader_parameter/amount", (100.0 - health) / 100.0)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _target_in_attack_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func _target_in_view_range() -> bool:
	return global_position.distance_to(player.global_position) < VIEW_RANGE


func _hit_finished() -> void:
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.velocity += dir * 10.0
		print("uwu")


func take_damage(amount: int) -> void:
	health -= amount
	self.velocity.y += 10.0
	self.velocity.z += 10.0
	if health <= 0:
		die()
	else:
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "hunt")


func die() -> void:
	$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "die")
	$CollisionShape3D.shape.radius = 0.01


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "hunt")
