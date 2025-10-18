extends CharacterBody3D


var health: int = 100
var player: Player = null
var attack_time: float = 0.5
var time: float = 0.0
var player_locked: bool = false
var attacking: bool = false
var tween: Tween


@onready var damage_area: Area3D = $Armature/Skeleton3D/BoneAttachment3D/DamageArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh: MeshInstance3D = $Armature/Skeleton3D/Cylinder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player_locked:
		var direction: Vector3 = player.global_position - global_position
		direction.y = 0
		direction = direction.normalized()
		var target_y_rotation: float = atan2(direction.x, direction.z) + PI
		self.rotation.y = lerp_angle(rotation.y, target_y_rotation, 2.0 * delta)
		
		time += delta
		
		if time > attack_time + randf_range(0.0, 0.5) and not attacking:
			attacking = true
			attack()


func attack() -> void:
	if animation_player.current_animation == "die":
		return
	
	damage_area.monitoring = true
	if randi() % 2 == 0:
		animation_player.play("pray")
	else:
		animation_player.play("attack")
 

func take_damage(amount: int) -> void:
	if animation_player.current_animation == "die":
		return
	
	health -= amount
	if health <= 0:
		animation_player.queue("die")
	
	$HitParticles.emitting = true
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	#tween.set_parallel(true)
	mesh.scale = Vector3(0.2, 1.0, 0.2)
	tween.tween_property(mesh, "scale", Vector3(1.0, 1.0, 1.0), 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	#mesh.get("surface_0/material").
	#tween.tween_property(mesh.get("surface_0/material"), "albedo_color", Color(1.0, 1.0, 1.0), 1.0)


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		player_locked = true


func _on_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		player_locked = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack" or anim_name == "pray":
		time = 0.0
		attacking = false
		damage_area.monitoring = false


func _on_damage_area_body_entered(body: Node3D) -> void:
	if body == self:
		return
	
	if body.has_method("take_damage"): 
		body.take_damage(10)
	
	if body is Player:
		body.velocity += (body.global_position - self.global_position).normalized() * 10.0
