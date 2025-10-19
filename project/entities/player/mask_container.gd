extends Node3D


var current_mask_model: Node3D = null
var mask_models: Array[Node3D] = []
var tween: Tween
var switch_time: float = 0.2


@onready var kaktus_mask_model: Node3D = $KaktusMaskModel
@onready var stone_mask_model: Node3D = $StoneMaskModel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.mask_switched.connect(_switch_mask)
	mask_models = [stone_mask_model, kaktus_mask_model, kaktus_mask_model, kaktus_mask_model]


func _switch_mask() -> void:
	var new_mask_model: Node3D = mask_models[Globals.current_mask]
	#printt("old:", current_mask_model)
	#printt("new:", new_mask_model)
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	if current_mask_model:
		tween.tween_property(current_mask_model, "scale", Vector3(0.1, 0.1, 0.1), switch_time)
		tween.tween_property(current_mask_model, "position", Vector3(-0.5, 0.0, 0.0), switch_time)
	
	tween.tween_property(new_mask_model, "scale", Vector3(1.0, 1.0, 1.0), switch_time)
	tween.tween_property(new_mask_model, "position", Vector3(0.0, 0.0, 0.0), switch_time)
	
	current_mask_model = new_mask_model
