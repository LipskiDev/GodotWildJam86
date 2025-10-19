extends StaticBody3D

var found: bool = false
@export var dmg_tick_speed := 1.0
@export var heal_tick_speed := 1.5

@export var bonfire_id: int = -1

func _ready() -> void:
	$DmgTimer.wait_time = dmg_tick_speed
	$HealTimer.wait_time = heal_tick_speed
	if bonfire_id != -1:
		if Globals.is_bonfire_lit[bonfire_id] == true:
			$VFX_fire.kindle()
			found = true
			$HealTimer.start()
			if Globals.player_just_died:
				Globals.teleport_player_to.emit($TeleportPoint.global_position)
				Globals.player_just_died = false
	
func _process(_delta: float) -> void:
	pass
	
	
func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !found:
		print("new fireplace found")
		Globals.is_bonfire_lit[bonfire_id] = true
		$VFX_fire.kindle()
		found = true
		#body.heal(1)
		$HealTimer.start()
		Globals.last_bonfire_scene = get_tree().current_scene.scene_file_path

func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage") and !found:
		body.take_damage(1)
		$DmgTimer.start()


func _on_dmg_timer_timeout() -> void:
	for body in $DamageArea.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(1)
			$DmgTimer.start()
			

func _on_heal_timer_timeout() -> void:
	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			#body.heal(1)
			$HealTimer.start()
