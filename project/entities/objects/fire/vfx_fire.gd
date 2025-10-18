extends Node3D

func _ready() -> void:
	$OmniLight3D.light_energy = 0.25
	$Smoke.scale_amount_min = 2.0 / 4
	$Smoke.scale_amount_max = 2.0 / 4
	$Embers.scale_amount_min = 0.2 / 4
	$Embers.scale_amount_max = 0.4 / 4
	$".".scale.x = 1.0 / 4
	$".".scale.y = 1.0 / 4
	$".".scale.z = 1.0 / 4
	
func _process(_delta: float) -> void:
	pass
	
func kindle():
	print("kindle")
	var kindle_tween = get_tree().create_tween()
	kindle_tween.set_parallel(true)
	kindle_tween.tween_property($OmniLight3D, "light_energy", 10.0, 2.0)
	kindle_tween.tween_property($Smoke, "scale_amount_min", 2.0, 2.0)
	kindle_tween.tween_property($Smoke, "scale_amount_max", 2.0, 2.0)
	kindle_tween.tween_property($Embers, "scale_amount_min", 0.2, 2.0)
	kindle_tween.tween_property($Embers, "scale_amount_max", 0.4, 2.0)
	kindle_tween.tween_property($".", "scale", Vector3(1.0, 1.0, 1.0), 2.0)

	#$OmniLight3D.light_energy = 1.0
	#$Smoke.scale_amount_min = 2.0
	#$Smoke.scale_amount_max = 2.0
	#$Embers.scale_amount_min = 0.2
	#$Embers.scale_amount_max = 0.4
	#$".".scale.x = 1.0
	#$".".scale.y = 1.0
	
