extends Area3D

func _ready() -> void:
	$LifeTimer.wait_time = 5.0
	$LifeTimer.start()

func _process(_delta: float) -> void:
	pass
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1)
		queue_free()
	elif body.has_method("pop"):
		body.pop()
		queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
