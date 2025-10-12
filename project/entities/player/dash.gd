extends Node


@export var player: Player
@export var rotation_object: Node3D

@export var dash_force: float = 40.0
@export var dash_time: float = 0.1
@export var max_charges: int = 4


var dash_cur: bool = false
var charges: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charges = max_charges


func _physics_process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		print("dash")
		if charges > 0:
			dash_cur = true
			charges -= 0
			player.velocity = rotation_object.global_basis * Vector3(0.0, 0.0, -1.0) * dash_force
			await get_tree().create_timer(dash_time).timeout
			player.velocity *= 0.1
