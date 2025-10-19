extends Node3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D = $Armature/Skeleton3D/BoneAttachment3D/AttackArea


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and Globals.current_mask == 1:
		animation_player.play("Attack")
		attack_area.monitoring = true
		
		await get_tree().create_timer(0.6).timeout
		
		attack_area.monitoring = false


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	if body.has_method("take_damage_stick"):
		body.take_damage_stick(1)
	elif body.has_method("take_damage"):
		body.take_damage(1)
