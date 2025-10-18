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

func _ready() -> void:
	$EyeLeft.light_energy = 0.0
	$EyeRight.light_energy = 0.0
	
func _process(_delta: float) -> void:
	pass
	



func _on_detection_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
