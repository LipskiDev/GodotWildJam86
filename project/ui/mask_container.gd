extends VBoxContainer


@onready var display_mask_up: PanelContainer = $HBoxContainer/DisplayMaskUp
@onready var display_mask_left: PanelContainer = $HBoxContainer2/DisplayMaskLeft
@onready var display_mask_right: PanelContainer = $HBoxContainer2/DisplayMaskRight
@onready var display_mask_down: PanelContainer = $HBoxContainer3/DisplayMaskDown


func _ready() -> void:
	Globals.mask_collected.connect(_mask_collected)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mask_up"):
		display_mask_up.selected = true
		display_mask_left.selected = false
		display_mask_right.selected = false
		display_mask_down.selected = false
	
	if event.is_action_pressed("mask_left"):
		display_mask_up.selected = false
		display_mask_left.selected = true
		display_mask_right.selected = false
		display_mask_down.selected = false
	
	if event.is_action_pressed("mask_right"):
		display_mask_up.selected = false
		display_mask_left.selected = false
		display_mask_right.selected = true
		display_mask_down.selected = false
	
	if event.is_action_pressed("mask_down"):
		display_mask_up.selected = false
		display_mask_left.selected = false
		display_mask_right.selected = false
		display_mask_down.selected = true


func _mask_collected(n: int) -> void:
	match n:
		0:
			display_mask_up.enabled = true
		1:
			display_mask_left.enabled = true
		2:
			display_mask_right.enabled = true
		3:
			display_mask_down.enabled = true
