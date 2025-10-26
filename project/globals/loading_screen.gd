extends CanvasLayer


const scene_paths: Array[String] = [
	"res://entities/player/player.tscn",
	"res://entities/player/dither.tscn",
	"res://entities/player/ground_smoke_trail.tscn",
	"res://entities/player/block_particles.tscn",
	"res://entities/player/blood_particles.tscn",
	"res://entities/player/heal_particles.tscn",
	
	"res://entities/enemies/Jens.tscn",
	"res://entities/enemies/tree_enemy_rigged.tscn",
	"res://entities/enemies/Cactus/cactus.tscn",
	"res://entities/enemies/Cactus/spike.tscn",
	"res://entities/enemies/ballon_enemy.tscn",
	
	"res://entities/masks/kaktus_mask.tscn",
	"res://entities/masks/kaktus_mask_model.tscn",
	"res://entities/masks/movement_mask.tscn",
	"res://entities/masks/movement_mask_model.tscn",
	"res://entities/masks/stone_mask.tscn",
	"res://entities/masks/stone_mask_model.tscn",
	"res://entities/masks/wood_mask.tscn",
	"res://entities/masks/wood_mask_model.tscn",
	
	"res://entities/objects/cactus_small/cactus_small.tscn",
	"res://entities/objects/cactus_still/cactus_still.tscn",
	"res://entities/objects/end_tunnel/end_tunnel.tscn",
	"res://entities/objects/fence/fence.tscn",
	"res://entities/objects/fire/fireplace.tscn",
	"res://entities/objects/fire/vfx_fire.tscn",
	"res://entities/objects/stone/stone.tscn",
	"res://entities/objects/stone/stone_pieces.tscn",
	"res://entities/objects/tree/tree.tscn",
	"res://entities/objects/tunnel/tunnel.tscn",
	"res://entities/objects/well/well.tscn",
	"res://entities/objects/fake_jens.tscn",
	"res://entities/objects/flowers.tscn",
	"res://entities/objects/grass_foliage.tscn",
	"res://entities/objects/vase/vase.tscn",
	"res://entities/objects/vase/vase_pieces.tscn",
	"res://entities/objects/obelisk.tscn",
	"res://entities/objects/waysign.tscn",
	
	"res://level/level_1.tscn",
	"res://level/level_2.tscn",
	"res://level/level_3.tscn",
	"res://level/level_4.tscn",
	"res://level/level_5.tscn",
	
	"res://globals/all_materials.tscn"
]


@onready var compile_container: Node3D = $CompileContainer
@onready var progress_bar: ProgressBar = $ColorRect/VBoxContainer/ProgressBar


func _ready() -> void:
	var amount: int = scene_paths.size()
	var step_size: float = 100.0 / amount
	for scene_path in scene_paths:
		progress_bar.value += step_size
		var scene = ResourceLoader.load(scene_path).instantiate()
		#print(scene)
		compile_scene(scene)
		
		for child in scene.get_children(true):
			compile_scene(child)
			#await get_tree().create_timer(0.2).timeout
		
		#compile_container.add_child(scene)
		await get_tree().create_timer(0.1).timeout
		#scene.queue_free()
	
	$ColorRect.visible = false
	get_tree().change_scene_to_file("res://level/level_1.tscn")


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
		if scene.mesh == null:
			return
		var material: Material
		#printt("scene: ", scene)
		#printt("mesh: ", scene.mesh)
		if scene.mesh is ArrayMesh:
			material = scene.mesh.get("surface_0/material")
		else:
			material = scene.mesh.material
		
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = BoxMesh.new()
		mesh_instance.mesh.material = material
		
		compile_container.add_child(mesh_instance)
		
		await get_tree().create_timer(0.5).timeout
		
		mesh_instance.queue_free()
