extends Node3D


var player: Player


@onready var mesh: Mesh = $MeshInstance3D.mesh


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#print(mesh.material.get("shader_parameter/player_pos"))
	mesh.material.set("shader_parameter/player_pos", player.global_position)
