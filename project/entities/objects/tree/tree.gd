extends StaticBody3D


var tween: Tween


@onready var leafs: MeshInstance3D = $Leafs


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func take_damage(_amount: int) -> void:
	$CPUParticles3D.emitting = true
	
	var radius = leafs.mesh.radius
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	
	$Leafs.mesh.radius = radius * 0.5
	tween.tween_property($Leafs.mesh, "radius", radius, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
