extends Node3D


var attack_time: float = 0.5
var time: float = 0.0


@onready var animation_player: AnimationPlayer = $"../schleim/AnimationPlayer"
@onready var spike_spawn_point: Marker3D = $SpikeSpawnPoint


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and Globals.current_mask == 0 and $"../..".velocity.y < 0.1:
		animation_player.play("stone_smash")
	
	if event.is_action_pressed("attack") and Globals.current_mask == 2 and time > attack_time:
		var start_pos = spike_spawn_point.global_position
		var direction: Vector3 = start_pos - $"../..".global_position
		direction = direction.normalized()
		direction.y = 0
		Globals.shoot_spike.emit(start_pos, direction)
		time = 0.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	
	if body.has_method("take_damage"):
		body.take_damage(1)
	
	if body.has_method("rock_smash"):
		body.rock_smash()
	
	if body is RigidBody3D:
		body.apply_impulse((body.global_position - self.global_position).normalized() * 3.0)
