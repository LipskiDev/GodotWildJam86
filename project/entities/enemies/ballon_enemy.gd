extends CharacterBody3D


var player: Player = null
var check_time: float = 1.0
var time: float = 0.0
var speed: float = 8.0

var maske: PackedScene = preload("res://entities/masks/movement_mask.tscn")


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	time += delta
	if player:
		time = 0.0
		var direction_from_player = (self.global_position - player.global_position)
		var flee_target = self.global_position + direction_from_player
		
		navigation_agent_3d.target_position = flee_target
	
	if not navigation_agent_3d.is_navigation_finished():
		var next_position = navigation_agent_3d.get_next_path_position()
		var direction = (next_position - self.global_position).normalized()
		
		self.rotation.y = atan2(direction.x, direction.z) + PI / 2.0
		
		velocity = direction * speed
		move_and_slide()


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		time = check_time


func _on_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null


func pop() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Balloon, "position", Vector3(0.0, -2.0, 0.0), 0.7)
	tween.tween_property($Balloon, "scale", Vector3(0.1, 0.1, 0.1), 0.7)
	
	await get_tree().create_timer(1.0).timeout
	
	var maske_scene: Node3D = maske.instantiate()
	get_tree().root.get_child(0).add_child(maske_scene)
	maske_scene.global_position = self.global_position
	
	self.queue_free()
