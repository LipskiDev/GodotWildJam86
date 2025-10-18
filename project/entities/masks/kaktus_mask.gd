extends Node3D


func _process(delta: float) -> void:
	$MaskLow.rotate_y(delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.mask_collected.emit(2)
		self.queue_free()
