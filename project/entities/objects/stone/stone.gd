extends RigidBody3D

var pieces: PackedScene = preload("res://entities/objects/stone/stone_pieces.tscn")

func rock_smash() -> void:
	var pieces_scene = pieces.instantiate()
	get_parent().add_child(pieces_scene)
	pieces_scene.transform = self.transform
	self.queue_free()
