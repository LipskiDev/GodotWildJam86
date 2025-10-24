extends Node


@export var player: Player
@export var mask_model: Node3D


var blocking: bool = false
var tween: Tween


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and Globals.current_mask == 1:
		if tween:
			tween.kill()
		
		tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(mask_model, "scale", Vector3(1.5, 1.5, 1.5), 0.1)
		tween.tween_property(mask_model, "position", Vector3(-0.4, 0.0, 0.0), 0.1)
	
	if Input.is_action_just_released("jump") and Globals.current_mask == 1:
		if tween:
			tween.kill()
		
		tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(mask_model, "scale", Vector3(1.0, 1.0, 1.0), 0.1)
		tween.tween_property(mask_model, "position", Vector3(0.0, 0.0, 0.0), 0.1)
	
	
	if Input.is_action_pressed("jump") and Globals.current_mask == 1:
		blocking = true
	else:
		blocking = false
	player.blocking = blocking
