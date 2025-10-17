class_name Squash
extends State


@export var enemy: CharacterBody3D
@export var animation_tree: AnimationTree


func enter() -> void:
	print("jens is squashed :(")
	enemy.velocity = Vector3.ZERO
	animation_tree.set("parameters/StateMachine/conditions/squash", true)
	
	await get_tree().create_timer(2.3).timeout
	
	animation_tree.set("parameters/StateMachine/conditions/squash", false)
	animation_tree.set("parameters/StateMachine/conditions/idle", true)
	transitioned.emit(self, "idle")

func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
