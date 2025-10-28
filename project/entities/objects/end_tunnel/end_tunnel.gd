extends Node3D

@export var door_id: int = -1
@export var next_scene: String = ""
@export var fog_color: Color

var is_enabled : bool = false

func _ready() -> void:
	$Fog.get_active_material(0).set_shader_parameter("fog_tint", fog_color)


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass
	if body.is_in_group("Player") and is_enabled:
		Globals.play_credits.emit()


func enable_tunnel() -> void:
	is_enabled = true
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("Player"):
			Globals.play_credits.emit()
			break


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if is_enabled:
		return
	if !body.is_in_group("Player"):
		return
	var has_all_masks: bool = true
	for b in Globals.collected_masks:
		if !b:
			has_all_masks = false
	
	if has_all_masks:
		$AnimationPlayer.play("unlock_tunnel")
