extends Node


@export var player: Player
@export var rotation_object: Node3D

@export var dash_force: float = 80.0
@export var dash_time: float = 0.1
@export var max_charges: int = 4
@export var dash_spam_delay_ms: int = 400


var dash_cur: bool = false
var charges: int
var last_dash_time: int = 0


@onready var animation_player: AnimationPlayer = $"../RotatableObjects/schleim/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charges = max_charges


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and (Time.get_ticks_msec() - last_dash_time) > dash_spam_delay_ms:
		last_dash_time = Time.get_ticks_msec()
		if charges > 0:
			dash_cur = true
			charges -= 0
			player.velocity = rotation_object.global_basis * Vector3(0.0, 0.0, -1.0) * dash_force
			animation_player.play("sprint start")
			await get_tree().create_timer(dash_time).timeout
			player.velocity *= 0.1
			animation_player.play("sprint end")
