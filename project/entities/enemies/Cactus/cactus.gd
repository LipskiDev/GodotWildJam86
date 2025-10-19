extends CharacterBody3D


@export var shoot_cooldown: int = 3
@export var contact_hit_cooldown: int = 3


var health: int = 100
var player: Player = null
var player_locked: bool = false
var player_touching: bool = true
var tween: Tween
var kaktus_mask: PackedScene = preload("res://entities/masks/kaktus_mask.tscn")


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	#$EyeLeft.light_energy = 0.0
	#$EyeRight.light_energy = 0.0
	$ShootTimer.wait_time = shoot_cooldown
	$ContactHitTimer.wait_time = contact_hit_cooldown


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
	if animation_player.current_animation == "die":
		return
	
	health -= dmg
	if health <= 0:
		die()
		var mask_scene: Node3D = kaktus_mask.instantiate()
		get_tree().root.get_child(0).add_child(mask_scene)
		mask_scene.global_position = self.global_position
	
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	#tween.set_parallel(true)
	$Body.scale = Vector3(0.2, 1.0, 0.2)
	tween.tween_property($Body, "scale", Vector3(1.0, 1.0, 1.0), 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	#mesh.get("surface_0/material").
	#tween.tween_property(mesh.get("surface_0/material"), "albedo_color", Color(1.0, 1.0, 1.0), 1.0)


func die():
	animation_player.queue("die")
	

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("cactus: player detected")
		#$EyeLeft.light_energy = 1.0
		#$EyeRight.light_energy = 1.0
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
	if body.is_in_group("Player"):
	#	player.die()
		body.take_damage(1)
		player_touching = true
		$ContactHitTimer.start()
	


func _on_dmg_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_touching = false


func _on_contact_hit_timer_timeout() -> void:
	if player_touching:
		player.take_damage(1)
		player_touching = true
		$ContactHitTimer.start()
