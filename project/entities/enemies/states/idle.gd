class_name Idle
extends State


@export var enemy: CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var animation_tree: AnimationTree


var idle_target: Vector3
var idle_time: float


func randomize_idle() -> void:
	enemy.velocity = Vector3.ZERO
	animation_tree.set("parameters/StateMachine/conditions/idle", true)
	animation_tree.set("parameters/StateMachine/conditions/run", false)
	idle_time = randf_range(1.0, 5.0)


func enter() -> void:
	randomize_idle()


func update(delta) -> void:
	if idle_time > 0:
		idle_time -= delta
	else:
		transitioned.emit(self, "wander")


func physics_update(_delta) -> void:
	pass
