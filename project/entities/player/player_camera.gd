extends Node3D


@export var player: Player
@export var distance: float = 10.0
@export var angle: float = -45.0


@onready var player_camera_3d: Camera3D = %PlayerCamera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.rotation_degrees.x = angle
	player_camera_3d.position.z = distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.position = player.global_position
