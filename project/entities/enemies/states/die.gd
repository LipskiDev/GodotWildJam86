extends State
class_name Die

@export var enemy: CharacterBody3D
@export var animation_tree: AnimationTree

func enter() -> void:
	print("ded")
	enemy.velocity = Vector3.ZERO
	animation_tree.set("parameters/StateMachine/conditions/die", true)
	print(animation_tree.get("parameters/StateMachine/conditions/die"))

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
