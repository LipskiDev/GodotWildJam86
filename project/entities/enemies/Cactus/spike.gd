extends Area3D

var speed: int = 5
var direction: Vector3 = Vector3.FORWARD

	
func _ready() -> void:
	$LifeTimer.wait_time = 5.0
	$LifeTimer.start()
	look_at(global_position + direction)
	rotation.y += PI/2

func _process(delta: float) -> void:
	position += direction * speed * delta
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1)
		queue_free()
	elif body.has_method("pop"):
		body.pop()
		queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
