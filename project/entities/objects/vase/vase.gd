extends RigidBody3D


var pieces: PackedScene = preload("res://entities/objects/vase/vase_pieces.tscn")


func take_damage(_amount: int) -> void:
	var pieces_scene = pieces.instantiate()
	get_parent().add_child(pieces_scene)
	pieces_scene.transform = self.transform
	self.queue_free()
