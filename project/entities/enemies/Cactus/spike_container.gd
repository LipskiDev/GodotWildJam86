extends Node


var spike_scene: PackedScene = preload("res://entities/enemies/Cactus/spike.tscn")


func _ready() -> void:
	Globals.shoot_spike.connect(_on_shoot_spike)


func _on_shoot_spike(pos: Vector3, dir: Vector3):
	var spike = spike_scene.instantiate()
	spike.position = pos
	spike.direction = dir
	$".".add_child(spike)
