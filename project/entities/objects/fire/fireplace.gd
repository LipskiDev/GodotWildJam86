extends StaticBody3D

var found: bool = false
@export var dmg_tick_speed := 1.0
@export var heal_tick_speed := 1.5

func _ready() -> void:
	$DmgTimer.wait_time = dmg_tick_speed
	$HealTimer.wait_time = heal_tick_speed
	
func _process(_delta: float) -> void:
	pass
	
	
func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !found:
		print("new fireplace found")
		$VFX_fire.kindle()
		found = true
		#body.heal(1)
		$HealTimer.start()

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
