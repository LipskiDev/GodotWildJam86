extends Node3D


func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MaskLow, "scale", Vector3(0.5, 0.5, 0.5), 2.0)
	tween.tween_property($OmniLight3D, "light_energy", 2.0, 2.0)


func _process(delta: float) -> void:
	$MaskLow.rotate_y(delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.mask_collected.emit(2)
		self.queue_free()
