extends Node3D


@export var player: Player
@export var distance: float = 10.0
@export var angle: float = -45.0
@export var sway_amount: float = 0.1


var last_position: Vector3 = Vector3(0.0, 0.0, 0.0)


@onready var player_camera_3d: Camera3D = %PlayerCamera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.rotation_degrees.x = angle
	player_camera_3d.position.z = distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	self.global_position = player.global_position * sway_amount + last_position * (1.0 - sway_amount)
	last_position = self.global_position
