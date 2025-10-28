extends Node3D

var time: float = 0.0
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	time -= delta
	if time <= 0.0:
		time = rng.randf_range(5, 10.0)
		play_idle()
		
func play_idle():
	print("ïdling")
	var idle_tween = get_tree().create_tween()
	idle_tween.tween_property($".", "position", 2.0, 1.0)
