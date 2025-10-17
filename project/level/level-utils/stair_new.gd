@tool
extends CSGPolygon3D


@export_range(1, 128)
var steps: int = 8:
	set(v):
		steps = v
		create_stairs()
@export_range(0.0, 1.0, 0.01)
var step_height: float = 0.15:
	set(v):
		step_height = v
		create_stairs()
@export_range(0.0, 100.0, 0.02)
var step_width: float = 0.5:
	set(v):
		step_width = v
		create_stairs()


var points: Array[Vector2] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func create_stairs() -> void:
	points.clear()
	points.append(Vector2(0.0, 0.0))
	
	var height: float = steps * step_height
	
	for i in steps:
		points.append(Vector2(step_width * i, height - step_height * i))
		points.append(Vector2(step_width * (i + 1), height - step_height * i))
	
	points.append(Vector2(step_width * steps, 0.0))
	
	self.polygon = PackedVector2Array(points)
	
	
