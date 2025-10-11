extends Node3D


@onready var area_3d: Area3D = %Area3D
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		area_3d.monitoring = true
		mesh_instance_3d.visible = true
		await get_tree().create_timer(0.1).timeout
		area_3d.monitoring = false
		mesh_instance_3d.visible = false


func _on_area_3d_body_entered(_body: Node3D) -> void:
	print("hit")
