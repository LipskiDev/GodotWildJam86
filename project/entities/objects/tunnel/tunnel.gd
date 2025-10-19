extends Node3D

@export var door_id: int = -1
@export var next_scene: String = ""
@export var fog_color: Color

func _ready() -> void:
	if Globals.next_door_id != -1 and Globals.next_door_id == door_id:
		Globals.teleport_player_to.emit($TeleportationPoint.global_position)
	$Fog.get_active_material(0).set_shader_parameter("fog_tint", fog_color)
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if next_scene != "":
			Globals.next_door_id = door_id
			get_tree().change_scene_to_file(next_scene)
