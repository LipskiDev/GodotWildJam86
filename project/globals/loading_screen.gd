extends CanvasLayer


const scene_paths: Array[String] = [
	"res://entities/player/player.tscn",
	"res://entities/enemies/Jens.tscn",
	"res://entities/objects/tree/tree.tscn",
	"res://entities/objects/grass_foliage.tscn",
	"res://entities/objects/vase/vase.tscn",
	"res://entities/objects/vase/vase_pieces.tscn",
	"res://globals/all_materials.tscn",
	"res://entities/player/ground_smoke_trail.tscn",
	"res://entities/enemies/tree_enemy_rigged.tscn"
]


@onready var compile_container: Node3D = $CompileContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for scene_path in scene_paths:
		var scene = ResourceLoader.load(scene_path).instantiate()
		#print(scene)
		
		compile_scene(scene)
		
		for child in scene.get_children(true):
			compile_scene(child)
		
		compile_container.add_child(scene)
		scene.queue_free()
	
	$ColorRect.visible = false


func compile_scene(scene: Node) -> void:
	if scene == null:
		return
	
	if scene is CPUParticles3D:
		#print("particle")
		var particles := CPUParticles3D.new()
		particles.mesh = scene.mesh
		particles.emitting = true
		
		compile_container.add_child(particles)
		
		await get_tree().create_timer(0.5).timeout
		
		particles.queue_free()
	
	elif scene is MeshInstance3D:
		var material: Material
		if scene.mesh is ArrayMesh:
			material = scene.mesh.get("surface_0/material")
		else:
			material = scene.mesh.material
		#print("mesh")
		
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = BoxMesh.new()
		mesh_instance.mesh.material = material
		
		compile_container.add_child(mesh_instance)
		
		await get_tree().create_timer(0.5).timeout
		
		mesh_instance.queue_free()
