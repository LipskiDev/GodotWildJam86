@tool
extends Node3D


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
var step_width: float = 2.0:
	set(v):
		step_width = v
		create_stairs()
@export_range(0.0, 10.0, 0.1)
var step_depth: float = 1.0:
	set(v):
		step_depth = v
		create_stairs()
@export var material: Material:
	set(v):
		material = v
		create_stairs()
@export var filled: bool = true:
	set(v):
		filled = v
		create_stairs()
@export var subtract: bool = false: ## TODO
	set(v):
		subtract = v
		create_stairs()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func create_box(left_pos: float, i: int) -> CSGBox3D:
	var box: CSGBox3D = CSGBox3D.new()
	box.operation = CSGShape3D.OPERATION_SUBTRACTION if subtract else CSGShape3D.OPERATION_UNION
	box.size = Vector3(step_width, step_height, step_depth)
	box.position.z = left_pos - i * step_depth
	box.position.y = i * step_height
	
	box.use_collision = true
	
	box.material = material
	return box


func create_stairs() -> void:
	#print("deleting stairs")
	for box in get_children():
		box.queue_free()
	
	#print("creating stairs")
	var left_pos: float = steps * step_depth / 2.0
	
	for i in steps:
		add_child(create_box(left_pos, i))
	
	if not filled:
		return
	
	for i in steps - 1:
		for j in steps - 1:
			if i >= j - 1:
				var box: CSGBox3D = create_box(left_pos, i + 1)
				box.operation = CSGShape3D.OPERATION_SUBTRACTION if subtract else CSGShape3D.OPERATION_UNION
				box.position.y -= step_height * j + step_height
				if box.position.y >= 0.0:
					add_child(box)
