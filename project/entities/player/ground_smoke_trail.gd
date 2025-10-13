extends Node3D



@export var pos_leeway: float = 0.1
@export var min_velocity: float = 2.0
@export var min_depth: float = 5.0


var last_pos: Vector3 = Vector3(0.0, 0.0, 0.0)
var queue_big: bool = false

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var cpu_particles_3d_2: CPUParticles3D = $CPUParticles3D2
@onready var ray_cast_3d: RayCast3D = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var pos: Vector3 = self.global_position
	var speed: float = pos.distance_to(last_pos)
	
	var depth = last_pos.y - pos.y
	if depth >= min_depth * delta:
		queue_big = true
	
	if speed >= min_velocity * delta:
		ray_cast_3d.force_raycast_update()
		var collision_point = ray_cast_3d.get_collision_point()
		
		if collision_point.y <= self.global_position.y + pos_leeway and collision_point.y >= self.global_position.y - pos_leeway:
			cpu_particles_3d.emitting = true
			if queue_big:
				cpu_particles_3d_2.emitting = true
				queue_big = false
		else:
			cpu_particles_3d.emitting = false
	else:
		cpu_particles_3d.emitting = false
	
	last_pos = self.global_position
