class_name Squash
extends State


@export var enemy: CharacterBody3D
@export var animation_tree: AnimationTree
var player: CharacterBody3D

func enter() -> void:
	print("jens is squashed")
	enemy.velocity = Vector3.ZERO
	animation_tree.set("parameters/StateMachine/conditions/squash", true)

func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
