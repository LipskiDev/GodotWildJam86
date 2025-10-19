extends HBoxContainer


@onready var heart: TextureRect = $Heart
@onready var heart_2: TextureRect = $Heart2
@onready var heart_3: TextureRect = $Heart3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.damage_taken.connect(_update)


func _update() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	var health: int = player.health
	heart.visible = health >= 1
	heart_2.visible = health >= 2
	heart_3.visible = health >= 3
