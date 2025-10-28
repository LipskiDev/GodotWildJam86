extends Area3D

var speed: float = 20.0
var direction: Vector3 = Vector3.FORWARD


func _ready() -> void:
	$LifeTimer.wait_time = 5.0
	$LifeTimer.start()
	look_at(global_position + direction)
	rotation.y += PI / 2.0


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if body is Cactus:
		return
	
	if body.has_method("pop"):
		body.pop()
	
	if body.has_method("take_damage"): 
		body.take_damage(1, self.global_position - direction * 10.0)
	
	if body.has_method("knockback"):
		body.knockback(self.global_position - direction * 10.0, 10.0)
	
	queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
