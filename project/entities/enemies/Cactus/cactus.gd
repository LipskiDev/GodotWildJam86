extends CharacterBody3D

@export var shoot_speed: int = 3
var health: int = 100
var player: Player = null
var player_locked: bool = false
var tween: Tween

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$EyeLeft.light_energy = 0.0
	$EyeRight.light_energy = 0.0
	
func _process(delta: float) -> void:
	if player_locked:
		var direction: Vector3 = player.global_position - global_position
		direction.y = 0
		direction = direction.normalized()
		var target_y_rotation: float = atan2(direction.x, direction.z) + 3.0/2.0*PI
		self.rotation.y = lerp_angle(rotation.y, target_y_rotation, 2.0 * delta)


func attack():
	print("cactus: attack")
	var start_pos = $SpikeSpawn.global_position
	var direction: Vector3 = player.global_position - global_position
	direction.y = 0
	$ShootTimer.start()
	Globals.shoot_spike.emit(start_pos, direction)
	
func take_damage(dmg: int):
	print("cactus: takes damage")
	health -= dmg;
	if health <= 0:
		die()

func die():
	queue_free()
	

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("cactus: player detected")
		$EyeLeft.light_energy = 1.0
		$EyeRight.light_energy = 1.0
		player = body
		player_locked = true
		attack()


func _on_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("cactus: player left")
		player = null
		player_locked = false


func _on_shoot_timer_timeout() -> void:
	if player_locked:
		attack()


func _on_dmg_area_body_entered(body: Node3D) -> void:
	pass
