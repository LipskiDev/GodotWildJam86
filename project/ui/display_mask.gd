@tool
extends PanelContainer


@export var texture: Texture2D:
	set(v):
		texture = v
		_update()
@export var text: String = "Maske 1 (press shift)":
	set(v):
		text = v
		_update()
@export var selected: bool = false:
	set(v):
		selected = v
		_update()
@export var enabled: bool = false:
	set(v):
		enabled = v
		_update()


@onready var color_rect: TextureRect = %ColorRect
@onready var label: RichTextLabel = %Label


func _ready() -> void:
	_update()


func _update() -> void:
	
	if color_rect:
		color_rect.visible = enabled
		color_rect.texture = self.texture
	
	if label:
		label.visible = enabled
		label.text = self.text
	
	var style_box: StyleBoxFlat = self.get_theme_stylebox("panel")
	if enabled:
		if selected:
			style_box.border_color = Color(0.5, 0.8, 0.7, 1.0)
		else:
			style_box.border_color = Color(0.5, 0.3, 0.4, 1.0)
	else:
		style_box.border_color = Color(0.5, 0.5, 0.5, 0.5)
	self.add_theme_stylebox_override("panel", style_box)
