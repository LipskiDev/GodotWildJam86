@tool
extends VBoxContainer


@export var texture: Texture2D:
	set(v):
		texture = v
		_update()
@export var text: String = "Maske 1 (press shift)":
	set(v):
		text = v
		_update()


@onready var color_rect: TextureRect = $ColorRect
@onready var label: RichTextLabel = $Label


func _ready() -> void:
	_update()


func _update() -> void:
	if color_rect:
		color_rect.texture = self.texture
	
	if label:
		label.text = self.text
