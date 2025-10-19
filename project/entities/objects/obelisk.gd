extends StaticBody3D

@export var area_material: StandardMaterial3D

func _ready() -> void:
	$Cube.set_surface_override_material(1, area_material)
