extends HBoxContainer


var h0: bool = true
var h1: bool = true
var h2: bool = true
var tween: Tween
var time: float = 0.5


@onready var heart: TextureRect = $Heart
@onready var heart_2: TextureRect = $Heart2
@onready var heart_3: TextureRect = $Heart3


func _ready() -> void:
	Globals.damage_taken.connect(_update)


func _update() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	var health: int = player.health
	
	if h0 != (health >= 1):
		h0 = health >= 1
		_change_heart(heart, h0)
	
	if h1 != (health >= 2):
		h1 = health >= 2
		_change_heart(heart_2, h1)
	
	if h2 != (health >= 3):
		h2 = health >= 3
		_change_heart(heart_3, h2)


func _change_heart(heart_texture: TextureRect, dir: bool) -> void:
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	
	if dir:
		tween.tween_property(heart_texture, "heart_scale", 1.0, time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(heart_texture, "heart_scale", 0.0, time).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
