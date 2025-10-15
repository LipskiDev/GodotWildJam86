class_name Jens
extends CharacterBody3D

@export var player: CharacterBody3D
@export var speed := 4.0
@export var health := 100.0
@export var knockback_strength := 20.0


var playback


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack_area: Area3D = %AttackArea


func _ready() -> void:
	playback = animation_tree.get("parameters/StateMachine/playback")


func _physics_process(delta: float) -> void:
	$Healthbar.mesh.material.set("shader_parameter/amount", (100.0 - health) / 100.0)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _hit_finished() -> void:
	attack_area.monitoring = true
	await get_tree().create_timer(0.1).timeout
	attack_area.monitoring = false


func take_damage(amount: int) -> void:
	health -= amount
	
	# BUG: knockback funktoiniert nicht so richtig 
	# weil die velocity von dem nav agent geregelt wird
	# self.velocity.y += 0.0
	# self.velocity.z += 10.0
	
	if health <= 0:
		die()
	else:
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "hunt")


func die() -> void:
	$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "die")
	#$CollisionShape3D.shape.radius = 0.01


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "hunt")


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
	
	if body is CharacterBody3D:
		body.velocity += (Vector3(
				body.global_position.x - self.global_position.x, 
				0.0, 
				body.global_position.z - self.global_position.z
			)).normalized() * knockback_strength
			
func squash(dmg: int):
	health -= dmg
	if health <= 0:
		die()
	else:
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "squash")
		
