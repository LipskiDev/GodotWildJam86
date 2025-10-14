class_name Squash
extends State

@export var enemy: CharacterBody3D
@export var animation_tree: AnimationTree
@export var body: MeshInstance3D
@export var leg1: MeshInstance3D
@export var leg2: MeshInstance3D

var squash_timer: float
const squash_speed = 0.01
var desquash_speed = 1
	
func enter() -> void:
	print("jens is squashed :(")
	enemy.velocity = Vector3.ZERO
	squash_timer = 3
	squash()

func exit() -> void:
	pass


func update(delta: float) -> void:
	squash_timer -= delta


func physics_update(_delta: float) -> void:
	if squash_timer <= 0:
		desquash()

func squash():
	var squash_tween = get_tree().create_tween()
	squash_tween.set_parallel(true)
	squash_tween.tween_property(body, "scale", Vector3(1, 0.1, 1), squash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	squash_tween.tween_property(body, "position", Vector3(0, -0.3, 0), squash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	squash_tween.tween_property(leg1, "position", Vector3(0.7, -0.3, 0), squash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	squash_tween.tween_property(leg2, "position", Vector3(-0.7, -0.3, 0), squash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
func desquash():
	var desquash_tween = get_tree().create_tween()
	desquash_tween.set_parallel(true)
	desquash_tween.tween_property(body, "scale", Vector3(1, 1, 1), desquash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	desquash_tween.tween_property(body, "position", Vector3(0, 0, 0), desquash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	desquash_tween.tween_property(leg1, "position", Vector3(0.4, -0.3, 0), desquash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	desquash_tween.tween_property(leg2, "position", Vector3(-0.4, -0.3, 0), desquash_speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	animation_tree.set("parameters/StateMachine/conditions/squash", false)
	animation_tree.set("parameters/StateMachine/conditions/idle", true)
